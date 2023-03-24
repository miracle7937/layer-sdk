import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mappings for [Account]
extension AccountMapping on Account {
  /// Maps into a [AccountDTO]
  AccountDTO toAccountDTO() => AccountDTO(
        accountId: id,
        type: accountInfo?.toAccountTypeDTO(),
        currency: currency,
        reference: reference,
        availableBalance: availableBalance?.toDouble(),
        currentBalance: currentBalance?.toDouble(),
        balanceVisible: balanceVisible,
        status: status?.toAccountDTOStatus(),
        canPay: canPay,
        canTransferOwn: canTransferOwn,
        canTransferBank: canTransferBank,
        canTransferDomestic: canTransferDomestic,
        canTransferInternational: canTransferInternational,
        canTransferBulk: canTransferBulk,
        canTransferCardless: canTransferCardless,
        canReceiveTransfer: canReceiveTransfer,
        canRequestCard: canRequestCard,
        canRequestChkbk: canRequestChkbk,
        canOverdraft: canOverdraft,
        canTransferRemittance: canTransferRemittance,
        canRequestStatement: canRequestStatement,
        canRequestBankerCheck: canRequestBankerCheck,
        canRequestCertificateOfAccount: canRequestCertificateOfAccount,
        canRequestCertificateOfDeposit: canRequestCertificateOfDeposit,
        accountNumber: accountNumber,
        displayAccountNumber: formattedAccountNumber,
        branchId: branchId,
        extraBranchId: extraBranchId,
        preferences: preferences.toAccountPreferencesDTO(),
        created: creationDate,
      );
}

/// Extension that provides mapping for [AccountStatus]
extension AccountStatusMapping on AccountStatus {
  /// Maps a [AccountStatus] to a [AccountDTOStatus]
  AccountDTOStatus toAccountDTOStatus() {
    switch (this) {
      case AccountStatus.active:
        return AccountDTOStatus.active;
      case AccountStatus.closed:
        return AccountDTOStatus.closed;
      case AccountStatus.deleted:
        return AccountDTOStatus.deleted;
      case AccountStatus.dormant:
        return AccountDTOStatus.dormant;
      default:
        throw MappingException(from: AccountStatus, to: AccountDTOStatus);
    }
  }
}

/// Extension that provides mapping for [AccountInfo]
extension AccountInfoMapping on AccountInfo {
  /// Maps a [AccountInfo] to a [AccountTypeDTO]
  AccountTypeDTO toAccountTypeDTO() => AccountTypeDTO(
        type: accountType?.toAccountTypeDTOType(),
        family: family,
        name: accountName,
        description: accountDescription,
      );
}

/// Extension that provides mapping for [AccountType]
extension AccountTypeMapping on AccountType {
  /// Maps a [AccountType] to a [AccountTypeDTOType]
  AccountTypeDTOType toAccountTypeDTOType() {
    switch (this) {
      case AccountType.current:
        return AccountTypeDTOType.current;
      case AccountType.termDeposit:
        return AccountTypeDTOType.termDeposit;
      case AccountType.creditCard:
        return AccountTypeDTOType.creditCard;
      case AccountType.loan:
        return AccountTypeDTOType.loan;
      case AccountType.securities:
        return AccountTypeDTOType.securities;
      case AccountType.finance:
        return AccountTypeDTOType.finance;
      case AccountType.savings:
        return AccountTypeDTOType.savings;
      case AccountType.tradeFinance:
        return AccountTypeDTOType.tradeFinance;
    }
  }
}

/// Extension that provides mappings for [AccountPreferences]
extension AccountPreferencesMapping on AccountPreferences {
  /// Maps into a [AccountPreferencesDTO]
  AccountPreferencesDTO toAccountPreferencesDTO() => AccountPreferencesDTO(
        nickname: nickname,
        alertTxn: alertOnTransaction,
        alertLowBal: alertOnLowBalance,
        alertPmt: alertOnPayment,
        lowBal: lowBalance,
        favorite: favorite,
        display: isVisible,
        showBalance: showBalance,
      );
}
