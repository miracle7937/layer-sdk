import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  /// Creates a new [DPASearchList] instance.
  const DPASearchList({
    Key? key,
    required this.variable,
    required this.filter,
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
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (_, __) => Divider(),
          itemCount: options.length,
          itemBuilder: (context, index) => _DPASearchListItem(
            dpaValue: options[index],
            onSelected: (value) async {
              final cubit = context.read<DPAProcessCubit>();
              await cubit.updateValue(
                variable: widget.variable,
                newValue: value,
              );
              cubit.stepOrFinish();
            },
          ),
        ),
      ],
    );
  }

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

class _DPASearchListItem extends StatelessWidget {
  final DPAValue dpaValue;
  final ValueChanged<String> onSelected;

  const _DPASearchListItem({
    Key? key,
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
        child: Text(
          dpaValue.name,
          style: design.bodyM(),
        ),
      ),
    );
  }
}
