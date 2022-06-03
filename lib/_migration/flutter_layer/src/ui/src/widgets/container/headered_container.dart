import 'package:flutter/material.dart';

///Widget that has a title and a content [Widget]
///This can also be used to only paint the title by
///not indicating the content param
class HeaderedContainer extends StatelessWidget {
  ///The title of the [HeaderedContainer]
  final String title;

  ///The [Double] amount of space under the tilte.
  ///([24.0] by default)
  final double? spaceUnderTitle;

  ///The [TextStyle] for the tile
  final TextStyle? titleStyle;

  ///The subtitle for the [HeaderedContainer]
  final String? subtitle;

  ///The [TextStyle] for the subtitle
  final TextStyle? subtitleStyle;

  ///The [Color] for the line
  final Color lineColor;

  ///The [Widget] below the title
  final Widget? child;

  ///Creates a new [HeaderedContainer]
  const HeaderedContainer({
    required this.title,
    this.spaceUnderTitle,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.lineColor = Colors.white,
    this.child,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (subtitle == null) _buildLine(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  title.toUpperCase(),
                  style: titleStyle ?? TextStyle(color: Colors.white),
                ),
              ),
              _buildLine(),
              if (subtitle != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    title.toUpperCase(),
                    style: titleStyle ?? TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          if (child != null) SizedBox(height: spaceUnderTitle ?? 24.0),
          if (child != null) child!,
        ],
      );

  Widget _buildLine() => Expanded(
        child: Container(
          height: 1,
          color: lineColor.withOpacity(0.2),
        ),
      );
}
