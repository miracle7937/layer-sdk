import 'dart:convert';

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

  /// An optional SDK configuration.
  final DPASDKConfigDTO? sdkConfig;

  /// Block // TODO: see what this is.
  final String? block;

  /// An email address
  final String? email;

  /// The path to the background image.
  final String? bgImagePath;

  /// The delay interval
  final int? delay;

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
    this.sdkConfig,
    this.block,
    this.email,
    this.bgImagePath,
    this.delay,
  });

  /// Creates a new [DPAProcessStepPropertiesDTO] from a JSON.
  factory DPAProcessStepPropertiesDTO.fromJson(Map<String, dynamic> json) =>
      DPAProcessStepPropertiesDTO(
        image: json['image'],
        feedback: json['feedback'],
        step: json['step'],
        hasButtons: true,
        buttonLabel: json['button_next'] ?? json['button'],
        cancelButtonLabel: json['button_cancel'],
        isBackAllowed: json['isBackAllowed'] ?? false,
        showSaveButton: json['save_button'] ?? false,
        type: json['type'] != null
            ? DPAPropertyTypeDTO.fromRaw(json['type'])
            : null,
        screenType: json['screen'] == null && json['screen_type'] == null
            ? null
            : DPAScreenTypeDTO(json['screen'] ?? json['screen_type']),
        maskedNumber: json['masked_number'],
        sdkConfig: DPASDKConfigDTO.fromJson(json),
        block: json['block'],
        email: json['email'],
        bgImagePath: json['image_bg'],
        delay: json['delay'],
      );
}

/// Holds the SDK configuration for a DPA step.
class DPASDKConfigDTO {
  /// The sdk package.
  final DPASDKPackageDTO? sdk;

  /// The API token
  final String? apiToken;

  /// The API secret
  final String? apiSecret;

  /// The data center to connect to
  final String? dataCenter;

  /// The SDK type.
  final DPASDKTypeDTO? type;

  /// Extra options.
  final Map<String, dynamic>? options;

  /// Creates a new [DPASDKConfigDTO].
  DPASDKConfigDTO({
    this.sdk,
    this.apiToken,
    this.apiSecret,
    this.dataCenter,
    this.type,
    this.options,
  });

  /// Creates a new [DPASDKConfigDTO] from a JSON.
  factory DPASDKConfigDTO.fromJson(Map<String, dynamic> json) =>
      DPASDKConfigDTO(
        sdk: DPASDKPackageDTO.fromRaw(json['sdk']),
        apiToken: json['api_token'],
        apiSecret: json['api_secret'],
        dataCenter: json['data_center'],
        type: DPASDKTypeDTO.fromRaw(json['type']),
        options: json['conf'] == null ? null : jsonDecode(json['conf']),
      );
}

/// The SDK package.
class DPASDKPackageDTO extends EnumDTO {
  /// Jumio package.
  static const jumio = DPASDKPackageDTO._internal('jumio');

  /// The available values.
  static const List<DPASDKPackageDTO> values = [
    jumio,
  ];

  const DPASDKPackageDTO._internal(String value) : super.internal(value);

  /// Creates a new [DPASDKPackageDTO] from a `String` value.
  static DPASDKPackageDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );

  @override
  String toString() => 'DPASDKPackage{$value}';
}

/// The SDK type.
class DPASDKTypeDTO extends EnumDTO {
  /// Netverify
  static const netverify = DPASDKTypeDTO._internal('NetVerify');

  /// Document verification
  static const documentVerification =
      DPASDKTypeDTO._internal('DocumentVerification');

  /// Authentication
  static const authentication = DPASDKTypeDTO._internal('Authentication');

  /// The available values.
  static const List<DPASDKTypeDTO> values = [
    netverify,
    documentVerification,
    authentication,
  ];

  const DPASDKTypeDTO._internal(String value) : super.internal(value);

  /// Creates a new [DPASDKTypeDTO] from a `String` value.
  static DPASDKTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );

  @override
  String toString() => 'DPASDKType{$value}';
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

  /// E-mail
  static const email = DPAScreenTypeDTO._internal('email');

  /// Entity search
  static const entitySearch = DPAScreenTypeDTO._internal('entity_search');

  /// Two columns
  static const twoColumns = DPAScreenTypeDTO._internal('two_column');

  /// The available values.
  static const List<DPAScreenTypeDTO> values = [
    otp,
    pin,
    email,
    entitySearch,
    twoColumns,
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
