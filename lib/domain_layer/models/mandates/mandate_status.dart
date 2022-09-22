/// enum that holds the status of a [Mandate]
enum MandateStatus {
  /// Mandate with Active status
  active,

  /// Mandate with Pending status
  pending,

  /// Mandate with Rejecting status
  rejecting,

  /// Mandate with Cancelling status
  cancelling,

  /// Mandate with Cancelled status
  cancelled,

  /// Mandate with Rejected status
  rejected,

  /// Madate with no status defined
  unknown,
}
