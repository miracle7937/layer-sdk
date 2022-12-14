import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path_utils;

import '../environment.dart';
import '../network.dart';

/// Callback to listen the progress for sending/receiving data.
///
/// [count] is the length of the bytes have been sent/received.
///
/// [total] is the content length of the response/request body.
/// 1.When receiving data:
///   [total] is the request body length.
/// 2.When receiving data:
///   [total] will be -1 if the size of the response body is not known in
///   advance, for example: response data is compressed with gzip or has no
///   content-length header.
typedef NetProgressCallback = void Function(int count, int total);

/// How the logging should be done.
enum NetLogType {
  /// Should not log.
  none,

  /// Will break the long logs into separate lines.
  full,

  /// Will truncate long logs.
  truncated,
}

/// Handles all communication with the backend
class NetClient {
  final _log = Logger('NetClient');

  /// The HTTP client.
  ///
  /// This is a protected field that can be used when extending the class to
  /// add, for instance, interceptors.
  @protected
  final Dio client;

  /// If each request should use be prefixed with the current environment URL.
  ///
  /// On normal apps, there's no need to set this to `true`, as the environment
  /// will not change, but on apps like the DBO (Console), where the user
  /// can select a different environment, it needs to be set to `true` to
  /// use the current selected environment.
  ///
  /// Defaults to `false`.
  final bool useUpdatedEnvironment;

  /// How the logging should be done.
  ///
  /// Defaults to not logging ([NetLogType.none]).
  final NetLogType logType;

  /// The default [NetJson] the providers can call to deal with
  /// quick transformations.
  ///
  /// Defaults to a [NetJson]
  final NetJson jsonHandler;

  /// The default [NetJson] the providers can call when dealing
  /// with more slow transformations.
  ///
  /// This is used in an Flutter app, for instance, to encode/decode JSONs
  /// outside the UI thread.
  ///
  /// Defaults to a [NetJson]
  final NetJson backgroundJsonHandler;

  /// Endpoint paths to be used by this [NetClient].
  final NetEndpoints netEndpoints;

  String? _currentToken;

  final path_utils.Context? _pathContext;

  /// Set the token to use for request authentication.
  // ignore: avoid_setters_without_getters
  set token(String? token) => _currentToken = token;

  /// Clears the token. All requests will then use the `defaultToken` of the
  /// current [EnvironmentConfiguration].
  void clearToken() => _currentToken = null;

  /// Returns the current or default token.
  String? currentToken({
    bool useDefaultToken = false,
  }) =>
      (useDefaultToken || _currentToken == null)
          ? EnvironmentConfiguration.current.defaultToken
          : _currentToken;

  /// The default language to ask the backend.
  String defaultLanguage;

  /// Creates a new [NetClient].
  ///
  /// The [defaultHeaders] can be provided to be included in every request.
  ///
  /// The [onHttpClientCreate] callback can be used to configure the http client
  /// for ssl pinning.
  NetClient({
    this.useUpdatedEnvironment = false,
    this.logType = NetLogType.none,
    this.jsonHandler = const NetJson(),
    this.backgroundJsonHandler = const NetJson(),
    Map<String, dynamic>? defaultHeaders,
    this.netEndpoints = const NetEndpoints(),
    this.defaultLanguage = 'en',
    HttpClient? Function(HttpClient)? onHttpClientCreate,
  })  : client = Dio(
          BaseOptions(
            baseUrl: EnvironmentConfiguration.current.fullUrl,
            headers: defaultHeaders,
          ),
        ),
        _pathContext = useUpdatedEnvironment
            ? path_utils.Context(style: path_utils.Style.url)
            : null {
    if (logType != NetLogType.none) _addLogger(logType);
    if (onHttpClientCreate != null &&
        client.httpClientAdapter is DefaultHttpClientAdapter) {
      (client.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = onHttpClientCreate;
    }
  }

  /// Adds a new interceptor to this client.
  void addInterceptor(Interceptor i) => client.interceptors.add(i);

  /// Removes an interceptor from this client.
  bool removeInterceptor(Interceptor i) => client.interceptors.remove(i);

  /// Clears all cached data.
  ///
  /// Must be overridden by child classes, as this class does not implement
  /// caching.
  Future<bool> clearCache() => Future.value(true);

  /// Builds the options for each request. Extend this on child classes when
  /// in need of adding new options.
  ///
  /// The [forceRefresh], [cacheDuration], [cachePrimaryKey] and [cacheSubKey]
  /// are only passed so that child classes can implement caching.
  ///
  /// If [contentType] is null, content type defaults to [ContentType.json].
  @protected
  Options buildOptions({
    String? token,
    String? authorizationHeader,
    NetRequestMethods? method,
    bool? forceRefresh,
    Duration? cacheDuration,
    String? cachePrimaryKey,
    String? cacheSubKey,
    ContentType? contentType,
    ResponseType responseType = ResponseType.json,
  }) =>
      Options(
        headers: {
          if (authorizationHeader != null)
            "Authorization": "$authorizationHeader",
          if (authorizationHeader == null && token != null)
            "Authorization": "Bearer $token",
          "x-correlation-id": _generateRequestUUID(10),
        },
        method: method?.name,
        contentType: (contentType ?? ContentType.json).mimeType,
        responseType: responseType,
      );

  /// The most basic request to [path].
  /// The [method] defaults to [NetRequestMethods.get]
  ///
  /// If [decodeResponse] is `true` (the default), the client will try to
  /// decode the response json. If `false`, the raw response data will
  /// be returned -- useful when downloading files like SVGs.
  ///
  /// [useDefaultToken] forces the use of the default token instead of the
  /// current token.
  ///
  /// [authorizationHeader] can be provided to use a custom authorization
  /// header. If provided it takes precedence over the current and default
  /// tokens.
  ///
  /// [useBackgroundJsonHandler] forces the encoding and decoding of the json
  /// to occur using the background json handler.
  ///
  /// [addLanguage] will add the language to the request. Default is `true`.
  ///
  /// [language] is the language code to use on the request. If null, will
  /// use [defaultLanguage].
  ///
  /// If [throwAllErrors] is `false`, it will suppress the exceptions and
  /// return a [NetResponse] with the available data. Use this when you have
  /// a different flow and don't need to deal with exceptions. For instance,
  /// when just checking if the response.success is enough. Defaults to `true`.
  ///
  /// [forceRefresh], [cacheDuration], [cachePrimaryKey] and [cacheSubKey] deal
  /// with the cache, which is not implemented on this class, but only in
  /// subclasses depending on the platform.
  /// - if [forceRefresh] is true, it will skip the cache and force a
  /// network call
  /// - you can set a custom [cacheDuration] for this request, or leave it null
  /// to use the default cache duration.
  /// - [cachePrimaryKey] and [cacheSubKey] are useful when dealing with
  /// pagination or anything else that would need a different cache key for
  /// this request.
  ///
  /// This method tries to returns a [NetResponse], but will raise
  /// a [NetException] in case no response is returned from the server.
  ///
  /// Use the optional [onSendProgress] and [onReceiveProgress] to get the
  /// progress when uploading/downloading files, respectively.
  Future<NetResponse> request(
    String path, {
    NetRequestMethods method = NetRequestMethods.get,
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool decodeResponse = true,
    bool useDefaultToken = false,
    bool useBackgroundJsonHandler = true,
    bool addLanguage = true,
    String? language,
    bool? forceRefresh,
    Duration? cacheDuration,
    String? cachePrimaryKey,
    String? cacheSubKey,
    String? authorizationHeader,
    bool throwAllErrors = true,
    ResponseType responseType = ResponseType.plain,
    NetRequestCanceller? requestCanceller,
    NetProgressCallback? onSendProgress,
    NetProgressCallback? onReceiveProgress,
  }) async {
    final effectivePath = useUpdatedEnvironment
        ? _pathContext!.join(EnvironmentConfiguration.current.baseUrl, path)
        : path;

    final encodedData = useBackgroundJsonHandler
        ? await backgroundJsonHandler.encode(data)
        : await jsonHandler.encode(data);

    final effectiveLanguage =
        addLanguage ? (language ?? defaultLanguage) : null;

    try {
      final response = await client.request(
        effectivePath,
        data: encodedData,
        queryParameters: {
          if (queryParameters != null) ...queryParameters,
          if (effectiveLanguage != null) 'language': effectiveLanguage,
        },
        cancelToken: requestCanceller?.token,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: buildOptions(
          token: currentToken(useDefaultToken: useDefaultToken),
          authorizationHeader: authorizationHeader,
          method: method,
          forceRefresh: forceRefresh,
          cacheDuration: cacheDuration,
          cachePrimaryKey: cachePrimaryKey,
          cacheSubKey: cacheSubKey,
          responseType: responseType,
        ),
      );

      return await _buildResponse(
        response: response,
        decodeResponse: decodeResponse,
        useBackgroundJsonHandler: useBackgroundJsonHandler,
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        return NetResponse(
          statusCode: 204, // No content as it was cancelled
          statusMessage: 'Request Cancelled',
        );
      }

      if (!throwAllErrors && e.response != null) {
        _log.warning('${method.name} ${e.requestOptions.uri}: $e');

        return await _buildResponse(
          response: e.response!,
          decodeResponse: decodeResponse,
          useBackgroundJsonHandler: useBackgroundJsonHandler,
        );
      }

      _log.severe('${method.name}: $e');

      NetException? exception;

      if (e.response?.data != null) {
        try {
          final dynamic json = await jsonHandler.decode(e.response?.data);
          exception = NetException.fromJson(
            json,
            statusCode: e.response?.statusCode,
          );
        } on FormatException {
          _log.severe(
            "Ops! Response is not a valid json encoding: ${e.response!.data}",
          );
        }
      }

      final isConnectivityError = {
            DioErrorType.connectTimeout,
            DioErrorType.sendTimeout,
            DioErrorType.receiveTimeout,
          }.contains(e.type) ||
          (e.type == DioErrorType.other && e.error is SocketException);

      exception ??= isConnectivityError
          ? ConnectivityException()
          : NetException(
              details: e.message,
              statusCode: e.response?.statusCode,
            );

      throw exception;
    }
  }

  /// Generates a random string of [length] with alpha-numeric characters.
  String _generateRequestUUID(int length) {
    final allowedCharacters =
        "01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnoprstuvwxyz";
    var uuid = '';
    for (var i = 0; i < length; i++) {
      final index = Random().nextInt(allowedCharacters.length - 1);
      uuid += allowedCharacters[index];
    }
    return uuid;
  }

  dynamic _getDecodedJson({
    String? str,
    required bool useBackgroundJsonHandler,
  }) async {
    if (str?.isEmpty ?? true) {
      return null;
    } else {
      return useBackgroundJsonHandler
          ? await backgroundJsonHandler.decode(str!)
          : await jsonHandler.decode(str!);
    }
  }

  /// Builds a [NetResponse] based on the response from the request.
  Future<NetResponse> _buildResponse({
    required Response response,
    required bool decodeResponse,
    required bool useBackgroundJsonHandler,
  }) async {
    dynamic decodedData = response.data;
    final statusCode = response.statusCode ?? '';
    final shouldDecodeResponse =
        decodeResponse || statusCode != 200 || statusCode != 201;

    if (shouldDecodeResponse) {
      if (response.data is String) {
        decodedData = await _getDecodedJson(
          str: response.data,
          useBackgroundJsonHandler: useBackgroundJsonHandler,
        );
      } else if (response.data is Uint8List) {
        var str = String.fromCharCodes(response.data);
        decodedData = await _getDecodedJson(
          str: str,
          useBackgroundJsonHandler: useBackgroundJsonHandler,
        );
      } else {
        decodedData = useBackgroundJsonHandler
            ? await backgroundJsonHandler.decode(response.data)
            : await jsonHandler.decode(response.data);
      }
    }

    return NetResponse(
      data: decodedData,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  /// Adds the LogInterceptor, using the Logger to display the messages
  void _addLogger(NetLogType logType) => client.interceptors.add(
        LogInterceptor(
          logPrint: logType == NetLogType.full ? _wrapLog : _log.finest,
          requestBody: true,
          responseBody: true,
        ),
      );

  /// Wraps long texts into different lines.
  void _wrapLog(Object text) {
    // Chunk size = 800
    RegExp('.{1,800}').allMatches(text.toString()).forEach(
          (e) => _log.finest(e.group(0)),
        );
  }

  /// Request that accepts a list of [MultipartFile] in its body
  Future<NetResponse> multipartRequest(
    String path, {
    required List<MultipartFile> files,
    Map<String, Object> fields = const {},
    NetRequestMethods method = NetRequestMethods.post,
    Map<String, dynamic>? queryParameters,
    bool decodeResponse = true,
    bool useDefaultToken = false,
    bool useBackgroundJsonHandler = true,
    bool addLanguage = true,
    String? language,
    bool? forceRefresh,
    Duration? cacheDuration,
    String? cachePrimaryKey,
    String? cacheSubKey,
    String? authorizationHeader,
    bool throwAllErrors = true,
    ResponseType responseType = ResponseType.plain,
    NetRequestCanceller? requestCanceller,
    NetProgressCallback? onSendProgress,
    NetProgressCallback? onReceiveProgress,
  }) async {
    final effectivePath = useUpdatedEnvironment
        ? _pathContext!.join(EnvironmentConfiguration.current.baseUrl, path)
        : path;

    final effectiveLanguage =
        addLanguage ? (language ?? defaultLanguage) : null;

    fields.forEach((key, value) => fields[key] = jsonEncode(value));

    final formData = FormData.fromMap(fields);

    for (var f in files) {
      formData.files.add(
        MapEntry<String, MultipartFile>(
          'message_attachment',
          f,
        ),
      );
    }

    try {
      final response = await client.request(
        effectivePath,
        data: formData,
        queryParameters: {
          if (queryParameters != null) ...queryParameters,
          if (effectiveLanguage != null) 'language': effectiveLanguage,
        },
        cancelToken: requestCanceller?.token,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: buildOptions(
          token: currentToken(useDefaultToken: useDefaultToken),
          authorizationHeader: authorizationHeader,
          method: method,
          forceRefresh: forceRefresh,
          cacheDuration: cacheDuration,
          cachePrimaryKey: cachePrimaryKey,
          cacheSubKey: cacheSubKey,
          responseType: responseType,
          contentType: ContentType.parse('multipart/form-data;'),
        ),
      );

      return await _buildResponse(
        response: response,
        decodeResponse: decodeResponse,
        useBackgroundJsonHandler: useBackgroundJsonHandler,
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        return NetResponse(
          statusCode: 204, // No content as it was cancelled
          statusMessage: 'Request Cancelled',
        );
      }

      if (!throwAllErrors && e.response != null) {
        _log.warning('${method.name} ${e.requestOptions.uri}: $e');

        return await _buildResponse(
          response: e.response!,
          decodeResponse: decodeResponse,
          useBackgroundJsonHandler: useBackgroundJsonHandler,
        );
      }

      _log.severe('${method.name}: $e');

      NetException? exception;

      if (e.response?.data != null) {
        final dynamic json = await jsonHandler.decode(e.response?.data);

        exception = NetException.fromJson(
          json,
          statusCode: e.response?.statusCode,
        );
      }

      exception ??= NetException(
        details: e.message,
        statusCode: e.response?.statusCode,
      );

      throw exception;
    }
  }
}
