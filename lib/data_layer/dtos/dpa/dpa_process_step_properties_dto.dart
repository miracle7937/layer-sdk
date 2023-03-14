import 'package:collection/collection.dart';

import '../../helpers.dart';

/// Holds the properties for a single DPA process.
class DPAProcessStepPropertiesDTO {
  /// Image URL.
  final String? image;

  /// Feedback from the server.
  final String? feedback;

  /// The current step.
  final String? step;

  /// `true` if it should show the buttons.
  final bool? hasButtons;

  /// The label of the confirmation button, for instance, "Continue".
  final String? buttonLabel;

  /// The label of the cancellation button.
  final String? cancelButtonLabel;

  /// If the user can go back to a previous step.
  final bool? isBackAllowed;

  /// If the save button should be displayed.
  final bool? showSaveButton;

  /// The type of the property for this step.
  final DPAPropertyTypeDTO? type;

  /// The type of the screen for this step.
  final DPAScreenTypeDTO? screenType;

  /// The number mask.
  final String? maskedNumber;

  /// An optional jumio configuration.
  final DPAJumioConfigDTO? jumioConfig;

  /// Defines the screen type that should be blocked (Automatically finished)
  final DPAScreenBlockDTO? block;

  /// An email address
  final String? email;

  /// The path to the background image.
  final String? bgImagePath;

  /// The delay interval
  final int? delay;

  /// The screen alignment.
  final DPAScreenAlignmentDTO? alignment;

  /// Whether or not the DPAHeader should be hidden.
  final bool? hideAppBar;

  /// The label for the skip button.
  final String? skipLabel;

  /// The value for the cancel button.
  final bool? skipButton;

  /// The label for the cancel button.
  final String? skipButtonLabel;

  /// The amount of seconds to wait before the task is auto finished.
  final int? autoFinishIn;

  /// If the current process can be cancelled
  final bool? allowCancel;

  /// The text alignment.
  final TextAlignmentDTO? textAlignment;

  /// Creates a new [DPAProcessStepPropertiesDTO].
  DPAProcessStepPropertiesDTO({
    this.image,
    this.feedback,
    this.step,
    this.type,
    this.hasButtons,
    this.buttonLabel,
    this.cancelButtonLabel,
    this.isBackAllowed,
    this.showSaveButton,
    this.screenType,
    this.maskedNumber,
    this.jumioConfig,
    this.block,
    this.email,
    this.bgImagePath,
    this.delay,
    this.alignment,
    this.hideAppBar,
    this.skipLabel,
    this.skipButton,
    this.skipButtonLabel,
    this.autoFinishIn,
    this.allowCancel,
    this.textAlignment,
  });

  /// Creates a new [DPAProcessStepPropertiesDTO] from a JSON.
  factory DPAProcessStepPropertiesDTO.fromJson(Map<String, dynamic> json) =>
      DPAProcessStepPropertiesDTO(
        allowCancel: json['allow_cancel'],
        image: json['image'],
        feedback: json['feedback'],
        step: json['step'],
        hasButtons: true,
        buttonLabel: json['button_next'] ?? json['button'],
        cancelButtonLabel: json['button_cancel'],
        isBackAllowed: json['back_allowed'] ?? true,
        showSaveButton: json['save_button'] ?? false,
        type: json['type'] != null
            ? DPAPropertyTypeDTO.fromRaw(json['type'])
            : null,
        screenType: json['screen'] == null && json['screen_type'] == null
            ? null
            : DPAScreenTypeDTO(json['screen'] ?? json['screen_type']),
        maskedNumber: json['masked_number'],
        jumioConfig:
            json['sdk'] == null ? null : DPAJumioConfigDTO.fromJson(json),
        block: json['block'] == null ? null : DPAScreenBlockDTO(json['block']),
        email: json['email'],
        bgImagePath: json['image_bg'],
        delay: json['delay'],
        alignment: json['alignment'] != null
            ? DPAScreenAlignmentDTO(json['alignment'])
            : null,
        hideAppBar: json['hide_app_bar'],
        skipLabel: json['button_skip'],
        skipButton: json['skip_button'],
        skipButtonLabel: json['skip_label'],
        autoFinishIn: int.tryParse(
          (json['finish_in'] ?? '').toString(),
        ),
        textAlignment: TextAlignmentDTO.fromJson(
          json['text_alignment'] ?? '',
        ),
      );
}

/// TODO: this sdk config only works for jumio for the moment. If a new sdk
/// was needed on the future, we would need to refactor this.
/// Holds the SDK configuration for a DPA step.
class DPAJumioConfigDTO {
  /// The authorization token.
  final String? authorizationToken;

  /// The data center to connect to.
  final String? dataCenter;

  /// Creates a new [DPAJumioConfigDTO].
  DPAJumioConfigDTO({
    this.authorizationToken,
    this.dataCenter,
  });

  /// Creates a new [DPAJumioConfigDTO] from a JSON.
  factory DPAJumioConfigDTO.fromJson(Map<String, dynamic> json) =>
      DPAJumioConfigDTO(
        authorizationToken: json['authorization_token'],
        dataCenter: json['data_center'],
      );
}

/// The type of property for this step.
class DPAPropertyTypeDTO extends EnumDTO {
  /// If this step is a pop-up.
  static const popup = DPAPropertyTypeDTO._internal('popup');

  /// If this step is a display.
  static const display = DPAPropertyTypeDTO._internal('display');

  /// The available values.
  static const List<DPAPropertyTypeDTO> values = [popup, display];

  const DPAPropertyTypeDTO._internal(String value) : super.internal(value);

  /// Creates a new [DPAPropertyTypeDTO] from a `String` value.
  static DPAPropertyTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );

  @override
  String toString() => 'DPAPropertyType{$value}';
}

/// The type of the screen to display for this step.
class DPAScreenTypeDTO extends EnumDTO {
  /// Any other screen
  static const other = DPAScreenTypeDTO._internal('other');

  /// OTP
  static const otp = DPAScreenTypeDTO._internal('otp');

  /// PIN
  static const pin = DPAScreenTypeDTO._internal('pin');

  /// Second factor
  static const secondFactor = DPAScreenTypeDTO._internal('2fa');

  /// Task for validating the email entered by the user.
  static const email = DPAScreenTypeDTO._internal('email');

  /// Entity search
  static const entitySearch = DPAScreenTypeDTO._internal('entity_search');

  /// Two columns
  static const twoColumns = DPAScreenTypeDTO._internal('two_column');

  /// Task that should be fullscreen and that can only be finished by pressing
  /// a link sent to the email
  static const waitingEmail = DPAScreenTypeDTO._internal('waitingEmail');

  /// The available values.
  static const List<DPAScreenTypeDTO> values = [
    otp,
    secondFactor,
    pin,
    email,
    entitySearch,
    twoColumns,
    waitingEmail,
  ];

  const DPAScreenTypeDTO._internal(String value) : super.internal(value);

  /// Creates a new [DPAScreenTypeDTO] from a `String` value.
  factory DPAScreenTypeDTO(String raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => DPAScreenTypeDTO.other,
      );

  @override
  String toString() => 'DPAScreenType{$value}';
}

/// The type of the screen to display for this step.
class DPAScreenAlignmentDTO extends EnumDTO {
  /// Image on top, description below.
  static const imageDescription = DPAScreenAlignmentDTO._internal(
    'image_description',
  );

  /// Description on top, image below.
  static const descriptionImage = DPAScreenAlignmentDTO._internal(
    'description_image',
  );

  /// The available values.
  static const List<DPAScreenAlignmentDTO> values = [
    imageDescription,
    descriptionImage,
  ];

  const DPAScreenAlignmentDTO._internal(String value) : super.internal(value);

  /// Creates a new [DPAScreenAlignmentDTO] from a `String` value.
  factory DPAScreenAlignmentDTO(String raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => DPAScreenAlignmentDTO.imageDescription,
      );

  @override
  String toString() => 'DPAScreenAlignmentDTO{$value}';
}

/// All available DPA blocks.
class DPAScreenBlockDTO extends EnumDTO {
  /// Nothing should be blocked.
  static const none = DPAScreenBlockDTO._internal('');

  /// Email screen should be automatically finished
  static const email = DPAScreenBlockDTO._internal(
    'email',
  );

  /// The available values.
  static const List<DPAScreenBlockDTO> values = [
    none,
    email,
  ];

  const DPAScreenBlockDTO._internal(String value) : super.internal(value);

  /// Creates a new [DPAScreenBlockDTO] from a `String` value.
  factory DPAScreenBlockDTO(String raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => DPAScreenBlockDTO.none,
      );

  @override
  String toString() => 'DPAScreenBlockDTO{$value}';
}

/// Enum that defines the text alignment of a DPA variable
enum TextAlignmentDTO {
  /// The text should be aligned to the left.
  left('left'),

  /// The text should be centered.
  center('center');

  /// The DTO value of this [TextAlignmentDTO].
  final String value;

  /// Default constructor
  const TextAlignmentDTO(this.value);

  /// Gets the enum instance associated with the provided `value`.
  ///
  /// Defaults to `center`
  factory TextAlignmentDTO.fromJson(String value) =>
      TextAlignmentDTO.values.firstWhereOrNull(
        (element) => element.value == value,
      ) ??
      TextAlignmentDTO.center;
}
