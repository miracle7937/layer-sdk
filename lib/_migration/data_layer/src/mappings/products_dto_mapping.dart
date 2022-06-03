import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mappings for [ProductDTO]
extension ProductDTOMapping on ProductDTO {
  /// Maps a [ProductDTO] into a [Product]
  Product toProduct() {
    return Product(
      id: id ?? '',
      tsCreated: tsCreated,
      tsUpdated: tsUpdated,
      productType: productType.toProductType(),
      amountDisbursed: amountDisbursed,
      name: name ?? '',
      title: title ?? '',
      description: description ?? '',
      features: features ?? '',
      benefits: benefits ?? '',
      eligibility: eligibility ?? '',
      fees: fees ?? '',
      imageUrl: imageUrl ?? '',
      interestRate: interestRate,
      insuranceRate: insuranceRate,
      insuranceFees: insuranceFees,
      processingFees: processingFees,
      minAmount: minAmount,
      maxAmount: maxAmount,
      minSalary: minSalary,
      maxSalary: maxSalary,
      minTenor: minTenor,
      maxTenor: maxTenor,
      maxDbr: maxDbr,
      appointmentSlots: appointmentSlots,
    );
  }
}

/// Provides mapping functionality for [ProductTypeDTO]
extension ProductTypeDTOMapping on ProductTypeDTO {
  /// Maps a [ProductTypeDTO] into a [ProductType]
  ProductType toProductType() {
    switch (this) {
      case ProductTypeDTO.current:
        return ProductType.current;
      case ProductTypeDTO.savings:
        return ProductType.savings;
      case ProductTypeDTO.termDeposit:
        return ProductType.termDeposit;
      case ProductTypeDTO.loan:
        return ProductType.loan;
      case ProductTypeDTO.debitCard:
        return ProductType.debitCard;
      case ProductTypeDTO.creditCard:
        return ProductType.creditCard;
      default:
        return ProductType.current;
    }
  }
}
