import '../dtos.dart';
import '../helpers.dart';

///Data object that represents financial data
class FinancialDataDTO {
  /// Account type balances
  Map<AccountTypeDTOType, double>? accountTypeBalances;

  /// Card category balances
  Map<CardCategoryDTO, double>? cardCategoryBalances;

  /// Available credit
  dynamic availableCredit;

  /// Remaining balance
  dynamic remainingBalance;

  /// Upcoming payments
  dynamic upcomingPayments;

  /// Card balance
  dynamic cardBalance;

  /// Pref currency
  String? prefCurrency;

  ///Creates a new [FinancialDataDTO] object
  FinancialDataDTO({
    this.accountTypeBalances,
    this.cardCategoryBalances,
    this.availableCredit,
    this.remainingBalance,
    this.upcomingPayments,
    this.cardBalance,
    this.prefCurrency,
  });

  /// Creates a new [FinancialDataDTO] from json
  FinancialDataDTO.fromJson(Map<String, dynamic> json) {
    _setProperties(json);
  }

  void _setProperties(Map<String, dynamic> json) {
    List<dynamic> dynamicAccountTypeBalances = json['acct_type_balances'];
    final accountTypeBalances = <AccountTypeDTOType, double>{};

    for (var typeBalanceObject in dynamicAccountTypeBalances) {
      int accountTypeId = typeBalanceObject['type'];

      var key = AccountTypeDTOType.values[accountTypeId];

      final balance = typeBalanceObject['balance'] is String
          ? 0.0
          : JsonParser.parseDouble(
              typeBalanceObject['balance'],
            );
      if (balance != null) {
        accountTypeBalances[key] = balance;
      }
    }

    List<dynamic> dynamicCardTypeBalances = json['card_category_balances'];
    final cardCategoryBalances = <CardCategoryDTO, double>{};

    for (final cardTypeBalances in dynamicCardTypeBalances) {
      cardTypeBalances.forEach((stringKey, stringValue) {
        final cardCategoryId = int.parse(stringKey);

        final key = CardCategoryDTO.values[cardCategoryId];

        final value = double.parse(stringValue);

        cardCategoryBalances[key] = value;
      });
    }

    this.accountTypeBalances = accountTypeBalances;
    this.cardCategoryBalances = cardCategoryBalances;

    availableCredit = json['available_credit'] is String
        ? json['available_credit']
        : json['available_credit']?.toDouble();

    remainingBalance = json['remaining_balance'] is String
        ? json['remaining_balance']
        : json['remaining_balance']?.toDouble();

    upcomingPayments = json['upcoming_payments'] is String
        ? json['upcoming_payments']
        : json['upcoming_payments']?.toDouble();

    cardBalance = json['card_balance'] is String
        ? json['card_balance']
        : json['card_balance']?.toDouble();

    prefCurrency = json['pref_currency'];
  }

  /// Returns total remaining balance
  num? getTotal() {
    return remainingBalance;
  }

  /// Getter for total balance
  num? get total => getTotal();
}

///Data object that represents account's financial data
class AccountsFinancialDataDTO extends FinancialDataDTO {
  /// Included account types only
  List<AccountTypeDTOType>? includeOnly;

  /// Creates a new [CardsFinancialDataDTO] from json
  AccountsFinancialDataDTO.fromJson(Map<String, dynamic> json) {
    _setProperties(json);
  }

  /// Included types only
  void includeTypes(List<AccountTypeDTOType>? types) {
    includeOnly =
        (types == null || types.isEmpty) ? AccountTypeDTOType.values : types;
    accountTypeBalances
        ?.removeWhere((type, val) => !includeOnly!.contains(type));
  }

  @override
  num? getTotal() {
    return includeOnly!.fold<num>(0, (prev, accType) {
      if (!(accountTypeBalances?.containsKey(accType) ?? false)) return prev;
      return prev + (accountTypeBalances?[accType] ?? 0);
    });
  }
}

///Data object that represents card's financial data
class CardsFinancialDataDTO extends FinancialDataDTO {
  /// Included card types only
  List<CardCategoryDTO>? includeOnly;

  /// Creates a new [CardsFinancialDataDTO] from json
  CardsFinancialDataDTO.fromJson(Map<String, dynamic> json,
      [this.includeOnly]) {
    _setProperties(json);
  }

  /// Includes card categories
  void includeCategories(List<CardCategoryDTO>? categories) {
    includeOnly = (categories == null || categories.isEmpty)
        ? CardCategoryDTO.values
        : categories;
    cardCategoryBalances?.removeWhere((category, val) {
      return !includeOnly!.contains(category);
    });
  }

  @override
  num? getTotal() {
    return includeOnly?.fold<num>(0, (prev, category) {
      if (!(cardCategoryBalances?.containsKey(category) ?? false)) return prev;
      return prev + (cardCategoryBalances?[category] ?? 0);
    });
  }
}
