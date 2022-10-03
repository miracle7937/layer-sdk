/// Represents a customer's account balance
/// as provided by the infobanking service
class AccountBalanceDTO {
  /// The account balance
  final num? balance;

  /// The period start date
  final String? periodStartDate;

  /// This period end date
  final String? periodEndDate;

  /// The preferred currency
  final String? prefCurrency;

  /// Creates a new [AccountBalanceDTO]
  AccountBalanceDTO({
    this.periodEndDate,
    this.periodStartDate,
    this.prefCurrency,
    this.balance,
  });

  /// Creates a new instance of [AccountBalanceDTO] from a JSON
  factory AccountBalanceDTO.fromJson(Map<String, dynamic> json) {
    return AccountBalanceDTO(
      periodEndDate: json['period_end_date'],
      periodStartDate: json['period_start_date'],
      prefCurrency: json['pref_currency'],
      balance: json['balance'],
    );
  }

  /// Creates a list of [AccountBalanceDTO] from a JSON list
  static List<AccountBalanceDTO> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map(AccountBalanceDTO.fromJson).toList(growable: false);
  }
}
