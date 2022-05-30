import 'package:dio/dio.dart';

/// Facilitates the cancellation of requests.
///
/// This is normally passed through the repositories and providers to the
/// [NetClient], that will use it to cancel one or more requests associated
/// with the current internal token.
///
/// It shouldn't be created inside providers or repositories, as distinct
/// classes on the business layer may call it, which would lead to one object
/// having its requests being cancelled by calls from another object.
///
/// Create it as a final object in the class that will call the repository
/// method you wish to cancel a request, and pass it to the repository, that
/// should pass it to its provider, that will then pass it to the NetClient.
///
///
/// {@tool snippet}
/// Then, before calling the repository method you wish to cancel, reset the
/// canceller object.
///
/// ```dart
/// await _listCanceller.reset();
/// ```
/// {@end-tool}
///
/// This ensures that all previous requests are cancelled, and prepares the
/// object for following requests, and that's it.
///
/// Remember that you can use the same object for different requests, so
/// if your repository calls multiple providers, you can pass the same object.
///
/// Also remember to dispose() the object when not needed anymore.
class NetRequestCanceller {
  CancelToken? _token = CancelToken();

  /// Returns the internal cancellation token.
  ///
  /// Only the [NetClient] needs to worry about this.
  CancelToken? get token => _token;

  /// Returns `true` if this object was disposed and can't be used anymore.
  bool get isDisposed => _token == null;

  /// Disposes of this object. After disposed, it can't be used again.
  Future<void> dispose() async {
    await _cancel();

    _token = null;
  }

  /// Cancels all requests currently running, and prepare it for new ones.
  Future<void> reset() async {
    await _cancel();

    _token = CancelToken();
  }

  /// When cancelled, this future will be resolved.
  Future<void> get whenCancel {
    _checkDisposed();

    return _token!.whenCancel;
  }

  Future<void> _cancel() {
    _checkDisposed();

    _token!.cancel();

    return whenCancel;
  }

  void _checkDisposed() {
    if (_token != null) return;
    throw Exception('NetRequestCanceller already disposed.');
  }
}
