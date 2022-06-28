/// The available statuses for a DPA task/process.
///
/// This was copied mostly from the x-app model. There was an All option
/// that doesn't make sense, so it was removed from this for now.
enum DPAStatus {
  /// This task is currently active.
  active,

  /// Pending approval by the bank.
  pendingBankApproval,

  /// Pending approval by other user.
  pendingUserApproval,

  /// This task is completed.
  completed,

  /// An edit has been requested.
  editRequested,

  /// This task has been cancelled.
  cancelled,

  /// This task has not been approved.
  rejected,

  /// This task has failed.
  failed,
}
