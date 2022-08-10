/// Holds the data of a [Customer] limits.
class CustomerLimitDTO {
  /// The daily international beneficiaries limit.
  final num? dailyInternationalBeneficiaries;

  /// The used daily international beneficiaries limit.
  final num? dailyInternationalBeneficiariesUsed;

  /// The own transaction limit.
  final num? limOwnTransaction;

  /// The daily own transaction limit.
  final num? limOwnDaily;

  /// The used daily own transaction limit.
  final num? usageOwnDaily;

  /// The own transaction cumulative limit.
  final num? limCumulativeDaily;

  /// The own transaction limit.
  final num? usageCumulativeDaily;

  /// The used daily own transaction limit.
  final num? usageLimOwnDaily;

  /// The monthly own transaction limit.
  final num? limOwnMonthly;

  /// The used monthly own transaction limit.
  final num? usageLimOwnMonthly;

  /// The used card transaction limit.
  final num? cardUsageOwnDaily;

  /// The used card transaction limit.
  final num? limCrdTransaction;

  /// The daily card transaction limit.
  final num? limCrdDaily;

  /// The monthly card transaction limit.
  final num? limCrdMonthly;

  /// The daily card transaction limit.
  final num? usageCrdDaily;

  /// The monthtly used transaction limit.
  final num? usageCrdMonthly;

  /// The daily used card amount.
  final num? cardUsageCrdDaily;

  /// The monthly card usage for bank transactions.
  final num? cardUsageBnkMonthly;

  /// The daily card usage for bank transactions.
  final num? cardUsageBnkDaily;

  /// The monthly card usage for domestic transactions.
  final num? cardUsageNumDomMonthly;

  /// The daily card usage for international transactions.
  final num? cardUsageIntDaily;

  /// The daily limit amount for card transactions.
  final num? usageLimCrdDaily;

  /// The bank transactions limit.
  final num? limBnkTransaction;

  /// The daily bank transactions limit.
  final num? limBnkDaily;

  /// The monthly bank transactions limit.
  final num? limBnkMonthly;

  /// The daily bank transactions usage.
  final num? usageBnkDaily;

  /// The monthly bank transactions usage.
  final num? usageBnkMonthly;

  /// The domestic transactions limit.
  final num? limDomTransaction;

  /// The daily transactions limit.
  final num? limDomDaily;

  /// The monthly domestic transactions limit.
  final num? limDomMonthly;

  /// The daily domestic transaction usage.
  final num? usageDomDaily;

  /// The monthly domestic transaction usage.
  final num? usageDomMonthly;

  /// The daily card usage for domestic transactions.
  final num? cardUsageDomDaily;

  /// The monthly domestic transaction count.
  final num? numDomMonthly;

  /// The monthly used domestic transaction count.
  final num? usageNumDomMonthly;

  /// The international transactions limit.
  final num? limIntTransaction;

  /// The daily international transactions limit.
  final num? limIntDaily;

  /// The monthly international transactions limit.
  final num? limIntMonthly;

  /// The daily international transactions used.
  final num? usageIntDaily;

  /// The monthly international transactions used.
  final num? usageIntMonthly;

  /// The daily international transaction used limit.
  final num? usageLimIntDaily;

  /// The C2C transaction limit.
  final num? limC2CTransaction;

  /// The monthly C2C transaction limit.
  final num? limC2CMonthly;

  /// The daily C2C transaction limit.
  final num? limC2CDaily;

  /// The daily C2C transaction count.
  final num? numC2CDaily;

  /// The monthly C2C transaction count.
  final num? numC2CMonthly;

  /// The daily C2C transaction usage.
  final num? usageC2CDaily;

  /// The monthly C2C transaction usage
  final num? usageC2CMonthly;

  /// The bill transaction limit.
  final num? limBillTransaction;

  /// The daily bill transaction limit.
  final num? limBillDaily;

  /// The monthly bill transaction limit.
  final num? limBillMonthly;

  /// The daily bill transactions usage.
  final num? usageBillDaily;

  /// The monthly bill transactions usage.
  final num? usageBillMonthly;

  /// The daily top up limit.
  final num? limTopupDaily;

  /// The daily top up usage.
  final num? usageTopupDaily;

  /// The preferred currency of the customer.
  final String? prefCurrency;

  /// Creates a new [CustomerLimitDTO] instance.
  CustomerLimitDTO({
    this.limOwnTransaction,
    this.limOwnDaily,
    this.usageOwnDaily,
    this.cardUsageOwnDaily,
    this.limCrdTransaction,
    this.limCrdDaily,
    this.limCrdMonthly,
    this.usageCrdDaily,
    this.usageCrdMonthly,
    this.cardUsageCrdDaily,
    this.limBnkTransaction,
    this.limBnkDaily,
    this.limBnkMonthly,
    this.usageBnkDaily,
    this.cardUsageBnkDaily,
    this.usageBnkMonthly,
    this.cardUsageBnkMonthly,
    this.limDomTransaction,
    this.limDomDaily,
    this.limDomMonthly,
    this.usageDomDaily,
    this.usageDomMonthly,
    this.cardUsageDomDaily,
    this.numDomMonthly,
    this.usageNumDomMonthly,
    this.cardUsageNumDomMonthly,
    this.limIntTransaction,
    this.limIntDaily,
    this.limIntMonthly,
    this.usageIntDaily,
    this.usageIntMonthly,
    this.cardUsageIntDaily,
    this.limCumulativeDaily,
    this.usageCumulativeDaily,
    this.limTopupDaily,
    this.usageTopupDaily,
    this.usageLimIntDaily,
    this.usageLimOwnDaily,
    this.prefCurrency,
    this.limOwnMonthly,
    this.usageLimOwnMonthly,
    this.dailyInternationalBeneficiaries,
    this.dailyInternationalBeneficiariesUsed,
    this.limC2CTransaction,
    this.limC2CMonthly,
    this.limC2CDaily,
    this.numC2CDaily,
    this.numC2CMonthly,
    this.usageC2CDaily,
    this.usageC2CMonthly,
    this.limBillTransaction,
    this.limBillDaily,
    this.limBillMonthly,
    this.usageBillDaily,
    this.usageBillMonthly,
    this.usageLimCrdDaily,
  });

  /// Creates a new [CustomerLimitDTO] from json map.
  factory CustomerLimitDTO.fromJson(Map<String, dynamic> json) {
    final response = json['total_limits'];

    if (response == null) return CustomerLimitDTO();

    return CustomerLimitDTO(
      limOwnTransaction: response['lim_own_transaction'],
      limOwnDaily: response['lim_own_daily'],
      usageOwnDaily: response['usage_own_daily'],
      cardUsageOwnDaily: response['card_usage_own_daily'],
      limCrdTransaction: response['lim_crd_transaction'],
      limCrdDaily: response['lim_crd_daily'],
      limCrdMonthly: response['lim_crd_monthly'],
      usageCrdDaily: response['usage_crd_daily'],
      usageCrdMonthly: response['usage_crd_monthly'],
      cardUsageCrdDaily: response['card_usage_crd_daily'],
      limBnkTransaction: response['lim_bnk_transaction'],
      limBnkDaily: response['lim_bnk_daily'],
      limBnkMonthly: response['lim_bnk_monthly'],
      usageBnkDaily: response['usage_lim_bnk_daily'],
      cardUsageBnkDaily: response['card_usage_bnk_daily'],
      usageBnkMonthly: response['usage_lim_bnk_monthly'],
      cardUsageBnkMonthly: response['card_usage_bnk_monthly'],
      limDomTransaction: response['lim_dom_transaction'],
      limDomDaily: response['lim_dom_daily'],
      limDomMonthly: response['lim_dom_monthly'],
      usageDomDaily: response['usage_lim_dom_daily'],
      usageDomMonthly: response['usage_lim_dom_monthly'],
      cardUsageDomDaily: response['card_usage_dom_daily'],
      usageLimCrdDaily: response['usage_lim_crd_daily'],
      numDomMonthly: response['num_dom_monthly'],
      usageNumDomMonthly: response['usage_num_dom_monthly'],
      cardUsageNumDomMonthly: response['card_usage_num_dom_monthly'],
      limIntTransaction: response['lim_int_transaction'],
      limIntDaily: response['lim_int_daily'],
      limIntMonthly: response['lim_int_monthly'],
      usageIntDaily: response['usage_lim_int_daily'],
      usageIntMonthly: response['usage_lim_int_monthly'],
      cardUsageIntDaily: response['card_usage_int_daily'],
      limCumulativeDaily: response['lim_cumulative_daily'],
      usageCumulativeDaily: response['usage_lim_cumulative_daily'],
      limTopupDaily: response['lim_topup_daily'],
      usageTopupDaily: response['usage_lim_topup_daily'],
      usageLimIntDaily: response['usage_lim_int_daily'],
      usageLimOwnDaily: response['usage_lim_own_daily'],
      prefCurrency: json['pref_currency'],
      limOwnMonthly: response['lim_own_monthly'],
      usageLimOwnMonthly: response['usage_lim_own_monthly'],
      dailyInternationalBeneficiaries: response['num_int_beneficiary_daily'],
      dailyInternationalBeneficiariesUsed:
          response['usage_num_int_beneficiary_daily'],
      limC2CTransaction: response['lim_c2c_transaction'],
      limC2CMonthly: response['lim_c2c_monthly'],
      limC2CDaily: response['lim_c2c_daily'],
      numC2CDaily: response['num_c2c_daily'],
      numC2CMonthly: response['num_c2c_monthly'],
      usageC2CDaily: response['usage_lim_c2c_daily'],
      usageC2CMonthly: response['usage_lim_c2c_monthly'],
      limBillTransaction: response['lim_bill_transaction'],
      limBillDaily: response['lim_bill_daily'],
      limBillMonthly: response['lim_bill_monthly'],
      usageBillDaily: response['usage_lim_bill_daily'],
      usageBillMonthly: response['usage_lim_bill_monthly'],
    );
  }
}
