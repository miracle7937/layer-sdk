import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import '../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';

import 'appointment_booking_state.dart';

/// Cubit that handle inserting, editing, deleting appointments
class AppointmentBookingCubit extends Cubit<AppointmentBookingState> {
  final AppointmentRepository _repository;

  /// Creates a new [AppointmentCubit]
  AppointmentBookingCubit(
    AppointmentRepository repository,
  )   : _repository = repository,
        super(AppointmentBookingState());

  int? _slotTime;

  /// Creates a new [AppointmentCubit] for editing
  AppointmentBookingCubit.forEdit({
    required AppointmentRepository repository,
    required String appointmentId,
    required Branch branch,
    required Iterable<Product> products,
    required DateTime selectedDate,
    required BranchTimeSlot selectedTimeSlot,
    String notes = '',
  })  : _repository = repository,
        super(
          AppointmentBookingState(
            branch: branch,
            products: UnmodifiableListView(products),
            selectedDate: selectedDate,
            selectedTimeSlot: selectedTimeSlot,
            appointmentId: appointmentId,
            notes: notes,
          ),
        );

  /// Set the selected timeslot
  void setSelectedTimeSlot(BranchTimeSlot time) {
    emit(
      state.copyWith(
        selectedTimeSlot: time,
      ),
    );
  }

  /// Set the selected Date for the appointment
  void setSelectedDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,
      ),
    );

    _checkForAppointmentTimeSlots();
  }

  /// In Which branch the appointment is being done
  void setBranch(Branch branch) {
    emit(
      state.copyWith(
        branch: branch,
      ),
    );

    _checkForAppointmentTimeSlots();
  }

  /// Products that the user will talk about
  void setSelectedProducts(Iterable<Product> products) {
    emit(
      state.copyWith(
        products: UnmodifiableListView(products),
      ),
    );

    _checkForAppointmentTimeSlots();
  }

  /// Notes included by the user
  void setNotes(String notes) {
    emit(
      state.copyWith(notes: notes),
    );
  }

  /// Load timeslots when editing
  Future<void> load() async {
    _checkForAppointmentTimeSlots();
  }

  /// Verifies if the branch and date is set
  /// if true, prepares a list os available timeslots
  void _checkForAppointmentTimeSlots() async {
    if (state.branch != null &&
        state.selectedDate != null &&
        state.products.isNotEmpty) {
      try {
        /// Emits a state indicating that it is loading the timeslots
        emit(
          state.copyWith(
            freeTimeStatus: AppointmentFreeTimeStatus.loading,
            errorMessage: '',
          ),
        );

        final response = await _repository.listBranchFreeTime(
          state.branch!.id,
          state.selectedDate!,
        );

        _slotTime = response.first.slotTime;

        final timeSlots = _buildFreeTime(response.first);
        final isSelectedTimeslotAvailable =
            _isSelectedTimeAvailable(state.selectedTimeSlot, timeSlots);

        final timeslot =
            isSelectedTimeslotAvailable ? state.selectedTimeSlot : null;

        emit(
          state.copyWith(
            timeSlots: timeSlots,
            freeTimeStatus: AppointmentFreeTimeStatus.done,
            errorMessage: '',
            selectedTimeSlot: timeslot,
            forceNullTimeslot: timeslot == null,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            freeTimeStatus: AppointmentFreeTimeStatus.error,
            errorMessage: e is NetException ? e.message : e.toString(),
          ),
        );

        rethrow;
      }
    } else {
      emit(
        state.copyWith(
          timeSlots: [],
          freeTimeStatus: AppointmentFreeTimeStatus.done,
          errorMessage: '',
        ),
      );
    }
  }

  List<BranchTimeSlot> _buildFreeTime(
    BranchFreeTime branchFreeTime,
  ) {
    int count;
    switch (branchFreeTime.dayStatus) {
      case BranchDayStatus.mixed:
        count = branchFreeTime.value.length;
        break;
      case BranchDayStatus.free:
      case BranchDayStatus.busy:
        count = branchFreeTime.stopTime!
                .difference(branchFreeTime.startTime!)
                .inMinutes ~/
            branchFreeTime.slotTime!;
        break;
      default:
        count = 0;
    }

    if (count <= 0) return [];

    final productsRequiredSlots = state.products.fold<int>(
      0,
      (previousValue, product) {
        return previousValue + (product.appointmentSlots ?? 0);
      },
    );

    return List<BranchTimeSlot>.generate(
      count,
      (index) => BranchTimeSlot(
        slotTime: branchFreeTime.startTime!.add(
          Duration(minutes: branchFreeTime.slotTime! * index),
        ),
        isAvailable: branchFreeTime.dayStatus == BranchDayStatus.free
            ? true
            : branchFreeTime.dayStatus == BranchDayStatus.busy
                ? false
                : _hasAvailableSlots(
                    productsRequiredSlots: productsRequiredSlots,
                    branchTimeSlots: branchFreeTime.value,
                    slotPosition: index,
                    totalSlots: count,
                  ),
      ),
    );
  }

  /// Check if the slots are available
  bool _hasAvailableSlots({
    required int productsRequiredSlots,
    required List<bool> branchTimeSlots,
    required int slotPosition,
    required int totalSlots,
  }) {
    /// If only one slot is needed, it returns if the slot is available or not
    if (productsRequiredSlots == 1) {
      return branchTimeSlots[slotPosition];
    }

    /// If more slots are required than the slots available after a certain time
    /// it returns false
    if (slotPosition > (totalSlots - productsRequiredSlots)) {
      return false;
    }

    /// Creates a sublist for the next N slots required from all products
    final slots = branchTimeSlots.sublist(
      slotPosition,
      slotPosition + productsRequiredSlots,
    );

    /// Check if all next N slots are available
    return slots.every((s) => s);
  }

  int get _totalDuration {
    var total = 0;
    for (var p in state.products) {
      total += p.appointmentSlots!;
    }
    return total * _slotTime!;
  }

  Appointment _prepareAppointment() {
    if (!state.canSubmit) {
      throw Exception('Invalid state data');
    }

    final endTime = state.selectedTimeSlot?.slotTime?.add(
      Duration(minutes: _totalDuration),
    );

    final subject = state.products.map((f) => f.id).join(',');

    return Appointment(
      appointmentId: state.appointmentId,
      branch: state.branch!.id,
      customerId: '',
      startDatetime: state.selectedTimeSlot!.slotTime!,
      endDatetime: endTime!,
      subject: subject,
      customerNotes: state.notes,
    );
  }

  /// Post an [Appointment]
  Future<void> postAppointment() async {
    emit(
      state.copyWith(
        busy: true,
        error: AppointmentBookingStateError.none,
      ),
    );

    try {
      final appointment = _prepareAppointment();
      await _repository.bookAppointment(appointment);

      emit(
        state.copyWith(
          error: AppointmentBookingStateError.none,
          errorMessage: '',
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: e is NetException ? e.message : e.toString(),
          error: e is NetException
              ? AppointmentBookingStateError.network
              : AppointmentBookingStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Updates an [Appointment]
  Future<void> updateAppointment() async {
    emit(
      state.copyWith(
        busy: true,
        error: AppointmentBookingStateError.none,
      ),
    );

    try {
      final appointment = _prepareAppointment();
      await _repository.updateAppointment(appointment);

      emit(
        state.copyWith(
          error: AppointmentBookingStateError.none,
          errorMessage: '',
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: e is NetException ? e.message : e.toString(),
          error: e is NetException
              ? AppointmentBookingStateError.network
              : AppointmentBookingStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Deletes an [Appointment]
  Future<void> deleteAppointment(Appointment appointment) async {
    emit(
      state.copyWith(
        busy: true,
        error: AppointmentBookingStateError.none,
      ),
    );

    try {
      await _repository.deleteAppointment(appointment);

      emit(
        state.copyWith(
          error: AppointmentBookingStateError.none,
          errorMessage: '',
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: e is NetException ? e.message : e.toString(),
          error: e is NetException
              ? AppointmentBookingStateError.network
              : AppointmentBookingStateError.generic,
        ),
      );

      rethrow;
    }
  }
}

bool _isSelectedTimeAvailable(
  BranchTimeSlot? selectedTimeSlot,
  List<BranchTimeSlot> timeSlots,
) {
  if (selectedTimeSlot == null) return true;

  final fmt = DateFormat.Hms();
  final selTime = fmt.format(selectedTimeSlot.slotTime!);
  final foundTime = timeSlots.firstWhereOrNull((e) {
    if (e.slotTime != null) {
      return fmt.format(e.slotTime!) == selTime;
    }

    return false;
  });

  return foundTime?.isAvailable ?? true;
}
