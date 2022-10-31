/// Use case to handle the string query received from firebase push notification
class HandleAlertQueryUseCase {
  /// Callable method to spit the query into a [Map]
  Map<String, dynamic> call({required String query}) {
    final queryList = query.split('=');

    return {
      queryList.first: queryList.last,
    };
  }
}
