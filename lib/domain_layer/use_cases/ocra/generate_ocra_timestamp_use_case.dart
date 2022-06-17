import '../../extensions/ocra_suite_utils.dart';

/// The use case responsible for generating an OCRA timestamp.
///
/// Returns the amount of time steps that passed since January 1st 1970 00:00
/// or null if the OCRA suite doesn't specify the timestamp configuration.
///
/// The time steps are defined in the [ocraSuite] as [1-59] seconds / minutes,
/// [1-48] hours or a number of days.
///
/// More information regarding the [ocraSuite] can be found here:
/// https://datatracker.ietf.org/doc/html/rfc6287#section-6.3
class GenerateOcraTimestampUseCase {
  /// The configuration string for the OCRA algorithm.
  final String _ocraSuite;

  /// The utility wrapper to be used instead of `DateTime.now()` in order to
  /// mock the returned date in unit tests.
  ///
  /// DO NOT PASS THIS IN PRODUCTION CODE.
  final DateTimeNowWrapper _nowWrapper;

  /// Creates new [GenerateOcraTimestampUseCase].
  GenerateOcraTimestampUseCase({
    required String ocraSuite,
    // Should not be passed outside unit tests
    DateTimeNowWrapper nowWrapper = const DateTimeNowWrapper(),
  })  : _ocraSuite = ocraSuite,
        _nowWrapper = nowWrapper;

  /// Returns the amount of time steps according to the OCRA suite.
  int? call() {
    final type = _ocraSuite.timestampType;
    final timeStep = _ocraSuite.timeStep;
    if (type == null || timeStep == null) {
      return null;
    }
    var divider = 1000 * timeStep;
    switch (type) {
      case 'S':
        break;
      case 'M':
        divider *= 60;
        break;
      case 'H':
        divider *= 3600;
        break;
      case 'D':
        divider *= 86400;
        break;
      default:
        throw UnsupportedError(
          'Timestamp described by "$type" is not supported',
        );
    }

    return _nowWrapper.now().toUtc().millisecondsSinceEpoch ~/ divider;
  }
}

/// A wrapper class for the `DateTime.now()` function. It allows to easily mock
/// the date in the use case unit tests.
class DateTimeNowWrapper {
  /// Creates a new [DateTimeNowWrapper].
  const DateTimeNowWrapper();

  /// Returns the current date.
  DateTime now() => DateTime.now();
}
