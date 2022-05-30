import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///Widget for similar to a [PageView] but without margins
class MarginlessPageView extends StatefulWidget {
  /// The [AxisDirection] of the page view
  /// default is [AxisDirection.down]
  final AxisDirection axisDirection;

  ///The children for populating the page view
  final List<Widget> children;

  ///Padding for each child
  final EdgeInsets padding;

  ///Whether to allow implicit scrolling or not
  final bool allowImplicitScrolling;

  ///The [ScrillPhysics] for the page view
  final ScrollPhysics? physics;

  ///Whether the page should snap or not
  final bool pageSnapping;

  ///The [PageController] for the page view
  final PageController controller;

  ///Whether the [MarginlessPageView] should have margin or not
  final bool showViewportMargin;

  ///Function to call when the page is changed
  final ValueChanged<int>? onPageChanged;

  ///Creates a [MarginlessPageView] widget
  const MarginlessPageView({
    this.axisDirection = AxisDirection.down,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.allowImplicitScrolling = false,
    this.physics,
    this.pageSnapping = true,
    required this.controller,
    this.showViewportMargin = false,
    this.onPageChanged,
  });

  @override
  _MarginlessPageViewState createState() => _MarginlessPageViewState();
}

class _MarginlessPageViewState extends State<MarginlessPageView> {
  Widget _buildChild(Widget child) =>
      Padding(padding: widget.padding, child: child);

  int _lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
    _lastReportedPage = widget.controller.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollPhysics _scrollPhysics = _ForceImplicitScrollPhysics(
      allowImplicitScrolling: widget.allowImplicitScrolling,
    ).applyTo(widget.pageSnapping
        ? _kPagePhysics.applyTo(widget.physics)
        : widget.physics);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth == 0 &&
            widget.onPageChanged != null &&
            notification is ScrollUpdateNotification) {
          int? currentPage;
          // Check if the last child
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent) {
            currentPage = widget.children.length - 1;
          } else {
            final metrics = notification.metrics as PageMetrics;
            if (metrics.page != null) {
              currentPage = metrics.page!.round();
            }
          }
          if (currentPage != null && currentPage != _lastReportedPage) {
            _lastReportedPage = currentPage;
            widget.onPageChanged?.call(currentPage);
          }
        }
        return false;
      },
      child: Scrollable(
        axisDirection: widget.axisDirection,
        physics: _scrollPhysics,
        controller: widget.controller,
        viewportBuilder: (context, position) => Viewport(
          cacheExtent: widget.allowImplicitScrolling ? 1.0 : 0.0,
          cacheExtentStyle: CacheExtentStyle.viewport,
          axisDirection: widget.axisDirection,
          offset: position,
          slivers: <Widget>[
            SliverFillViewport(
              viewportFraction: widget.controller.viewportFraction,
              delegate: SliverChildListDelegate(
                widget.children.map(_buildChild).toList(),
              ),
              padEnds: widget.showViewportMargin,
            ),
          ],
        ),
      ),
    );
  }
}

const PageScrollPhysics _kPagePhysics = PageScrollPhysics();

class _ForceImplicitScrollPhysics extends ScrollPhysics {
  const _ForceImplicitScrollPhysics({
    required this.allowImplicitScrolling,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  _ForceImplicitScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _ForceImplicitScrollPhysics(
      allowImplicitScrolling: allowImplicitScrolling,
      parent: buildParent(ancestor),
    );
  }

  @override
  final bool allowImplicitScrolling;
}
