import 'package:collection/collection.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../mixins.dart';
import '../../resources.dart';

/// A [DKPhoneField] that allows the user to pick a contact from its device.
class ContactPhoneField extends StatelessWidget with ContactPickerMixin {
  /// The label for the field.
  final String? label;

  /// The set of countries for the picker.
  final UnmodifiableSetView<DKPickerItem<String>> countries;

  /// The text field status.
  /// Default is [DKTextFieldStatus.idle].
  final DKTextFieldStatus status;

  /// The controller for the phone field.
  final TextEditingController? phoneController;

  /// The picker controller for the country code.
  final DKPickerController<String>? countryCodePickerController;

  /// Callback called when the phone field changes.
  final ValueChanged<String> onChanged;

  /// Callback called when the country code is set.
  final ValueSetter<String> onCountryCodeChanged;

  /// The warning message for the field.
  final String? warning;

  /// The title for when the selector view gets opened as a bottom sheet.
  final String bottomSheetPickerTitle;

  /// Callback called when a contact is picked from the contact picker screen.
  final ValueSetter<Contact> onContactPicked;

  /// Creates a new [ContactPhoneField].
  ContactPhoneField({
    Key? key,
    this.label,
    required Set<DKPickerItem<String>> countries,
    this.status = DKTextFieldStatus.idle,
    this.phoneController,
    this.countryCodePickerController,
    required this.onChanged,
    required this.onCountryCodeChanged,
    this.warning,
    this.bottomSheetPickerTitle = '',
    required this.onContactPicked,
  })  : countries = UnmodifiableSetView(countries),
        super(key: key);

  @override
  Widget build(BuildContext context) => DKPhoneField(
        label: label,
        status: status,
        countries: countries,
        bottomSheetPickerTitle: bottomSheetPickerTitle,
        controller: phoneController,
        pickerController: countryCodePickerController,
        onChanged: onChanged,
        onCountryCodeChanged: onCountryCodeChanged,
        warning: warning,
        suffixWidget: DKButton.icon(
          type: DKButtonType.brandPlain,
          iconPath: FLImages.contacts,
          onPressed: () async {
            final contact = await openContactPickerScreen(context);
            if (contact != null) {
              onContactPicked(contact);
            }
          },
        ),
      );
}
