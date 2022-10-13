/// The available request types for a pay to mobile element.
enum PayToMobileRequestTypeDTO {
  /// Own.
  selfCash('O'),

  /// Atm cash.
  atmCash('M'),

  /// Account.
  accountTransfer('A'),

  /// Unknown.
  unknown('unknown');

  /// The string value for the [PayToMobileRequestTypeDTO].
  final String value;

  /// Creates a new [PayToMobileRequestTypeDTO] with the passed value.
  const PayToMobileRequestTypeDTO(this.value);

  /// Creates a new [PayToMobileRequestTypeDTO] from a passed string.
  factory PayToMobileRequestTypeDTO.fromString(String requestType) =>
      values.singleWhere(
        (value) => value.value == requestType,
        orElse: () => unknown,
      );
}
