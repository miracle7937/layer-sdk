import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mapping for [AccountDTO]
extension AccountDTOMapping on AccountDTO {
  /// Maps a [AccountDTO] instance to a [Account] model
  Account toAccount() => Account(
        accountNumber: accountNumber,
        availableBalance: availableBalance,
        currency: currency,
        currentBalance: currentBalance,
        balanceVisible: balanceVisible,
        formattedAccountNumber: displayAccountNumber,
        extraAccountNumber: extraAccountNumber,
        extraSwiftCode: extraSwiftCode,
        id: accountId,
        reference: reference,
        branchId: branchId,
        extraBranchId: extraBranchId,
        status: status?.toAccountStatus(),
        accountInfo: type?.toAccountInfo(),
        preferences:
            preferences?.toAccountPreferences() ?? const AccountPreferences(),
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
        canRequestBankerCheck: canRequestBankerCheck,
        canRequestStatement: canRequestStatement,
        canRequestCertificateOfAccount: canRequestCertificateOfAccount,
        canRequestCertificateOfDeposit: canRequestCertificateOfDeposit,
        canStopIssuedCheck: canStopIssuedCheck,
        canConfirmIssuedCheck: canConfirmIssuedCheck,
        iban: iban,
      );
}

/// Extension that provides mappings for [Account]
extension AccountToDTOMapping on Account {
  /// Maps into a [BillStatus]
  AccountDTO toAccountDTO() {
    return AccountDTO(
      accountNumber: accountNumber,
      availableBalance: double.tryParse(availableBalance.toString()),
      currency: currency,
      currentBalance: double.tryParse(currentBalance.toString()),
      balanceVisible: balanceVisible,
      displayAccountNumber: formattedAccountNumber,
      extraAccountNumber: extraAccountNumber,
      accountId: id,
      reference: reference,
      branchId: branchId,
      extraBranchId: extraBranchId,
      status: status?.toAccountDTOStatus(),
      type: accountInfo?.toAccountInfoDTO(),
      preferences: preferences.toAccountPreferencesDTO(),
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
      canRequestBankerCheck: canRequestBankerCheck,
      canRequestStatement: canRequestStatement,
      canRequestCertificateOfAccount: canRequestCertificateOfAccount,
      canRequestCertificateOfDeposit: canRequestCertificateOfDeposit,
      canStopIssuedCheck: canStopIssuedCheck,
      canConfirmIssuedCheck: canConfirmIssuedCheck,
      iban: iban,
    );
  }
}

/// Extension that provides mapping for [AccountTypeDTO]
extension AccountInfoDTOMapping on AccountInfo {
  /// Maps a [AccountTypeDTO] to a [AccountInfo]
  AccountTypeDTO toAccountInfoDTO() => AccountTypeDTO(
        type: accountType?.toAccountTypeDTOType(),
        family: family,
        name: accountName,
        description: accountDescription,
        hasIban: hasIban,
        canTransferCardless: canTransferCardless,
        canStopIssuedCheck: canStopIssuedCheck,
        canConfirmIssuedCheck: canConfirmIssuedCheck,
      );
}

/// Extension that provides mapping for [AccountDTOStatus]
extension AccountStatusDTOMapping on AccountDTOStatus {
  /// Maps a [AccountDTOStatus] to a [AccountStatus]
  AccountStatus toAccountStatus() {
    switch (this) {
      case AccountDTOStatus.active:
        return AccountStatus.active;

      case AccountDTOStatus.closed:
        return AccountStatus.closed;

      case AccountDTOStatus.deleted:
        return AccountStatus.deleted;

      case AccountDTOStatus.dormant:
        return AccountStatus.dormant;

      default:
        throw MappingException(from: AccountDTOStatus, to: AccountStatus);
    }
  }
}

/// Extension that provides mapping for [AccountStatus]
extension AccountStatusMapping on AccountStatus {
  /// Maps a [AccountStatus] to a [AccountStatusDTO]
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

/// Extension that provides mapping for [AccountTypeDTO]
extension AccountTypeDTOMapping on AccountTypeDTO {
  /// Maps a [AccountTypeDTO] to a [AccountInfo]
  AccountInfo toAccountInfo() => AccountInfo(
        accountType: type?.toAccountType(),
        family: family,
        accountName: name,
        accountDescription: description,
        hasIban: hasIban,
        canTransferCardless: canTransferCardless,
        canStopIssuedCheck: canStopIssuedCheck,
        canConfirmIssuedCheck: canConfirmIssuedCheck,
      );
}

/// Extension that provides mapping for [AccountTypeDTOType]
extension AccountTypeDTOTypeMapping on AccountTypeDTOType {
  /// Maps a [AccountTypeDTOType] to a [AccountType]
  AccountType toAccountType() {
    switch (this) {
      case AccountTypeDTOType.current:
        return AccountType.current;

      case AccountTypeDTOType.termDeposit:
        return AccountType.termDeposit;

      case AccountTypeDTOType.creditCard:
        return AccountType.creditCard;

      case AccountTypeDTOType.loan:
        return AccountType.loan;

      case AccountTypeDTOType.securities:
        return AccountType.securities;

      case AccountTypeDTOType.finance:
        return AccountType.finance;

      case AccountTypeDTOType.savings:
        return AccountType.savings;

      case AccountTypeDTOType.tradeFinance:
        return AccountType.tradeFinance;

      default:
        throw MappingException(from: AccountTypeDTOType, to: AccountType);
    }
  }
}

/// Extension that provides mapping for [AccountType]
extension AccountTypeMapping on AccountType {
  /// Maps a [AccountTypeDTOType] to a [AccountType]
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

      default:
        throw MappingException(from: AccountTypeDTOType, to: AccountType);
    }
  }
}
