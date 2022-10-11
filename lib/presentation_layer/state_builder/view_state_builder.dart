import 'package:flutter/material.dart';

/// The view state builder to handle all view status
class ViewStateBuilder extends StatelessWidget {
  /// The status of the view
  final ViewStatus viewState;

  /// The builder to handle loading status
  final WidgetBuilder loadingBuilder;

  /// The builder to handle error status
  final WidgetBuilder errorBuilder;

  /// The builder to handle empty status
  final WidgetBuilder emptyBuilder;

  /// The builder to handle idle status
  final WidgetBuilder idleBuilder;

  /// Creates [ViewStateBuilder].
  const ViewStateBuilder({
    Key? key,
    required this.viewState,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.emptyBuilder,
    required this.idleBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewState) {
      case ViewStatus.loading:
        return loadingBuilder(context);
      case ViewStatus.error:
        return errorBuilder(context);
      case ViewStatus.idle:
        return idleBuilder(context);
      case ViewStatus.empty:
        return emptyBuilder(context);
    }
  }
}

/// The view status
enum ViewStatus {
  ///The loading status to show loader
  loading,

  ///The error status to error card view
  error,

  ///The idle status to show builder
  idle,

  ///This status for the empty data
  empty
}
