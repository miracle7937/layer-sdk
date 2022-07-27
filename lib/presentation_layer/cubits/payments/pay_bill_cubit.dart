import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/mappings/payment/biller_dto_mapping.dart';
import '../../../data_layer/network/net_exceptions.dart';
import '../../../domain_layer/use_cases/payments/load_billers_use_case.dart';
import '../../../domain_layer/use_cases/payments/load_services_use_case.dart';
import 'pay_bill_state.dart';

/// A cubit for paying customer bills.
class PayBillCubit extends Cubit<PayBillState> {
  final LoadBillersUseCase _loadBillersUseCase;
  final LoadServicesUseCase _loadServicesUseCase;

  /// Creates a new cubit
  PayBillCubit({
    required LoadBillersUseCase loadBillersUseCase,
    required LoadServicesUseCase loadServicesUseCase,
  })  : _loadBillersUseCase = loadBillersUseCase,
        _loadServicesUseCase = loadServicesUseCase,
        super(PayBillState());

  /// Loads all the required data, must be called at lease once before anything
  /// other method in this cubit.
  void load() async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );
    try {
      final billers = await _loadBillersUseCase();

      emit(
        state.copyWith(
          busy: false,
          billers: billers,
          billerCategories: billers.toBillerCategories(),
          errorStatus: PayBillErrorStatus.none,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? PayBillErrorStatus.network
              : PayBillErrorStatus.generic,
        ),
      );
    }
  }

  /// Set's the selected category to the one matching the provided category
  /// code.
  void setCatogery(String categoryCode) {
    final category = state.billerCategories
        .firstWhereOrNull((e) => e.categoryCode == categoryCode);
    emit(
      state.copyWith(
        selectedCategory: category,
      ),
    );
  }

  /// Set's the selected biller to the one matching the provided biller id.
  ///
  /// This will trigger a request to fetch the services for the selected biller.
  void setBiller(String billerId) async {
    final biller =
        state.billers.firstWhereOrNull((element) => element.id == billerId);
    if (biller == null) return;
    emit(
      state.copyWith(
        selectedBiller: biller,
        busy: true,
        busyAction: PayBillBusyAction.loadingServices,
      ),
    );

    try {
      final services = await _loadServicesUseCase(
        billerId: billerId,
        sortByName: true,
      );
      emit(
        state.copyWith(
          services: services,
          selectedService: services.firstOrNull,
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? PayBillErrorStatus.network
              : PayBillErrorStatus.generic,
        ),
      );
    }
  }
}
