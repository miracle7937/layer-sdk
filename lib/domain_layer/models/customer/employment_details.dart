import 'package:equatable/equatable.dart';

/// The employment situation.
enum EmploymentType {
  /// Is self employed.
  selfEmployed,

  /// Is employed in a company.
  employed,

  /// Is retired.
  retired,

  /// Is unemployed.
  unemployed,

  /// Is a housewife or househusband.
  homemaker,

  /// Is a student.
  student,

  /// Other employment situations.
  other,

  /// Unknown.
  unknown,
}

/// Holds employment details data.
class EmploymentDetails extends Equatable {
  /// The type of employment.
  ///
  /// Defaults to [EmploymentType.other].
  final EmploymentType type;

  /// The occupation.
  final String occupation;

  /// The name of the employer.
  final String employerName;

  /// The address of the employer.
  final String employerAddress;

  /// The monthly income range.
  final String incomeRange;

  /// The source of income.
  final String incomeSource;

  /// The source of funds.
  final String fundsSource;

  /// Nature and volume of business dealings.
  final String businessDealings;

  /// Creates a new [EmploymentDetails].
  const EmploymentDetails({
    this.type = EmploymentType.unknown,
    this.occupation = '',
    this.employerName = '',
    this.employerAddress = '',
    this.incomeRange = '',
    this.incomeSource = '',
    this.fundsSource = '',
    this.businessDealings = '',
  });

  @override
  List<Object?> get props => [
        type,
        occupation,
        employerName,
        employerAddress,
        incomeRange,
        incomeSource,
        fundsSource,
        businessDealings,
      ];

  /// Returns a copy of the employment details with select different values.
  EmploymentDetails copyWith({
    EmploymentType? type,
    String? occupation,
    String? employerName,
    String? employerAddress,
    String? incomeRange,
    String? incomeSource,
    String? fundsSource,
    String? businessDealings,
  }) =>
      EmploymentDetails(
        type: type ?? this.type,
        occupation: occupation ?? this.occupation,
        employerName: employerName ?? this.employerName,
        employerAddress: employerAddress ?? this.employerAddress,
        incomeRange: incomeRange ?? this.incomeRange,
        incomeSource: incomeSource ?? this.incomeSource,
        fundsSource: fundsSource ?? this.fundsSource,
        businessDealings: businessDealings ?? this.businessDealings,
      );
}
