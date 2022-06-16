import 'package:equatable/equatable.dart';

/// Holds properties that describe a step of the process.
class DPAProcessStepProperties extends Equatable {
  /// The format for this step.
  final DPAStepFormat format;

  /// The type of the screen for this step.
  final DPAScreenType screenType;

  /// The label of the confirmation button, for instance, "Continue".
  final String? confirmLabel;

  /// The label of the cancellation button.
  final String? cancelLabel;

  /// If the save button should be displayed.
  final bool showSave;

  /// The number mask.
  final String? maskedNumber;

  /// An email address
  final String? email;

  /// An image URL to display.
  final String? image;

  /// The path to the background image.
  final String? backgroundUrl;

  /// Feedback from the server.
  final String? feedback;

  /// The alignment of the DPAScreen.
  final DPAScreenAlignment alignment;

  /// Creates a new [DPAProcessStepProperties].
  DPAProcessStepProperties({
    required this.format,
    required this.screenType,
    required this.alignment,
    required this.showSave,
    this.confirmLabel,
    this.cancelLabel,
    this.maskedNumber,
    this.email,
    this.image,
    this.backgroundUrl,
    this.feedback,
  });

  @override
  List<Object?> get props => [
        format,
        screenType,
        confirmLabel,
        cancelLabel,
        showSave,
        maskedNumber,
        email,
        image,
        backgroundUrl,
        feedback,
        alignment,
      ];

  /// Creates a new [DPAProcessStepProperties] using another as a base.
  DPAProcessStepProperties copyWith({
    DPAStepFormat? format,
    DPAScreenType? screenType,
    String? confirmLabel,
    String? cancelLabel,
    bool? showSave,
    String? maskedNumber,
    String? email,
    String? image,
    String? backgroundUrl,
    String? feedback,
    DPAScreenAlignment? alignment,
  }) =>
      DPAProcessStepProperties(
        format: format ?? this.format,
        screenType: screenType ?? this.screenType,
        confirmLabel: confirmLabel ?? this.confirmLabel,
        cancelLabel: cancelLabel ?? this.cancelLabel,
        showSave: showSave ?? this.showSave,
        maskedNumber: maskedNumber ?? this.maskedNumber,
        email: email ?? this.email,
        image: image ?? this.image,
        backgroundUrl: backgroundUrl ?? this.backgroundUrl,
        feedback: feedback ?? this.feedback,
        alignment: alignment ?? this.alignment,
      );
}

/// The type of screen to show for this step.
enum DPAScreenType {
  /// OTP
  otp,

  /// PIN
  pin,

  /// E-mail
  email,

  /// Other
  other,

  /// Entity search
  entitySearch,

  /// Two columns
  twoColumns,
}

/// How to show this step.
enum DPAStepFormat {
  /// Pop-up
  popUp,

  /// Display
  display,

  /// Other
  other,
}

/// All available DPAScreen alignments
enum DPAScreenAlignment {
  /// Image on top, description below.
  imageDescription,

  /// Description on top, image below.
  descriptionImage,
}
