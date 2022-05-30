import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../design.dart';

/// Holds the information needed for a [DesignRow] child.
class DesignRowData {
  /// The child widget.
  final Widget child;

  /// The default number of design columns the child should occupy.
  final int columnCount;

  /// Optional number of design columns the child should occupy based on the
  /// [DesignSize].
  final Map<DesignSize, int> columnsBySize;

  /// Creates a new [DesignRowData].
  const DesignRowData({
    required this.child,
    required this.columnCount,
    required this.columnsBySize,
  });
}

/// Creates a horizontal array of children whose sizes are dictated by how many
/// design columns they use.
///
/// The children are separated by the gutter size of the current design.
///
/// If the column size is `0`, then the child won't be added. In the next
/// example, we have three columns. All with different sizes for different
/// [DesignSize]s. The last column is not shown when the [DesignSize] is extra
/// small.
///
/// ```dart
///   return const DesignRow(
///     childrenData: [
///       DesignRowData(
///         columnCount: 8,
///         columnsBySize: {
///           DesignSize.extraSmall: 1,
///           DesignSize.small: 6,
///         },
///         child: Text('First column'),
///       ),
///       DesignRowData(
///         columnCount: 3,
///         columnsBySize: {
///           DesignSize.extraSmall: 1,
///           DesignSize.small: 1,
///         },
///         child: Text('Second column'),
///       ),
///       DesignRowData(
///         columnCount: 1,
///         columnsBySize: {
///           DesignSize.extraSmall: 0,
///           DesignSize.small: 1,
///         },
///         child: Text('Extra column'),
///       ),
///     ],
///   );
/// ```
///
/// Note that overflows may happen in a few cases when quickly changing the
/// sizes.
///
/// This widget can also be used to size a single widget like this:
///
/// ```dart
///     return const DesignRow(
///       useMargin: false,
///       animated: false,
///       childrenData: [
///         DesignRowData(
///           columnCount: 12,
///           columnsBySize: {
///             DesignSize.extraSmall: 2,
///             DesignSize.small: 8,
///           },
///           child: Text('Single column'),
///         ),
///       ],
///     );
/// ```
class DesignRow extends StatelessWidget {
  /// The style to use to find out the design size.
  ///
  /// Defaults to [DesignStyle.common].
  final DesignStyle style;

  /// The children data.
  final List<DesignRowData> childrenData;

  /// If the margins should be added to the row.
  ///
  /// Note that the animation works better (with less overflows), when this
  /// property is set to `true` and you're not using a [DesignMargin] widget.
  /// This is due to the two widgets not necessarily being synchronized.
  ///
  /// Remember that the columns sizes won't change if this is set to `false`,
  /// as they are always calculated with the margins in mind.
  ///
  /// Defaults to `true`.
  final bool useMargin;

  /// If size changes should be animated.
  ///
  /// Defaults to `true`.
  final bool animated;

  /// The duration for the size change animation.
  ///
  /// Used only if [animated] is `true`.
  ///
  /// Defaults to 200 milliseconds.
  final Duration duration;

  /// The curve for the size change animation.
  ///
  /// Used only if [animated] is `true`.
  ///
  /// Defaults to [Curves.linear].
  final Curve curve;

  /// The main axis alignment.
  ///
  /// Defaults to [MainAxisAlignment.start].
  final MainAxisAlignment mainAxisAlignment;

  /// The cross axis alignment.
  ///
  /// Defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// Creates a new [DesignRow].
  const DesignRow({
    Key? key,
    this.style = DesignStyle.common,
    required this.childrenData,
    this.useMargin = true,
    this.animated = true,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final designData = DesignAware.of(context, style: style);

    final widgets = childrenData
        .map(
          (childData) {
            final columnCount = childData.columnsBySize[designData.size] ??
                childData.columnCount;

            if (columnCount <= 0) return null;

            final columnsWidth = designData.columnWidth * columnCount;

            final guttersWidth = max(0, columnCount - 1) * designData.gutter;

            return ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: columnsWidth + guttersWidth,
              ),
              child: RepaintBoundary(
                child: childData.child,
              ),
            );
          },
        )
        .whereNotNull()
        // Adds gutters
        .expand(
          (widget) => [
            widget,
            SizedBox(width: designData.gutter),
          ],
        )
        .toList()
      // Removes last gutter
      ..removeLast();

    Widget row = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: widgets,
    );

    if (useMargin) {
      row = Padding(
        padding: EdgeInsets.symmetric(horizontal: designData.margin),
        child: row,
      );
    }

    if (!animated) return row;

    return AnimatedSize(
      duration: duration,
      curve: curve,
      child: row,
    );
  }
}
