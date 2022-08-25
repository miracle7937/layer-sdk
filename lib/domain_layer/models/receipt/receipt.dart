/// Enum that defines all possible receipts types.
enum ReceiptType {
  /// PDF receipt
  pdf,

  /// Image receipt
  image,
}

/// Enum that defines all possible types of action for receipts.
enum ReceiptActionType {
  /// Beneficiary action
  beneficiary,

  /// Transfer action
  transfer,

  /// Bill payment action
  payment,

  /// Top up action
  topUp,
}
