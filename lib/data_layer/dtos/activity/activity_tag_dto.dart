/// The tag of the [ActivityDTO]
enum ActivityTagDTO {
  /// Unknown
  unknown('unknown'),

  /// Products and Services
  productsAndServices('products_services'),

  /// Profile
  profile('profile');

  /// The string value for the [ActivityTagDTO].
  final String value;

  /// Creates a new [ActivityTagDTO].
  const ActivityTagDTO(this.value);
}
