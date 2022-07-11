import 'package:equatable/equatable.dart';

/// The verify pin response
class VerifyPinResponse extends Equatable {
  /// Whether the pin verification was successful or not
  final bool isVerified;

  /// The remaining attempts for the current pin verification
  final int? remainingAttempts;

  /// Creates a new [VerifyPinResponse]
  const VerifyPinResponse({
    this.isVerified = false,
    this.remainingAttempts,
  });

  /// Returns a copy of the [VerifyPinResponse] modified by the provided data.
  VerifyPinResponse copyWith({
    bool? isVerified,
    int? remainingAttempts,
  }) =>
      VerifyPinResponse(
        isVerified: isVerified ?? this.isVerified,
        remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      );

  @override
  List<Object?> get props => [
        isVerified,
        remainingAttempts,
      ];
}
