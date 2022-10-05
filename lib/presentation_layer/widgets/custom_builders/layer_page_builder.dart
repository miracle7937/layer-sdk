import 'package:flutter/material.dart';
import '../../../domain_layer/models.dart';
import '../../features/home_screen/home_screen.dart';

///
typedef CardBuilder = Widget Function(BuildContext, ExperienceContainer);

///
typedef ExtraCardBuilder = Widget Function(BuildContext, ExtraContainer);

///
class LayerPageBuilder extends StatelessWidget {
  ///
  final ExperiencePage page;

  ///
  final CardBuilder containerBuilder;

  ///
  final ExtraCardBuilder? extraContainerBuilder;

  ///
  final List<ExtraContainer> extraContainers;

  ///
  const LayerPageBuilder({
    Key? key,
    required this.page,
    required this.containerBuilder,
    this.extraContainerBuilder,
    this.extraContainers = const [],
  })  : assert(extraContainers.length == 0 || extraContainerBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter extra containers based on their visibility and their associated
    // page. The page order starts from 1, so we have to subtract 1 to get the
    // index.
    final filteredExtraContainers = extraContainers
        .where((extraContainer) =>
            extraContainer.visible &&
            extraContainer.pageIndex == (page.order - 1))
        .toList();

    // Filter the top extra containers
    final topExtraContainers = filteredExtraContainers
        .where((extraContainer) =>
            extraContainer.position == ExtraContainerPosition.top)
        .toList();

    // Filter the center extra containers
    final centerExtraContainers = filteredExtraContainers
        .where((extraContainer) =>
            extraContainer.position == ExtraContainerPosition.center)
        .toList();

    // Filter the bottom extra containers
    final bottomExtraContainers = filteredExtraContainers
        .where((extraContainer) =>
            extraContainer.position == ExtraContainerPosition.bottom)
        .toList();

    // Get the middle upper index
    final middle = (page.containers.length / 2).ceil();

    // Build the items list
    final items = [
      ...topExtraContainers,
      if (centerExtraContainers.isEmpty) ...page.containers,
      if (centerExtraContainers.isNotEmpty && page.containers.isNotEmpty) ...[
        ...page.containers.sublist(0, middle),
        ...centerExtraContainers,
        ...page.containers.sublist(middle, page.containers.length),
      ],
      if (centerExtraContainers.isNotEmpty && page.containers.isEmpty)
        ...centerExtraContainers,
      ...bottomExtraContainers,
    ];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is ExperienceContainer) {
          return containerBuilder(context, item);
        } else {
          return extraContainerBuilder!(context, item as ExtraContainer);
        }
      },
    );
  }
}
