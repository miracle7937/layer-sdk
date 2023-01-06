import 'package:equatable/equatable.dart';

/// Class that holds data of banking products
class Product extends Equatable {
  /// Product Id
  final String id;

  /// Creation date
  final int? tsCreated;

  /// Last update time
  final int? tsUpdated;

  /// Product type
  final ProductType productType;

  /// Amount disbursed
  final String? amountDisbursed;

  /// Product Name
  final String name;

  /// Product title
  final String? title;

  /// Product Description
  final String? description;

  /// Product features
  final String? features;

  /// Product benefits
  final String? benefits;

  /// Product eligibility
  final String? eligibility;

  /// Product fees
  final String? fees;

  /// Product image url
  final String? imageUrl;

  /// Interest rate
  final double? interestRate;

  /// Insurance rate
  final double? insuranceRate;

  /// Product fees
  final double? insuranceFees;

  /// Processing  fees
  final double? processingFees;

  /// Minimum amount
  final double? minAmount;

  /// Maximum amount
  final double? maxAmount;

  /// Minimum salary
  final double? minSalary;

  /// Maximum Salary
  final double? maxSalary;

  /// Minimum Tenor
  final int? minTenor;

  /// Maximum Tenor
  final int? maxTenor;

  /// Minimum Dbr
  final double? maxDbr;

  /// Appointment Slots
  final int? appointmentSlots;

  /// Creates a new instance of [Product]
  Product({
    required this.id,
    this.productType = ProductType.current,
    required this.name,
    this.tsCreated,
    this.tsUpdated,
    this.amountDisbursed,
    this.title,
    this.description,
    this.features,
    this.benefits,
    this.eligibility,
    this.fees,
    this.imageUrl,
    this.interestRate,
    this.insuranceRate,
    this.insuranceFees,
    this.processingFees,
    this.minAmount,
    this.maxAmount,
    this.minSalary,
    this.maxSalary,
    this.minTenor,
    this.maxTenor,
    this.maxDbr,
    this.appointmentSlots,
  });

  @override
  List<Object?> get props {
    return [
      id,
      tsCreated,
      tsUpdated,
      productType,
      amountDisbursed,
      name,
      title,
      description,
      features,
      benefits,
      eligibility,
      fees,
      imageUrl,
      interestRate,
      insuranceRate,
      insuranceFees,
      processingFees,
      minAmount,
      maxAmount,
      minSalary,
      maxSalary,
      minTenor,
      maxTenor,
      maxDbr,
      appointmentSlots,
    ];
  }

  /// Creates a new [Product] instance from previous object
  Product copyWith({
    String? id,
    int? tsCreated,
    int? tsUpdated,
    ProductType? productType,
    String? amountDisbursed,
    String? name,
    String? title,
    String? description,
    String? features,
    String? benefits,
    String? eligibility,
    String? fees,
    String? imageUrl,
    double? interestRate,
    double? insuranceRate,
    double? insuranceFees,
    double? processingFees,
    double? minAmount,
    double? maxAmount,
    double? minSalary,
    double? maxSalary,
    int? minTenor,
    int? maxTenor,
    double? maxDbr,
    int? appointmentSlots,
  }) {
    return Product(
      id: id ?? this.id,
      tsCreated: tsCreated ?? this.tsCreated,
      tsUpdated: tsUpdated ?? this.tsUpdated,
      productType: productType ?? this.productType,
      amountDisbursed: amountDisbursed ?? this.amountDisbursed,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      features: features ?? this.features,
      benefits: benefits ?? this.benefits,
      eligibility: eligibility ?? this.eligibility,
      fees: fees ?? this.fees,
      imageUrl: imageUrl ?? this.imageUrl,
      interestRate: interestRate ?? this.interestRate,
      insuranceRate: insuranceRate ?? this.insuranceRate,
      insuranceFees: insuranceFees ?? this.insuranceFees,
      processingFees: processingFees ?? this.processingFees,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      minTenor: minTenor ?? this.minTenor,
      maxTenor: maxTenor ?? this.maxTenor,
      maxDbr: maxDbr ?? this.maxDbr,
      appointmentSlots: appointmentSlots ?? this.appointmentSlots,
    );
  }
}

/// Enum that indicates the type of a [Product]
enum ProductType {
  /// Currenct account
  current,

  /// Savings account
  savings,

  /// Term deposit
  termDeposit,

  /// Loan
  loan,

  /// Debit card
  debitCard,

  /// Credit card
  creditCard,
}
