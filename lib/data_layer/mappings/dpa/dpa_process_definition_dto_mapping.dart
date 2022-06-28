import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [DPAProcessDefinitionDTO].
extension DPAProcessDefinitionDTOMapping on DPAProcessDefinitionDTO {
  /// Maps into a [DPAProcessDefinition]
  DPAProcessDefinition toDPAProcessDefinition() => DPAProcessDefinition(
        id: id ?? '',
        key: key,
        name: name,
        description: description,
        suspended: suspended,
        version: version,
        deploymentId: deploymentId,
        section: key.toDPAProcessDefinitionSection(),
        iconUrl: toIconURL(),
      );

  /// Maps into an icon file.
  /// TODO: this should come from the backend in the future.
  String? toIconURL() {
    switch (key) {
      case 'open_call_account':
        return 'call_account.svg';

      case 'credit_card':
      case 'credit_card_console':
        return 'credit_card_request.svg';

      case 'open_current_account':
      case 'open_term_account':
      case 'open_barakat_account':
        return 'current_account.svg';

      case 'open_escrow_account':
        return 'excrow_account.svg'; // (sic)

      case 'finance_console':
        return 'finance_request.svg';

      case 'onboarding':
        return 'onboarding.svg';

      case 'checkbook_console':
      case 'checkbook_request_account':
      case 'checkbook_request_baraka':
        return 'request_a_checkbook.svg';

      case 'manager_check_console':
      case 'banker_check_request':
        return 'request_a_manager_check.svg';

      case 'open_savings_account':
        return 'saving_account.svg';

      // Files without processes for now:
      // case '':
      //   return 'certificate_of_account_request.svg';
      //
      // case '':
      //   return 'certificate_of_deposit_request.svg';
      // case '':
      //   return 'deposits_account.svg';
      // case '':
      //   return 'dispute_transactions.svg';
      // case '':
      //   return 'official_bank_statement_request.svg';

      default:
        return null;
    }
  }
}

/// Extension that provides mappings for `String` specific to
/// [DPAProcessDefinitionDTO].
extension DPAProcessDefinitionDTOStringMapping on String {
  /// Maps into a [DPAProcessDefinitionSection].
  DPAProcessDefinitionSection toDPAProcessDefinitionSection() {
    if (startsWith('open_')) {
      return DPAProcessDefinitionSection.additionalAccount;
    }

    if (contains('onboarding')) return DPAProcessDefinitionSection.other;

    return DPAProcessDefinitionSection.request;
  }
}
