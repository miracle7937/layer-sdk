import 'package:flutter/material.dart';
import '../../../domain_layer/models.dart';
import '../../widgets.dart';

/// The widget gets a context and experience container as a parameter
typedef ContainerBuilder = Widget Function(BuildContext, ExperienceContainer);

/// The widget gets a context and extra container as a parameter
typedef ExtraCardBuilder = Widget Function(BuildContext, ExtraCard);

/// The Layer Page Builder
class LayerPageBuilder extends StatelessWidget {
  /// A page configured in the Experience Studio.
  final ExperiencePage page;

  /// The container builder for the cards
  final ContainerBuilder containerBuilder;

  /// The extra card builder in addition the other cards
  final ExtraCardBuilder? extraCardBuilder;

  /// The extra container list to put the page with position
  final List<ExtraCard> extraCards;

  /// Creates a new [LayerPageBuilder]
  const LayerPageBuilder({
    Key? key,
    required this.page,
    required this.containerBuilder,
    this.extraCardBuilder,
    this.extraCards = const [],
  })  : assert(extraCards.length == 0 || extraCardBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter extra containers based on their visibility and their associated
    // page. The page order starts from 1, so we have to subtract 1 to get the
    // index.
    final filteredExtraCards = extraCards
        .where((extraContainer) =>
            extraContainer.visible &&
            extraContainer.pageIndex == (page.order - 1))
        .toList();

    // Filter the top extra containers
    final topExtraCards = filteredExtraCards
        .where((extraContainer) =>
            extraContainer.position == ExtraCardPosition.top)
        .toList();

    // Filter the center extra containers
    final centerExtraCards = filteredExtraCards
        .where((extraContainer) =>
            extraContainer.position == ExtraCardPosition.center)
        .toList();

    // Filter the bottom extra containers
    final bottomExtraCards = filteredExtraCards
        .where((extraContainer) =>
            extraContainer.position == ExtraCardPosition.bottom)
        .toList();

    // Get the middle upper index
    final middle = (page.containers.length / 2).ceil();

    // Build the items list
    final items = [
      ...topExtraCards,
      if (centerExtraCards.isEmpty) ...page.containers,
      if (centerExtraCards.isNotEmpty && page.containers.isNotEmpty) ...[
        ...page.containers.sublist(0, middle),
        ...centerExtraCards,
        ...page.containers.sublist(middle, page.containers.length),
      ],
      if (centerExtraCards.isNotEmpty && page.containers.isEmpty)
        ...centerExtraCards,
      ...bottomExtraCards,
    ];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is ExperienceContainer) {
          return containerBuilder(context, item);
        } else {
          return extraCardBuilder!(context, item as ExtraCard);
        }
      },
    );
  }
}
