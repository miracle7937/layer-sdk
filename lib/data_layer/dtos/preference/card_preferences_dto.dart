/// Pref card DTO
class CardPreferencesDTO {
  /// Pref card nickname
  String? nickname;

  /// True means card is favorite
  bool favorite;

  /// True means display card
  bool display;

  /// Alert on transactions
  bool alertTxn;

  /// Alert on payment
  bool alertPmt;

  /// Alert on expiry
  bool alertExpiry;

  /// Whether to show balance or not
  bool showBalance;

  /// Alert on low credit
  bool alertLowCredit;

  /// Pref low credit amount
  double? lowCredit;

  /// Creates a new [CardPreferencesDTO].
  CardPreferencesDTO({
    this.nickname,
    this.favorite = false,
    this.display = true,
    this.alertTxn = true,
    this.alertPmt = true,
    this.alertExpiry = true,
    this.showBalance = true,
    this.alertLowCredit = true,
    this.lowCredit,
  });

  /// Creates a [CardPreferencesDTO] from a JSON
  static CardPreferencesDTO fromJson(Map<String, dynamic> json) {
    return CardPreferencesDTO(
      nickname: json['pref_nickname'],
      favorite: json['pref_favorite'] ?? false,
      display: json['pref_display'] ?? true,
      alertTxn: json['pref_alert_txn'] ?? true,
      alertPmt: json['pref_alert_pmt'] ?? true,
      alertExpiry: json['pref_alert_expiry'] ?? true,
      showBalance: json['pref_show_balance'] ?? true,
      alertLowCredit: json['pref_alert_lowcredit'] ?? true,
      lowCredit: json['pref_lowcredit']?.toDouble(),
    );
  }

  /// Returns a list of [CardPreferencesDTO] from a JSON
  static List<CardPreferencesDTO> fromJsonMap(Map<String, dynamic> json) =>
      json.keys
          .map((key) => CardPreferencesDTO(
                nickname: json[key]['pref_nickname'],
                favorite: json[key]['pref_favorite'] ?? false,
                display: json[key]['pref_display'] ?? true,
                alertTxn: json[key]['pref_alert_txn'] ?? true,
                alertPmt: json[key]['pref_alert_pmt'] ?? true,
                alertExpiry: json[key]['pref_alert_expiry'] ?? true,
                showBalance: json[key]['pref_show_balance'] ?? true,
                alertLowCredit: json[key]['pref_alert_lowcredit'] ?? true,
                lowCredit: json[key]['pref_lowcredit']?.toDouble(),
              ))
          .toList();
}
