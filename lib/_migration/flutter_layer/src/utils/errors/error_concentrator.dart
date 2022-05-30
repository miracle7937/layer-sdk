import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

/// Receives errors from different parts of the app (cubit, flutter, etc),
/// and funnels them into a single stream that can be handled by the UI.
///
/// To help dealing with the errors on the UI, see [ConcentratedErrorHandler].
///
/// ## Adding hooks to the concentrator
///
/// ### Flutter errors
///
/// Reroute the Flutter errors to the concentrator by adding something like
/// this to the main file:
///
/// ```dart
///   FlutterError.onError = (details) {
///     errorConcentrator.onError(
///       details.exception,
///       source: ErrorSource.flutter,
///       stackTrace: details.stack,
///     );
///   };
/// ```
///
/// ### Blocs/Cubits
///
/// To handle exceptions raised through `addError` on a Cubit, or through
/// `addError` or exception thrown on `MapEventToState` on a Bloc, create a
/// BlocObserver to add these errors to the concentrator (check out
/// [CubitConcentratedErrorObserver]), then, point the bloc errors to that,
/// preferably on the main file:
///
/// ```dart
///   Bloc.observer = CubitConcentratedErrorObserver(
///     errorConcentrator: errorConcentrator,
///   );
/// })
/// ```
///
/// Remember that the bloc/cubit has to throw the errors, or else they'll
/// fail silently.
///
/// ### All other errors
///
/// To concentrate errors that do not fall in the above types, you should
/// run you app in a zone, for instance:
///
/// ```dart
/// void main() async {
///   final _errorConcentrator = ErrorConcentrator();
///
///   runZonedGuarded(() async {
///     runApp(
///       BankApp(
///         errorConcentrator: _errorConcentrator,
///       ),
///     );
///   }, (error, stack) {
///     // Funnels all errors that are not caught elsewhere.
///     _errorConcentrator.onError(
///       error,
///       source: ErrorSource.general,
///       stackTrace: stack,
///     );
///   });
/// }
/// ```
class ErrorConcentrator {
  static final _log = Logger('ErrorConcentrator');

  final _errorSubject = PublishSubject<ErrorData>();

  /// Returns the stream to the funneled errors.
  Stream<ErrorData> get stream => _errorSubject.stream;

  /// Call to add errors to the funnel.
  void onError(
    Object error, {
    required ErrorSource source,
    StackTrace? stackTrace,
  }) {
    _log.severe(
      'Error caught from source "${source.sourceName()}": $error'
      '${stackTrace != null ? '\n$stackTrace' : ''}',
    );

    _errorSubject.add(
      ErrorData(
        error,
        source: source,
        stackTrace: stackTrace,
      ),
    );
  }
}

/// Holds the information for the error that the [ErrorConcentrator] received.
class ErrorData extends Equatable {
  /// The error object.
  final Object error;

  /// The source of the error.
  final ErrorSource source;

  /// The optional stack trace.
  final StackTrace? stackTrace;

  /// Creates a new [ErrorData].
  ErrorData(
    this.error, {
    required this.source,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [
        error,
        source,
        stackTrace,
      ];
}

/// From where the error was received
enum ErrorSource {
  /// Error that was not caught by anyone else but the zone guard.
  general,

  /// Error caught by Flutter.
  flutter,

  /// Error caught by the cubit observer.
  cubit,
}

/// Extension methods for [ErrorSource]
extension ErrorSourceExtension on ErrorSource {
  /// Returns the name of the error source.
  ///
  /// NOTE: THIS IS NOT LOCALIZED, AS IT SHOULD NEVER APPEAR TO THE USER.
  /// ONLY TO BE USED ON LOGS.
  String sourceName() {
    switch (this) {
      case ErrorSource.general:
        return 'General';

      case ErrorSource.cubit:
        return 'Cubit';

      case ErrorSource.flutter:
        return 'Flutter';

      default:
        return 'Unknown';
    }
  }
}
