import 'package:collection/collection.dart';

/// An extension that provides the functionality to extract specific
/// configuration values from the OCRA suite string.
extension OcraSuiteUtils on String {
  /// Returns the challenge question type:
  /// - `A` - alphanumeric,
  /// - `N` - numeric.
  ///
  /// Returns `null` when the question type is not defined on the OCRA suite.
  String? get questionType {
    final dataInputParam = split(':').last;
    final questionParam = dataInputParam.split('-').firstWhereOrNull(
          (param) => param.startsWith('Q'),
        );
    return questionParam != null ? questionParam[1] : null;
  }

  /// Returns the length of the challenge question.
  ///
  /// Returns `null` when the question length is not defined on the OCRA suite.
  int? get questionLength {
    final dataInputParam = split(':').last;
    final questionParam = dataInputParam.split('-').firstWhereOrNull(
          (param) => param.startsWith('Q'),
        );
    return int.tryParse(questionParam?.substring(2) ?? '');
  }

  /// Returns the timestamp type:
  /// - `S` - seconds,
  /// - `M` - minutes,
  /// - `H`- hours,
  /// - `D` - days.
  ///
  /// Returns `null` when the timestamp type is not defined on the OCRA suite.
  String? get timestampType {
    final dataInputParam = split(':').last;
    final timestampParam = dataInputParam.split('-').firstWhereOrNull(
          (param) => param.startsWith('T'),
        );
    return timestampParam?.split('').last;
  }

  /// Returns the size of the time step.
  int? get timeStep {
    final dataInputParam = split(':').last;
    final timestampParam = dataInputParam.split('-').firstWhereOrNull(
          (param) => param.startsWith('T'),
        );
    return int.tryParse(
      timestampParam?.replaceAll(RegExp(r'[^0-9]'), '') ?? '',
    );
  }
}
