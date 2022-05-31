/// Pref account object
class AccountPreferencesDTO {
  /// The pref nickname
  String? nickname;

  /// Alert on transactions
  bool? alertTxn;

  /// Alert on low balance
  bool? alertLowBal;

  /// Alert on payment
  bool? alertPmt;

  /// Alert
  double? lowBal;

  /// Whether the account is favorite or not
  bool? favorite;

  /// Pref display
  bool? display;

  /// Pref show balance
  bool? showBalance;

  /// Creates a new [AccountPreferencesDTO].
  AccountPreferencesDTO({
    this.nickname,
    this.alertTxn = true,
    this.alertLowBal = true,
    this.alertPmt = true,
    this.lowBal,
    this.favorite = false,
    this.display = true,
    this.showBalance = true,
  });

  /// Parses a [AccountPreferencesDTO] from a JSON
  static AccountPreferencesDTO fromJson(Map<String, dynamic> json) {
    return AccountPreferencesDTO(
      nickname: json['pref_nickname'],
      alertTxn: json['pref_alert_txn'] ?? true,
      alertLowBal: json['pref_alert_lowbal'] ?? true,
      alertPmt: json['pref_alert_pmt'] ?? true,
      lowBal: json['pref_lowbal']?.toDouble(),
      favorite: json['pref_favorite'] ?? false,
      display: json['pref_display'] ?? true,
      showBalance: json['pref_show_balance'] ?? true,
    );
  }

  /// Returns a list of [AccountPreferencesDTO] from a JSON
  static List<AccountPreferencesDTO> fromJsonMap(Map<String, dynamic> json) =>
      json.keys
          .map((key) => AccountPreferencesDTO(
                nickname: json[key]['pref_nickname'],
                alertTxn: json[key]['pref_alert_txn'] ?? true,
                alertLowBal: json[key]['pref_alert_lowbal'] ?? true,
                alertPmt: json[key]['pref_alert_pmt'] ?? true,
                lowBal: json[key]['pref_lowbal']?.toDouble(),
                favorite: json[key]['pref_favorite'] ?? false,
                display: json[key]['pref_display'] ?? true,
                showBalance: json[key]['pref_show_balance'] ?? true,
              ))
          .toList();
}
