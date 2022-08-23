import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../features/dpa.dart';
import '../../../utils.dart';

/// The filter function.
///
/// Receives a [DPAValue] and a [String] query parameter.
typedef DPAValueFilter = bool Function(DPAValue, String);

/// A widget that displays all available options of a [DPAVariable] with a
/// search bar.
class DPASearchList extends StatefulWidget {
  /// The [DPAVariable] that is going to be used.
  final DPAVariable variable;

  /// The [DPAValueFilter] callback.
  final DPAValueFilter filter;

  /// The custom empty search builder that will show when a search field
  /// input returned no results.
  ///
  /// If not indicated, a default one will show showing the translation
  /// assigned to the key `no_results_found`.
  final WidgetBuilder? customEmptySearchBuilder;

  /// Creates a new [DPASearchList] instance.
  const DPASearchList({
    Key? key,
    required this.variable,
    required this.filter,
    this.customEmptySearchBuilder,
  }) : super(key: key);

  @override
  State<DPASearchList> createState() => _DPASearchListState();
}

class _DPASearchListState extends State<DPASearchList> {
  late List<DPAValue> options;

  @override
  void initState() {
    super.initState();
    options = widget.variable.availableValues;
  }

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);
    final layerDesign = DesignSystem.of(context);

    final isCountryPicker =
        widget.variable.property.type == DPAVariablePropertyType.countryPicker;
    final isCurrencyPicker =
        widget.variable.property.picker == DPAVariablePicker.currency;

    return Column(
      children: [
        const SizedBox(height: 16.0),
        DKSearchField(
          onChanged: (query) => _onSearchQueryChanged(
            query: query,
          ),
          hint: translation.translate('search'),
        ),
        const SizedBox(height: 16.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: options.isEmpty
              ? _buildEmptySearchView(
                  context,
                  layerDesign,
                )
              : ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final value = options[index];
                    var flagSvg;
                    if (isCountryPicker) {
                      flagSvg = DKFlags.path(countryCode: value.id);
                    }

                    if (isCurrencyPicker) {
                      flagSvg = DKFlags.path(
                          countryCode:
                              currencyToCountryCode(value.id.toLowerCase())
                                  .toUpperCase());
                    }
                    return _DPASearchListItem(
                      svgPath: flagSvg,
                      dpaValue: options[index],
                      onSelected: (value) async {
                        final cubit = context.read<DPAProcessCubit>();
                        await cubit.updateValue(
                          variable: widget.variable,
                          newValue: value,
                        );
                        cubit.stepOrFinish();
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// The empty search view builder.
  Widget _buildEmptySearchView(
    BuildContext context,
    LayerDesign layerDesign,
  ) =>
      Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: widget.customEmptySearchBuilder != null
            ? widget.customEmptySearchBuilder!(context)
            : Text(
                Translation.of(context).translate('no_results_found'),
                style: layerDesign.titleL(),
                textAlign: TextAlign.center,
              ),
      );

  List<DPAValue> _filter({
    required List<DPAValue> items,
    required String query,
  }) {
    if (query.isEmpty) {
      return items;
    }

    return items.where((item) => widget.filter(item, query)).toList();
  }

  void _onSearchQueryChanged({
    required String query,
  }) {
    setState(() {
      options = _filter(
        items: widget.variable.availableValues,
        query: query,
      );
    });
  }
}

/// The widget for displaying an item from the search list.
class _DPASearchListItem extends StatelessWidget {
  /// The optional svg path.
  final String? svgPath;

  /// The dpa value.
  final DPAValue dpaValue;

  /// Callback called when selected.
  final ValueChanged<String> onSelected;

  /// Creates a new [_DPASearchListItem].
  const _DPASearchListItem({
    Key? key,
    this.svgPath,
    required this.dpaValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    return InkWell(
      onTap: () => onSelected(dpaValue.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            if (svgPath != null) ...[
              SizedBox(
                height: 24.0,
                width: 24.0,
                child: SvgPicture.asset(
                  svgPath!,
                ),
              ),
              const SizedBox(width: 12.0),
            ],
            Expanded(
              child: Text(
                dpaValue.name,
                style: design.bodyM(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
