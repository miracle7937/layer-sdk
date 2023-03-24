import 'package:collection/collection.dart';

import '../../helpers.dart';

/// Class that holds data return from Product endpoint
class ProductDTO {
  /// Product Id
  final String? id;

  /// Creation date
  final int? tsCreated;

  /// Last update time
  final int? tsUpdated;

  /// Product type
  final ProductTypeDTO productType;

  /// Amount disbursed
  final String? amountDisbursed;

  /// Product Name
  final String? name;

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

  /// Creates a new instance of [ProductDTO]
  ProductDTO({
    this.id,
    this.tsCreated,
    this.tsUpdated,
    this.productType = ProductTypeDTO.current,
    this.amountDisbursed,
    this.name,
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

  /// Creates a new instance of [ProductDTO] from a json map
  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      id: json["product_id"],
      tsCreated: json["ts_created"],
      tsUpdated: json["ts_updated"],
      productType: ProductTypeDTO.fromRaw(json["product_type"]) ??
          ProductTypeDTO.current,
      amountDisbursed: json["amount_disbursed"],
      title: json["title"],
      name: json["name"],
      description: json["description"],
      features: json["features"],
      benefits: json["benefits"],
      eligibility: json["eligibility"],
      fees: json["fees"],
      imageUrl: json["image_url"],
      interestRate: JsonParser.parseDouble(json["interest_rate"]),
      insuranceRate: JsonParser.parseDouble(json["insurance_rate"]),
      insuranceFees: JsonParser.parseDouble(json["insurance_fees"]),
      processingFees: JsonParser.parseDouble(json["processing_fees"]),
      minAmount: JsonParser.parseDouble(json["min_amount"]),
      maxAmount: JsonParser.parseDouble(json["max_amount"]),
      minSalary: JsonParser.parseDouble(json["min_salary"]),
      maxSalary: JsonParser.parseDouble(json["max_salary"]),
      minTenor: JsonParser.parseInt(json["min_tenor"]),
      maxTenor: JsonParser.parseInt(json["max_tenor"]),
      maxDbr: JsonParser.parseDouble(json["max_dbr"]),
      appointmentSlots: JsonParser.parseInt(json['appointment_slots']),
    );
  }

  /// Returns a list of [ProductDTO] from a json list
  static List<ProductDTO> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map(ProductDTO.fromJson).toList();
  }
}

/// Maps Product type String into [ProductType]
class ProductTypeDTO extends EnumDTO {
  const ProductTypeDTO._internal(String value) : super.internal(value);

  /// Currenct account
  static const current = ProductTypeDTO._internal('R');

  /// Savings account
  static const savings = ProductTypeDTO._internal('S');

  /// Term deposit
  static const termDeposit = ProductTypeDTO._internal('T');

  /// Loan
  static const loan = ProductTypeDTO._internal('L');

  /// Debit card
  static const debitCard = ProductTypeDTO._internal('D');

  /// Credit card
  static const creditCard = ProductTypeDTO._internal('C');

  /// List of all possible product types
  static const List<ProductTypeDTO> values = [
    current,
    savings,
    termDeposit,
    loan,
    debitCard,
    creditCard,
  ];

  /// Convert string to [ProductTypeDTO]
  static ProductTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
