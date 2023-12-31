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

  /// An optional jumio configuration.
  final DPAJumioConfig? jumioConfig;

  /// The amount of seconds to wait in order to auto finish the task.
  ///
  /// If not null, the taks is a delay task.
  final int? delay;

  /// Defines the screen type that should be blocked (Automatically finished)
  final DPAScreenBlock block;

  /// Whether or not the [DPAHeader] should be hidden.
  ///
  /// Defaults to `false`.
  final bool hideAppBar;

  /// The label for the skip button.
  final String? skipLabel;

  /// The value for the skip button.
  final bool? skipButton;

  /// The label for the skip button.
  final String? skipButtonLabel;

  /// The amount of seconds to wait before the task is auto finished.
  final int? autoFinishIn;

  /// if the process can be cancelled
  final bool allowCancel;

  /// If the user can go back to a previous step.
  final bool? isBackAllowed;

  /// Defines how the text should be aligned.
  final TextAlignment textAlignment;

  /// Defines the cancel button action on the popup
  final CancelButtonAction cancelButtonAction;

  /// Creates a new [DPAProcessStepProperties].
  const DPAProcessStepProperties({
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
    this.jumioConfig,
    this.delay,
    this.block = DPAScreenBlock.none,
    this.hideAppBar = false,
    this.skipLabel,
    this.skipButton = false,
    this.skipButtonLabel,
    this.autoFinishIn,
    this.allowCancel = true,
    this.isBackAllowed = true,
    this.textAlignment = TextAlignment.center,
    this.cancelButtonAction = CancelButtonAction.goBack,
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
        jumioConfig,
        delay,
        block,
        hideAppBar,
        skipLabel,
        skipButton,
        skipButtonLabel,
        autoFinishIn,
        allowCancel,
        isBackAllowed
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
    DPAJumioConfig? jumioConfig,
    int? delay,
    DPAScreenBlock? block,
    bool? hideAppBar,
    String? skipLabel,
    bool? skipButton,
    String? skipButtonLabel,
    int? autoFinishIn,
    bool? allowCancel,
    bool? isBackAllowed,
    TextAlignment? textAlignment,
    CancelButtonAction? cancelButtonAction,
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
        jumioConfig: jumioConfig ?? this.jumioConfig,
        delay: delay ?? this.delay,
        block: block ?? this.block,
        hideAppBar: hideAppBar ?? this.hideAppBar,
        skipLabel: skipLabel ?? this.skipLabel,
        skipButton: skipButton ?? this.skipButton,
        skipButtonLabel: skipButtonLabel ?? this.skipButtonLabel,
        autoFinishIn: autoFinishIn ?? this.autoFinishIn,
        allowCancel: allowCancel ?? this.allowCancel,
        isBackAllowed: isBackAllowed ?? this.isBackAllowed,
        textAlignment: textAlignment ?? this.textAlignment,
        cancelButtonAction: cancelButtonAction ?? this.cancelButtonAction,
      );
}

/// TODO: this sdk config only works for jumio for the moment. If a new sdk
/// was needed on the future, we would need to refactor this.
/// Holds the SDK configuration for a DPA step.
class DPAJumioConfig extends Equatable {
  /// The authorization token.
  final String? authorizationToken;

  /// The data center to connect to.
  final String? dataCenter;

  /// Creates a new [DPAJumioConfig].
  const DPAJumioConfig({
    this.authorizationToken,
    this.dataCenter,
  });

  /// Creates a new [DPAJumioConfig] using another as a base.
  DPAJumioConfig copyWith({
    String? authorizationToken,
    String? dataCenter,
  }) =>
      DPAJumioConfig(
        authorizationToken: authorizationToken ?? this.authorizationToken,
        dataCenter: dataCenter ?? this.dataCenter,
      );

  @override
  List<Object?> get props => [
        authorizationToken,
        dataCenter,
      ];
}

/// The type of screen to show for this step.
enum DPAScreenType {
  /// OTP
  otp,

  /// Second factor
  secondFactor,

  /// PIN
  pin,

  /// Task for validating the email entered by the user.
  email,

  /// Other
  other,

  /// Entity search
  entitySearch,

  /// Two columns
  twoColumns,

  /// Task that should be fullscreen and that can only be finished by pressing
  /// a link sent to the email
  waitingEmail,
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

/// All available DPA screen blocks
enum DPAScreenBlock {
  /// No screen should be blocked.
  none,

  /// Email screen should be blocked.
  email,
}

/// Enum that defines the text alignment of a DPA variable
enum TextAlignment {
  /// The text should be centered.
  center,

  /// The text should be aligned to the left.
  left,
}

/// Enum that defines the cancel button action of the dpa popup
enum CancelButtonAction {
  /// When clicked, the cancel icon should cancel the whole flow
  cancel,

  /// When clicked, the cancel icon should go back to the previous screen/task
  goBack;
}
