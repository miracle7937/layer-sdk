import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

/// Widget that displays a list of children in a carousel manner.
class CarouselPageView extends StatefulWidget {
  /// The list of children to be displayed.
  final List<Widget> children;

  /// Callback for when the last children is displayed and the `next` button is
  /// pressed.
  final VoidCallback onFinished;

  /// Callback for when the `skip` button is pressed.
  final VoidCallback onSkip;

  /// Whether or not the carousel should be busy.
  final bool busy;

  /// Creates a new [CarouselPageView] instance.
  CarouselPageView({
    Key? key,
    required this.children,
    required this.onFinished,
    required this.onSkip,
    this.busy = false,
  })  : assert(children.isNotEmpty),
        super(key: key);

  @override
  State<CarouselPageView> createState() => _CarouselPageViewState();
}

class _CarouselPageViewState extends State<CarouselPageView> {
  late PageController _pageController;
  late int _index;

  List<Widget> get children => widget.children;

  @override
  void initState() {
    super.initState();
    _index = 0;
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: PageView.builder(
            controller: _pageController,
            itemCount: children.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (context, index) => children[index],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 56.0),
          alignment: AlignmentDirectional.bottomCenter,
          child: _CarouselIndicatorBar(
            indicatorCount: children.length,
            selectedIndex: _index,
            onNext: _onNext,
            onSkip: widget.onSkip,
            busy: widget.busy,
          ),
        ),
      ],
    );
  }

  void _onNext() {
    final isLast = _index + 1 == children.length;

    if (isLast) {
      widget.onFinished();
      return;
    }

    setState(() {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }
}

class _CarouselIndicatorBar extends StatelessWidget {
  final int indicatorCount;
  final int selectedIndex;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool busy;

  const _CarouselIndicatorBar({
    Key? key,
    required this.indicatorCount,
    required this.selectedIndex,
    required this.onNext,
    required this.onSkip,
    this.busy = false,
  }) : super(key: key);

  bool get isLastSelected => selectedIndex + 1 == indicatorCount;

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);

    return SizedBox(
      height: 60.0,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: DKButton(
              title: translation.translate('skip'),
              onPressed: onSkip,
              type: DKButtonType.basePlain,
              expands: false,
            ),
          ),
          Center(
            child: _CarouselIndicators(
              indicatorCount: indicatorCount,
              selectedIndex: selectedIndex,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DKButton(
              title: translation.translate(
                isLastSelected ? 'get_started' : 'next',
              ),
              onPressed: onNext,
              type: DKButtonType.brandPlain,
              expands: false,
              status: busy ? DKButtonStatus.loading : DKButtonStatus.idle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselIndicators extends StatelessWidget {
  final int indicatorCount;

  final int selectedIndex;

  const _CarouselIndicators({
    Key? key,
    required this.indicatorCount,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        indicatorCount,
        (index) => AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          duration: const Duration(milliseconds: 300),
          height: selectedIndex == index ? 12.0 : 8.0,
          width: selectedIndex == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            color: selectedIndex == index
                ? design.brandPrimary
                : design.baseSenary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
