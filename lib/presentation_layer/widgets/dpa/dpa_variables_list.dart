import 'package:collection/collection.dart';
import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';
import '../../widgets.dart';
import 'date_picker/dpa_date_picker.dart';
import 'radio_button/dpa_radio_button.dart';

/// Signature for [DPAVariablesList.builder].
///
/// This callback allows for customization of the variable widgets. It passes
/// the current [BuildContext], the [DPAVariable] and if the variable should
/// be read-only.
///
/// The return should be a widget that deals with the variable, or null --
/// in which case a default LDK widget will be used to deal with the variable.
///
/// This is important as you can customize only one widget based on the variable
/// passed, and not other. For instance, you can return a custom widget only
/// if the variable is of type boolean, and let the other variables use the
/// default LDK widgets.
typedef DPAVariableBuilder = Widget? Function(
  BuildContext context,
  DPAVariable variable,
  bool readonly,
  DPAVariable? previousVariable,
  DPAVariable? nextVariable,
);

/// Displays all the variables for a step in a DPA process.
class DPAVariablesList extends StatelessWidget {
  /// The process to display the variables.
  ///
  /// Received because it can be the current process or a pop-up process or
  /// something else entirely.
  final DPAProcess process;

  /// A custom widget builder for the DPA variables. If not passed, the default
  /// LDK widgets will be used.
  final DPAVariableBuilder? builder;

  /// The alignment to be used for the variables on the resulting column.
  ///
  /// Defaults to [CrossAxisAlignment.start].
  final CrossAxisAlignment crossAxisAlignment;

  /// This property can be set to `true` when debugging the builders. It
  /// lists the variables received and its most important properties.
  ///
  /// Defaults to `false`.
  final bool debugLog;

  /// The custom empty search builder that will show when a search field
  /// input returned no results.
  ///
  /// If not indicated, a default one will show showing the translation
  /// assigned to the key `no_results_found`.
  final WidgetBuilder? customEmptySearchBuilder;

  /// Creates a new [DPAVariablesList].
  const DPAVariablesList({
    Key? key,
    required this.process,
    this.builder,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.debugLog = false,
    this.customEmptySearchBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CubitActionBuilder<DPAProcessCubit, DPAProcessBusyAction>(
        actions: DPAProcessBusyAction.values.toSet(),
        builder: (context, loadingActions) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment,
            children: process.variables.mapIndexed(
              (index, variable) {
                if (debugLog) _debugLog(variable);

                final previousVariable =
                    (index > 0 && index < process.variables.length)
                        ? process.variables[index - 1]
                        : null;

                final nextVariable =
                    (index >= 0 && index < process.variables.length - 1)
                        ? process.variables[index + 1]
                        : null;

                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: builder?.call(
                        context,
                        variable,
                        loadingActions.isNotEmpty,
                        previousVariable,
                        nextVariable,
                      ) ??
                      _defaultVariableBuilder(
                        context,
                        variable,
                        loadingActions.isNotEmpty,
                        previousVariable,
                        nextVariable,
                      ),
                );
              },
            ).toList(growable: false),
          );
        });
  }

  Widget _defaultVariableBuilder(
    BuildContext context,
    DPAVariable variable,
    bool busy,
    DPAVariable? previousVariable,
    DPAVariable? nextVariable,
  ) {
    // TODO: add all remaining Layer Design Kit widgets when they're available.
    switch (variable.type) {
      case DPAVariableType.image:
        return DPAFileUpload(
          key: ValueKey(variable.id),
          variable: variable,
          readonly: variable.constraints.readonly,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
          ),
          shouldAppendAdd: false,
        );

      case DPAVariableType.text:
      case DPAVariableType.number:
        if (variable.property.dialCodes.isNotEmpty) {
          return DPAPhoneText(
            key: ValueKey(variable.id),
            variable: variable,
            readonly: variable.constraints.readonly,
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
            ),
          );
        }
        return DPAText(
          key: ValueKey(variable.id),
          variable: variable,
          readonly: variable.constraints.readonly,
          padding: EdgeInsets.symmetric(
            vertical: variable.constraints.readonly ? 12.0 : 0,
          ),
          scrollPadding: const EdgeInsets.only(bottom: 62.0),
        );

      case DPAVariableType.radioButton:
        return DPARadioButton(
          key: ValueKey(variable.id),
          variable: variable,
          readonly: variable.constraints.readonly,
        );
      case DPAVariableType.dropdown:
        final isMultipicker = variable.property.multipleValues;
        final hasSearchBar = variable.property.searchBar;

        if (hasSearchBar) {
          return DPASearchList(
            key: ValueKey(variable.id),
            variable: variable,
            filter: (item, query) =>
                item.id.toLowerCase().contains(query.toLowerCase()) ||
                item.name.toLowerCase().contains(query.toLowerCase()),
            customEmptySearchBuilder: customEmptySearchBuilder,
          );
        }

        return DPADropdown(
          key: ValueKey(variable.id),
          isMultipicker: isMultipicker,
          showDropdownIndicator: false,
          onChanged: (value) => context.read<DPAProcessCubit>().updateValue(
                variable: variable,
                newValue: value.toList(),
              ),
          onClear: () => context.read<DPAProcessCubit>().updateValue(
                variable: variable,
                newValue: null,
              ),
          variable: variable,
          readonly: variable.constraints.readonly,
        );

      case DPAVariableType.dateTime:
        return DPADatePicker(
          key: ValueKey(variable.id),
          variable: variable,
        );

      default:
        Logger('DPAVariablesList').severe(
          'Could not create widget for ${variable.type}',
        );

        final layerDesign = DesignSystem.of(context);

        return Text(
          'ERROR: Missing widget for ${variable.type}',
          style: layerDesign.titleM(
            color: layerDesign.errorPrimary,
          ),
        );
    }
  }

  void _debugLog(DPAVariable v) {
    final log = Logger('DPAVariablesList');

    log.info('Variable id: ${v.id} - Type: (${v.type})');
    log.info('   Label: ${v.label}');
    log.info('   Value: ${v.value}');
    log.info(
      '   Required: ${v.constraints.required}'
      ' - Read-Only: ${v.constraints.readonly}'
      ' - Range: ${v.constraints.minValue}/${v.constraints.maxValue}'
      ' - Length: ${v.constraints.minLength}/${v.constraints.maxLength}',
    );
    log.info('   Available Values: ${v.availableValues}');
    log.info('   Properties: ${v.property}');
  }
}
