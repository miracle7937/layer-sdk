import '../../../domain_layer/models.dart';
import '../../errors.dart';

Map<CustomerType, String> _customerTypeMapping = {
  CustomerType.personal: 'P',
  CustomerType.corporate: 'C',
  CustomerType.joint: 'J',
};

/// Extension that provides mappings for [CustomerType]
extension CustomerTypeDTOMapping on CustomerType {
  /// Maps into a [CustomerDTOType]
  String toCustomerDTOType() {
    final result = _customerTypeMapping[this];

    if (result != null) return result;

    throw MappingException(from: CustomerType, to: String);
  }
}

/// Extension that provides customer mappings for String
extension CustomerDTOStringMapping on String {
  /// Maps into a [CustomerType]
  CustomerType toCustomerType() {
    for (final entry in _customerTypeMapping.entries) {
      if (entry.value == this) return entry.key;
    }

    throw MappingException(from: String, to: CustomerType);
  }
}
