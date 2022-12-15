import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  /// The style of the system overlays, like the status bar.
  final SystemUiOverlayStyle uiOverlayStyle;

  /// Creates a new [LayerPageBuilder]
  const LayerPageBuilder({
    Key? key,
    required this.page,
    required this.containerBuilder,
    this.extraCardBuilder,
    this.extraCards = const [],
    this.uiOverlayStyle = SystemUiOverlayStyle.light,
  })  : assert(extraCards.length == 0 || extraCardBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter extra containers based on their visibility and their associated
    // page. The page order starts from 1, so we have to subtract 1 to get the
    // index.
    final filteredExtraCards = extraCards
        .where((extraContainer) => extraContainer.visible(page))
        .toList();

    // Filter the top extra containers
    final topExtraCards = filteredExtraCards
        .where((extraContainer) =>
            extraContainer.position == ExtraCardPosition.top)
        .toList();

    // Filter the bottom extra containers
    final bottomExtraCards = filteredExtraCards
        .where((extraContainer) =>
            extraContainer.position == ExtraCardPosition.bottom)
        .toList();

    return AnnotatedRegion(
      value: uiOverlayStyle,
      child: CustomScrollView(
        slivers: [
          ...topExtraCards
              .map(
                (e) => e.isSliver
                    ? extraCardBuilder!(context, e)
                    : SliverToBoxAdapter(
                        child: extraCardBuilder!(context, e),
                      ),
              )
              .toList(growable: false),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => containerBuilder(
                context,
                page.containers[index],
              ),
              childCount: page.containers.length,
            ),
          ),
          ...bottomExtraCards
              .map(
                (e) => e.isSliver
                    ? extraCardBuilder!(context, e)
                    : SliverToBoxAdapter(
                        child: extraCardBuilder!(context, e),
                      ),
              )
              .toList(growable: false),
          SliverToBoxAdapter(
            child: const SizedBox(height: 76),
          ),
        ],
      ),
    );
  }
}
