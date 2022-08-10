import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [AccountTopUpRequestDTO]
extension AccountTopUpRequestDTOMapping on AccountTopUpRequestDTO {
  /// Maps into [AccountTopUpRequest].
  AccountTopUpRequest toAccountTopUpRequest() => AccountTopUpRequest(
        clientSecret: clientSecret ?? '',
        id: id ?? '',
      );
}
