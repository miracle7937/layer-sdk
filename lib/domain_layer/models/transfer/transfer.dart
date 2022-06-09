///The recurrence of the transfer
enum TransferRecurrence {
  ///once
  once,

  ///daily
  daily,

  ///weekly
  weekly,

  ///biweekly
  biweekly,

  ///monthly
  monthly,

  ///bimonthly
  bimonthly,

  ///quarterly
  quarterly,

  ///yearly
  yearly,

  ///endOfEachMonth
  endOfEachMonth,

  ///none
  none,
}

///The status of the transfer
enum TransferStatus {
  ///Completed
  completed,

  ///Pending
  pending,

  ///Scheduled
  scheduled,

  ///Failed
  failed,

  ///Canceled
  cancelled,

  ///Rejected
  rejected,

  ///Pending expired
  pendingExpired,

  ///OTP
  otp,

  ///OTP Expired
  otpExpired,

  /// Deleted
  deleted,
}

///The type of the transfer
enum TransferType {
  ///Own
  own,

  ///Bank
  bank,

  ///Domestic
  domestic,

  ///International
  international,

  ///Bulk
  bulk,

  ///Instant
  instant,

  ///Cash in
  cashIn,

  ///Cash out
  cashOut,

  ///Mobile to beneficiary
  mobileToBeneficiary,

  ///Merchant transfer
  merchantTransfer,
}

// TODO: Add transfer model here.