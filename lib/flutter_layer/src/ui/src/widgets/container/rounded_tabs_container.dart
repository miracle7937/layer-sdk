import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A callback called when the current tab changes.
typedef TabIndexChanged = void Function(double value);

/// Widget that acts as a container with several rounded tabs below
class RoundedTabsContainer extends SingleChildRenderObjectWidget {
  /// The selected index
  final double selectedIndex;

  /// Called when one tab is tapped. Returns the index of the tab.
  final TabIndexChanged? onTabSelected;

  /// Title of the tabs
  final List<String> tabs;

  /// The text style used for the tabs that are not selected
  final TextStyle tabStyle;

  /// The text style used for the tab that is selected
  final TextStyle selectedTabStyle;

  /// Text direction. Defaults to left-to-right.
  final TextDirection textDirection;

  /// The border radius
  final Radius radius;

  /// The size of the tab
  final double tabHeight;

  /// Set this ONLY if the your gradient does not look how you want it
  ///
  /// This sets the total height of the tab, with only the height set on
  /// tabHeight visible to the user, as the rest of the height will be
  /// hidden under the controller
  ///
  /// If this height is bigger than the entire widget, it will be clamped
  final double? forcedTotalTabHeight;

  /// The top color of the linear gradient of the selected tab
  final Color selectedTabTopColor;

  /// The bottom color of the linear gradient of the selected tab
  final Color selectedTabBottomColor;

  /// The top color of the linear gradient of the unselected tabs
  final Color tabTopColor;

  /// The bottom color of the linear gradient of the unselected tabs
  final Color tabBottomColor;

  /// The width of the border of the unselected tabs.
  final double tabBorderWidth;

  /// Color of the unselected tabs border, if the tabBorderWidth > 1
  /// Can be null if tabBorderWidth = 0.0
  final Color? tabBorderColor;

  /// List of the shadows that will be used on each tab.
  final List<BoxShadow>? shadows;

  ///Creates a new [RoundedTabsContainer] object
  RoundedTabsContainer({
    Key? key,
    Widget? child,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabStyle,
    required this.selectedTabStyle,
    this.textDirection = TextDirection.ltr,
    this.radius = const Radius.circular(24.0),
    this.tabHeight = 50.0,
    this.forcedTotalTabHeight,
    this.selectedTabTopColor = Colors.white,
    this.selectedTabBottomColor = const Color.fromRGBO(241, 241, 241, 1.0),
    this.tabTopColor = Colors.white,
    this.tabBottomColor = Colors.white,
    this.tabBorderWidth = 0.0,
    this.tabBorderColor,
    this.shadows,
  })  : assert(tabs.isNotEmpty),
        assert(tabHeight >= 0.0),
        assert(
          forcedTotalTabHeight == null || forcedTotalTabHeight > tabHeight,
        ),
        assert(tabBorderWidth >= 0.0),
        assert(tabBorderWidth == 0.0 || tabBorderColor != null,
            'Specify a border color'),
        super(key: key, child: child);

  @override
  _RenderRoundedTabsContainer createRenderObject(BuildContext context) {
    return _RenderRoundedTabsContainer(
      tabs: tabs,
      selectedIndex: selectedIndex,
      onTabSelected: onTabSelected,
      tabStyle: tabStyle,
      selectedTabStyle: selectedTabStyle,
      textDirection: textDirection,
      radius: radius,
      tabHeight: tabHeight,
      forcedTotalTabHeight: forcedTotalTabHeight,
      selectedTabTopColor: selectedTabTopColor,
      selectedTabBottomColor: selectedTabBottomColor,
      tabTopColor: tabTopColor,
      tabBottomColor: tabBottomColor,
      tabBorderColor: tabBorderColor,
      tabBorderWidth: tabBorderWidth,
      shadows: shadows,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderRoundedTabsContainer renderObject,
  ) {
    renderObject
      ..selectedIndex = selectedIndex
      ..radius = radius
      ..tabStyle = tabStyle
      ..selectedTabStyle = selectedTabStyle
      ..textDirection = textDirection
      ..selectedTabTopColor = selectedTabTopColor
      ..selectedTabBottomColor = selectedTabBottomColor
      ..tabHeight = tabHeight
      ..tabTopColor = tabTopColor
      ..tabBottomColor = tabBottomColor
      ..tabBorderWidth = tabBorderWidth;
    if (onTabSelected != null) {
      renderObject.onTabSelected = onTabSelected!;
    }
    if (forcedTotalTabHeight != null) {
      renderObject.forcedTotalTabHeight = forcedTotalTabHeight!;
    }
    if (tabBorderColor != null) {
      renderObject.tabBorderColor = tabBorderColor!;
    }
    if (shadows != null) {
      renderObject.shadows = shadows!;
    }
  }
}

class _RenderRoundedTabsContainer extends RenderProxyBox {
  final List<String> tabs;

  TextStyle _tabStyle;
  TextStyle _selectedTabStyle;

  TextDirection _textDirection;

  double _selectedIndex;
  TabIndexChanged? onTabSelected;

  double _tabHeight;

  double? _forcedTotalTabHeight;

  Radius _radius;

  Color _selectedTabTopColor;
  Color _selectedTabBottomColor;

  Color _tabTopColor;
  Color _tabBottomColor;

  Color? _tabBorderColor;
  double _tabBorderWidth;

  List<BoxShadow>? _shadows;

  _RenderRoundedTabsContainer({
    required this.tabs,
    required double selectedIndex,
    this.onTabSelected,
    required TextStyle tabStyle,
    required TextStyle selectedTabStyle,
    required TextDirection textDirection,
    required double tabHeight,
    double? forcedTotalTabHeight,
    required Radius radius,
    required Color selectedTabTopColor,
    required Color selectedTabBottomColor,
    required Color tabTopColor,
    required Color tabBottomColor,
    Color? tabBorderColor,
    required double tabBorderWidth,
    List<BoxShadow>? shadows,
  })  : _selectedIndex = selectedIndex,
        _tabStyle = tabStyle,
        _selectedTabStyle = selectedTabStyle,
        _textDirection = textDirection,
        _tabHeight = tabHeight,
        _forcedTotalTabHeight = forcedTotalTabHeight,
        _radius = radius,
        _selectedTabTopColor = selectedTabTopColor,
        _selectedTabBottomColor = selectedTabBottomColor,
        _tabTopColor = tabTopColor,
        _tabBottomColor = tabBottomColor,
        _tabBorderColor = tabBorderColor,
        _tabBorderWidth = tabBorderWidth,
        _shadows = shadows;

  double get selectedIndex => _selectedIndex;
  set selectedIndex(double selectedIndex) {
    if (_selectedIndex != selectedIndex) {
      _selectedIndex = selectedIndex;
      markNeedsPaint();
    }
  }

  TextStyle get tabStyle => _tabStyle;
  set tabStyle(TextStyle tabStyle) {
    if (_tabStyle != tabStyle) {
      _tabStyle = tabStyle;
      markNeedsPaint();
    }
  }

  TextStyle get selectedTabStyle => _selectedTabStyle;
  set selectedTabStyle(TextStyle selectedTabStyle) {
    if (_selectedTabStyle != selectedTabStyle) {
      _selectedTabStyle = selectedTabStyle;
      markNeedsPaint();
    }
  }

  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection textDirection) {
    if (_textDirection != textDirection) {
      _textDirection = textDirection;
      markNeedsPaint();
    }
  }

  double get tabHeight => _tabHeight;
  set tabHeight(double tabHeight) {
    if (_tabHeight != tabHeight) {
      _tabHeight = tabHeight;
      markNeedsLayout();
    }
  }

  double? get forcedTotalTabHeight => _forcedTotalTabHeight;
  set forcedTotalTabHeight(double? forcedTotalTabHeight) {
    if (_forcedTotalTabHeight != forcedTotalTabHeight) {
      _forcedTotalTabHeight = forcedTotalTabHeight;
      markNeedsPaint();
    }
  }

  Radius get radius => _radius;
  set radius(Radius radius) {
    if (_radius != radius) {
      _radius = radius;
      markNeedsPaint();
    }
  }

  Color get selectedTabTopColor => _selectedTabTopColor;
  set selectedTabTopColor(Color selectedTabTopColor) {
    if (_selectedTabTopColor != selectedTabTopColor) {
      _selectedTabTopColor = selectedTabTopColor;
      markNeedsPaint();
    }
  }

  Color get selectedTabBottomColor => _selectedTabBottomColor;
  set selectedTabBottomColor(Color selectedTabBottomColor) {
    if (_selectedTabBottomColor != selectedTabBottomColor) {
      _selectedTabBottomColor = selectedTabBottomColor;
      markNeedsPaint();
    }
  }

  Color get tabTopColor => _tabTopColor;
  set tabTopColor(Color tabTopColor) {
    if (_tabTopColor != tabTopColor) {
      _tabTopColor = tabTopColor;
      markNeedsPaint();
    }
  }

  Color get tabBottomColor => _tabBottomColor;
  set tabBottomColor(Color tabBottomColor) {
    if (_tabBottomColor != tabBottomColor) {
      _tabBottomColor = tabBottomColor;
      markNeedsPaint();
    }
  }

  Color? get tabBorderColor => _tabBorderColor;
  set tabBorderColor(Color? tabBorderColor) {
    if (_tabBorderColor != tabBorderColor) {
      _tabBorderColor = tabBorderColor;
      markNeedsPaint();
    }
  }

  double get tabBorderWidth => _tabBorderWidth;
  set tabBorderWidth(double tabBorderWidth) {
    if (_tabBorderWidth != tabBorderWidth) {
      _tabBorderWidth = tabBorderWidth;
      markNeedsPaint();
    }
  }

  List<BoxShadow>? get shadows => _shadows;
  set shadows(List<BoxShadow>? shadows) {
    if (_shadows != shadows) {
      _shadows = shadows;
      markNeedsPaint();
    }
  }

  double get _calculatedTabHeight => min(
        forcedTotalTabHeight ?? size.height,
        size.height,
      );

  double get _calculatedTabWidth => size.width / tabs.length;

  @override
  void performLayout() {
    final childConstraints = _getChildConstraints();

    var ourSize = constraints.smallest;

    if (child != null) {
      child!.layout(childConstraints, parentUsesSize: true);

      ourSize = Size(
        max(child!.size.width, ourSize.width),
        max(child!.size.height + _tabHeight, ourSize.height),
      );
    }

    size = ourSize;
  }

  BoxConstraints _getChildConstraints() {
    if (constraints.hasBoundedHeight) {
      final maxHeight = constraints.maxHeight - _tabHeight;

      return constraints.copyWith(
        maxHeight: maxHeight,
        minHeight: min(constraints.minHeight, maxHeight),
      );
    }

    return constraints;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required ui.Offset position}) {
    if (position.dx >= 0.0 &&
        position.dx <= size.width &&
        position.dy >= size.height - _tabHeight &&
        position.dy <= size.height) {
      final index = (position.dx / _calculatedTabWidth)
          .truncateToDouble()
          .clamp(0.0, tabs.length - 1);

      if (onTabSelected != null) {
        onTabSelected!(index.toDouble());
      }

      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return super.hitTest(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final childRRect = RRect.fromLTRBR(
      offset.dx,
      offset.dy,
      offset.dx + size.width,
      offset.dy + size.height - _tabHeight,
      radius,
    );

    _paintBackTabs(context, offset);
    _paintSelectedTab(context, offset, childRRect);
    _paintTexts(context, offset);

    if (child != null) {
      context.paintChild(child!, offset);
    }
  }

  void _paintBackTabs(PaintingContext context, Offset offset) {
    if (child == null) return;

    final calculatedTabHeight = _calculatedTabHeight;

    final baseTabRect = Rect.fromLTWH(
      0.0,
      size.height - calculatedTabHeight,
      _calculatedTabWidth,
      calculatedTabHeight,
    );

    final tabPaint = Paint()
      ..shader = ui.Gradient.linear(
        baseTabRect.topLeft.translate(offset.dx, offset.dy),
        baseTabRect.bottomLeft.translate(offset.dx, offset.dy),
        [_tabTopColor, _tabBottomColor],
      );

    final tabBorderPaint = tabBorderWidth >= 1.0
        ? (Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _tabBorderWidth)
        : null;
    if (tabBorderColor != null) {
      tabBorderPaint?.color = _tabBorderColor!;
    }

    for (var index = 0; index < tabs.length; ++index) {
      if (index == selectedIndex.round()) continue;

      final tabRect = baseTabRect
          .shift(Offset(index * baseTabRect.width, 0.0))
          .shift(offset);

      final path = Path()
        ..addRRect(
          RRect.fromRectAndRadius(tabRect, radius),
        );

      _paintShadows(context, path);

      context.canvas.drawPath(path, tabPaint);

      if (tabBorderPaint != null) {
        context.canvas.drawPath(path, tabBorderPaint);
      }
    }
  }

  void _paintSelectedTab(
    PaintingContext context,
    Offset offset,
    RRect childRRect,
  ) {
    if (_selectedIndex < 0.0 || _selectedIndex > tabs.length - 1) return;

    final childContainerPath = Path()..addRRect(childRRect);

    final tabRect = Rect.fromLTRB(
      offset.dx + (_calculatedTabWidth * _selectedIndex),
      offset.dy + (size.height / 2.0),
      offset.dx + (_calculatedTabWidth * _selectedIndex) + _calculatedTabWidth,
      offset.dy + size.height,
    );

    final curveOffset = _tabHeight * 0.4;

    final selectedTabPath = Path()
      ..moveTo(
        tabRect.left + (tabRect.width / 2.0),
        tabRect.bottom,
      )
      ..lineTo(
        tabRect.right - radius.x,
        tabRect.bottom,
      );

    // Adds right side
    if (_selectedIndex < tabs.length - 1) {
      // Both curves
      selectedTabPath.cubicTo(
        tabRect.right + (radius.x / 2.0),
        tabRect.bottom - radius.y + curveOffset,
        tabRect.right - (radius.x / 2.0),
        tabRect.bottom - radius.y - curveOffset,
        tabRect.right + radius.x,
        tabRect.bottom - _tabHeight,
      );
    } else {
      // Curve only on bottom
      selectedTabPath
        ..quadraticBezierTo(
          tabRect.right,
          tabRect.bottom,
          tabRect.right,
          tabRect.bottom - radius.y,
        )
        ..lineTo(tabRect.right, tabRect.top);
    }

    // Adds left side
    if (_selectedIndex > 0.0) {
      // Both curves
      selectedTabPath
        ..lineTo(tabRect.left - radius.x, tabRect.bottom - _tabHeight)
        ..cubicTo(
          tabRect.left + (radius.x / 2.0),
          tabRect.bottom - radius.y - curveOffset,
          tabRect.left - (radius.x / 2.0),
          tabRect.bottom - radius.y + curveOffset,
          tabRect.left + radius.x,
          tabRect.bottom,
        );
    } else {
      // Curve only on bottom
      selectedTabPath
        ..lineTo(tabRect.left, tabRect.top)
        ..lineTo(tabRect.left, tabRect.bottom - radius.y)
        ..quadraticBezierTo(
          tabRect.left,
          tabRect.bottom,
          tabRect.left + radius.x,
          tabRect.bottom,
        );
    }

    selectedTabPath.close();

    final completePath = Path.combine(
      PathOperation.union,
      childContainerPath,
      selectedTabPath,
    );

    _paintShadows(context, completePath);

    final tabPaint = Paint()
      ..shader = ui.Gradient.linear(
        tabRect.topLeft.translate(offset.dx, offset.dy),
        tabRect.bottomLeft.translate(offset.dx, offset.dy),
        [
          _selectedTabTopColor,
          _selectedTabBottomColor,
        ],
        [0.6, 0.9],
      );

    context.canvas.drawPath(completePath, tabPaint);
  }

  void _paintTexts(PaintingContext context, Offset offset) {
    final baseTextRect = Rect.fromLTRB(
      0.0,
      size.height - _tabHeight,
      _calculatedTabWidth,
      size.height,
    ).shift(offset).deflate(1.0);

    for (var index = 0; index < tabs.length; ++index) {
      final textRect = baseTextRect.translate(index * _calculatedTabWidth, 0.0);

      context.canvas.save();
      context.canvas.clipRRect(
        RRect.fromLTRBR(
          textRect.left,
          _calculatedTabHeight,
          textRect.right,
          textRect.bottom,
          radius,
        ),
      );

      final textSpan = TextSpan(
        text: tabs[index],
        style: index == selectedIndex.round() ? _selectedTabStyle : _tabStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: _textDirection,
        textAlign: TextAlign.center,
      );

      textPainter.layout(minWidth: textRect.width, maxWidth: textRect.width);

      textPainter.paint(
        context.canvas,
        Offset(
          textRect.left,
          textRect.top + (textRect.height / 2.0) - (textPainter.height / 2.0),
        ),
      );

      context.canvas.restore();
    }
  }

  void _paintShadows(PaintingContext context, Path path) {
    if (shadows?.isEmpty ?? true) return;

    for (var shadow in shadows!) {
      context.canvas.drawPath(path, shadow.toPaint());
    }
  }
}
