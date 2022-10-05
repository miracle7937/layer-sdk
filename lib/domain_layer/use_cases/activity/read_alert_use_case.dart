import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to read the alert
class ReadAlertUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [ReadAlertUseCase] instance
  ReadAlertUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to read the alert by the current [Activity].
  ///
  /// This method could have two different ways to handle with app [Alerts].
  ///
  /// [Request]'s meant to be processes like [DPA] flows/activities
  /// and they need to be handled separately.
  ///
  /// [Alert]'s are regular push notifications and local alerts from the app.
  ///
  /// One way to differentiate [Request] to [Alert] is checking if the
  /// [Activity] id is not empty and that way the respecitve endpoint will be
  /// called.
  ///
  /// For the [Request] flow the `activity.id` which has the [String] type
  /// will be passed as parameter through the repository.
  ///
  /// In the other side for [Alert] flow `activity.alertID` which has the
  /// [int] type will be passed as parameter through the repository.
  Future<void> call(Activity activity) {
    if (activity.id.isNotEmpty) {
      return _repository.readRequest(activity.id);
    }

    return _repository.readAlert(activity.alertID);
  }
}
