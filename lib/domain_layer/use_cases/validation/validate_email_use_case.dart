/// Use case that validates an email.
class ValidateEmailUseCase {
  /// Validates the provided email.
  bool call({
    required String email,
  }) {
    if (email.isEmpty) return false;

    final regex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );

    return regex.hasMatch(email);
  }
}
