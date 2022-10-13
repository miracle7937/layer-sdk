/// The available statuses for a pay to mobile element.
enum PayToMobileStatusDTO {
  /// Expired.
  expired('E'),

  /// Completed.
  completed('C'),

  /// Pending second factor.
  pendingSecondFactor('O'),

  /// Bank pending.
  bankPending('B'),

  /// Rejected.
  rejected('R'),

  /// Pending.
  pending('P'),

  /// Failed.
  failed('F'),

  /// Deleted.
  deleted('D'),

  /// Unknown.
  unknown('unknown');

  /// The string value for the [PayToMobileStatusDTO].
  final String value;

  /// Creates a new [PayToMobileStatusDTO] with the passed value.
  const PayToMobileStatusDTO(this.value);

  /// Creates a new [PayToMobileStatusDTO] from a passed string.
  factory PayToMobileStatusDTO.fromString(String status) => values.singleWhere(
        (value) => value.value == status,
        orElse: () => unknown,
      );
}
