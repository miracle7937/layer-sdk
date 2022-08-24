import 'package:country_pickers/country_pickers.dart';
import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:validators/validators.dart';

import '../../../../domain_layer/models.dart';
import '../../../extensions.dart';
import '../../../utils/translation.dart';
import '../../../widgets.dart';

/// The available dropdown types.
enum DPADropdownType {
  /// Bottom sheet picker.
  bottomSheet,

  /// Overlay picker.
  overlay,
}

extension _DKPickerTypeMapping on DPADropdownType {
  DKPickerType toPickerType() => this == DPADropdownType.bottomSheet
      ? DKPickerType.bottomSheet
      : DKPickerType.overlay;
}

/// A DPA widget that shows a dropdown.
class DPADropdown extends StatefulWidget {
  /// The DPA variable that controls this widget.
  final DPAVariable variable;

  /// If the values can be changed.
  final bool readonly;

  /// The callback called when the picker changes.
  final ValueSetter<Set<String>> onChanged;

  /// A custom padding to use.
  ///
  /// Default is [EdgeInsets.zero].
  final EdgeInsets padding;

  /// The custom image builder for the items.
  final Widget Function(String)? customImageBuilder;

  /// The dropdown type.
  ///
  /// Default is [DPADropdownType.bottomSheet].
  final DPADropdownType dropdownType;

  /// A custom authorization token to be used when retrieving images from
  /// the server.
  final String? customToken;

  /// Callback for clearing the current selected item.
  final VoidCallback? onClear;

  /// Optional param to show the dropdown icon
  ///
  /// Defaults to `true`.
  final bool showDropdownIndicator;

  /// Whether the picker allows picking multiple items or not.
  /// Default is false.
  final bool isMultipicker;

  /// The title for the buttton for submiting the multiselection.
  final String? selectionButtonTitle;

  /// Creates a new [DPADropdown].
  const DPADropdown({
    Key? key,
    required this.variable,
    this.readonly = false,
    required this.onChanged,
    this.padding = EdgeInsets.zero,
    this.customImageBuilder,
    this.dropdownType = DPADropdownType.bottomSheet,
    this.customToken,
    this.onClear,
    this.selectionButtonTitle,
    this.showDropdownIndicator = true,
    this.isMultipicker = false,
  })  : assert(
          !isMultipicker || (isMultipicker && selectionButtonTitle != null),
          'selectionButtonTitle is required when isMultipicker is on',
        ),
        super(key: key);

  @override
  State<DPADropdown> createState() => _DPADropdownState();
}

class _DPADropdownState extends State<DPADropdown> {
  late List<DKPickerItem<String>> items;

  bool get isCountryPicker =>
      widget.variable.property.type == DPAVariablePropertyType.countryPicker;
  bool get isCurrencyPicker =>
      widget.variable.property.picker == DPAVariablePicker.currency;
  @override
  void initState() {
    items = widget.variable.availableValues
        .map(
          (e) => DKPickerItem<String>(
            title: e.name,
            value: e.id,
            iconPath: isCurrencyPicker
                ? DKFlags.currencyFlag(currency: e.id)
                : e.imageUrl ?? e.icon,
          ),
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);
    final required = widget.variable.constraints.required;
    final value = widget.variable.value;

    final List<String> values;
    if (value is String) {
      values = value.contains('|') ? value.split('|') : [value];
    } else {
      values = value is List<String> ? value : [];
    }

    return Padding(
      padding: widget.padding,
      child: DKTextFieldPicker<String>(
        label: widget.variable.label,
        items: items.toSet(),
        status: widget.readonly
            ? DKTextFieldStatus.disabled
            : DKTextFieldStatus.idle,
        onChanged: widget.onChanged,
        builder: _selectedItemBuilder,
        warning: widget.variable.translateValidationError(translation),
        bottomSheetPickerTitle: widget.variable.label ?? '',
        pickerType: widget.dropdownType.toPickerType(),
        initialItems: isCurrencyPicker
            ? {items.first}
            : items.where((e) => values.contains(e.value)).toSet(),
        isMultipicker: widget.isMultipicker,
        selectionButtonTitle: widget.selectionButtonTitle,
        customIconBuilder: (_, item) => _buildImage(item),
        onClear: required ? null : widget.onClear,
        onClearItem: required
            ? null
            : DKPickerItem(
                title: '—',
                value: '—',
              ),
      ),
    );
  }

  /// The builder for the selected item.
  Widget _selectedItemBuilder(
    BuildContext context,
    Set<DKPickerItem<String>> items,
  ) {
    final layerDesign = DesignSystem.of(context);

    return Row(
      children: [
        if (items.length == 1 && items.single.iconPath != null) ...[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 24.0,
              maxWidth: 24.0,
            ),
            child: _buildImage(items.single),
          ),
          const SizedBox(width: 8.0),
        ],
        Expanded(
          child: Text(
            items.length == 1
                ? items.single.title
                : items
                    .map((e) => e.title)
                    .toList()
                    .joinWithDots(separator: ', '),
            style: layerDesign.bodyM(),
          ),
        ),
        const SizedBox(width: 8.0),
        if (!isCurrencyPicker && widget.showDropdownIndicator)
          DKButton.icon(
            type: DKButtonType.basePlain,
            iconPath: DKImages.dropdown,
            padding: EdgeInsets.zero,
            onPressed: () {},
          ),
      ],
    );
  }

  /// Builds the image from the dpa value.
  Widget _buildImage(
    DKPickerItem item,
  ) {
    if (isCountryPicker || isCurrencyPicker) {
      try {
        final country = CountryPickerUtils.getCountryByIsoCode(item.value);

        return CountryPickerUtils.getDefaultFlagImage(
          country,
        );
      } on Exception {
        return _ImageFallback(
          currencyId: item.value,
        );
      }
    }

    return widget.customImageBuilder != null
        ? widget.customImageBuilder!(item.iconPath!)
        : isURL(item.iconPath)
            ? NetworkImageContainer(
                imageURL: item.iconPath!,
                customToken: widget.customToken,
                errorWidget: SizedBox.shrink(),
                placeholder: SizedBox.shrink(),
              )
            : SizedBox.shrink();
  }
}

class _ImageFallback extends StatelessWidget {
  final String currencyId;

  const _ImageFallback({
    Key? key,
    required this.currencyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      DKFlags.currencyFlag(currency: currencyId),
      width: 24.0,
      height: 24.0,
    );
  }
}
