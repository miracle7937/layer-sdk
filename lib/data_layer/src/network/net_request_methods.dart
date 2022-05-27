/// The HTTP request methods allowed on the [NetClient]
enum NetRequestMethods {
  /// Retrieves a resource
  get,

  /// Same as GET, but without the response body
  head,

  /// Submits new resource
  post,

  /// Replaces a resource
  put,

  /// Deletes a resource
  delete,

  /// Used to establish a tunnel
  connect,

  /// Communication options
  options,

  /// Message loop-back test
  trace,

  /// Used to apply partial modifications
  patch,
}

/// The default extension to [NetRequestMethods] to add essential methods
extension DefaultNetRequestMethodsExtension on NetRequestMethods {
  /// Returns the HTTP name of the [NetRequestMethods]
  String get name {
    switch (this) {
      case NetRequestMethods.get:
        return 'GET';
      case NetRequestMethods.head:
        return 'HEAD';
      case NetRequestMethods.post:
        return 'POST';
      case NetRequestMethods.put:
        return 'PUT';
      case NetRequestMethods.delete:
        return 'DELETE';
      case NetRequestMethods.connect:
        return 'CONNECT';
      case NetRequestMethods.options:
        return 'OPTIONS';
      case NetRequestMethods.trace:
        return 'TRACE';
      case NetRequestMethods.patch:
        return 'PATCH';
      default:
        throw UnsupportedError(
          'NetRequestMethods.name unsupported for type $this',
        );
    }
  }
}
