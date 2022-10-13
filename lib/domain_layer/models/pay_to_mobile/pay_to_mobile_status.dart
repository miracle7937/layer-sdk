/// The available statuses for a pay to mobile element.
enum PayToMobileStatus {
  /// Completed.
  completed,

  /// Rejected.
  rejected,

  /// Pending.
  pending,

  /// Failed.
  failed,

  /// Deleted.
  deleted,

  /// Expired.
  expired,

  /// Bank pending.
  bankPending,

  /// Pending second factor.
  pendingSecondFactor,
}
