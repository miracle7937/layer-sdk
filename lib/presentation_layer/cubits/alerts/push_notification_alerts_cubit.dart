import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/use_cases.dart';
import 'push_notification_alerts_state.dart';

///A cubit that holds the result alert from push notification
class PushNotificationAlertsCubit extends Cubit<PushNotificationAlertsState> {
  final GetAlertByActivityQueryUseCase _getAlertByActivityQueryUseCase;

  /// Creates a new [PushNotificationAlertsCubit]
  PushNotificationAlertsCubit({
    required GetAlertByActivityQueryUseCase getAlertByActivityQueryUseCase,
  })  : _getAlertByActivityQueryUseCase = getAlertByActivityQueryUseCase,
        super(PushNotificationAlertsState());

  /// Loads the aler details from firebase push notification response by `query`
  Future<void> load(
    String query, {
    bool includeDetails = true,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PushNotificationAlertsActions.loadingAlert,
        ),
        errors: state.removeErrorForAction(
          PushNotificationAlertsActions.loadingAlert,
        ),
      ),
    );

    try {
      final result = await _getAlertByActivityQueryUseCase(
        query,
        includeDetails: includeDetails,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PushNotificationAlertsActions.loadingAlert,
          ),
          alert: result,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(PushNotificationAlertsActions.loadingAlert),
        errors: state.addErrorFromException(
          action: PushNotificationAlertsActions.loadingAlert,
          exception: e,
        ),
      ));

      rethrow;
    }
  }
}
