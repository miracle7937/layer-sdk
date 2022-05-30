import 'package:bloc/bloc.dart';
import '../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';
import 'appointment_states.dart';

/// Holds Appointments data
class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository _repository;
  final ProductRepository _productRepository;
  final BranchRepository _branchRepository;

  /// Creates a new [AppointmentCubit] instance
  AppointmentCubit({
    required AppointmentRepository repository,
    required ProductRepository productRepository,
    required BranchRepository branchRepository,
  })  : _repository = repository,
        _productRepository = productRepository,
        _branchRepository = branchRepository,
        super(AppointmentState());

  /// Loads appointment data
  Future<void> load() async {
    emit(
      state.copyWith(
        busy: true,
        error: AppointmentStateError.none,
      ),
    );

    try {
      final appointments = await _repository.listAppointments();

      if (appointments.isNotEmpty) {
        final appointment = appointments.first;
        final futuRes = await Future.wait<dynamic>([
          _branchRepository.getBranchById(appointment.branch),
          _fetchProducts(appointment),
        ]);
        final Branch branch = futuRes[0];
        final List<Product> products = futuRes[1];

        emit(
          state.copyWith(
            branch: branch,
            products: products,
            appointment: appointment,
            busy: false,
            error: AppointmentStateError.none,
          ),
        );
      } else {
        emit(
          state.copyWith(
            busy: false,
            error: AppointmentStateError.none,
            forceNullAppointment: true,
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? AppointmentStateError.network
              : AppointmentStateError.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }

  /// Maps the list of product codes to a list of Product requests, wait for all
  /// the responses, then delete any null product caused by a network issue
  Future<List<Product>> _fetchProducts(Appointment appointment) {
    return Future.wait(appointment.subject.split(',').map((e) async {
      try {
        final _product = await _productRepository.fetchProduct(e);
        return _product;
      } on Exception {
        // In case of a network error while fetching the product, return null
        // then filter the list to remove all null products.
        return null;
      }
    }).toList())
        .then((value) =>
            value.where((element) => element != null).map((e) => e!).toList());
  }
}
