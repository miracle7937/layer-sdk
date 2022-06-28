import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'cubit_creator.dart';

/// A mixin to facilitate the use of a [CreatorProvider] in other widgets like
/// the [MultiCreatorProvider].
///
/// Unless you're creating a new [CreatorProvider], you don't need to worry
/// about this.
mixin CreatorSingleChildWidget on SingleChildWidget {}

/// Provides a [CubitCreator] to the tree.
///
/// It uses Provider to, well, provide the creator to the tree.
class CreatorProvider<T extends CubitCreator> extends SingleChildStatelessWidget
    with CreatorSingleChildWidget {
  /// Widget which will have access to the [CubitCreator].
  final Widget? child;

  /// Whether the [CubitCreator] should be created lazily.
  ///
  /// Defaults to `true`.
  final bool lazy;

  final Create<T> _create;

  final Dispose<T>? _dispose;

  /// Creates a new [CreatorProvider].
  const CreatorProvider({
    Key? key,
    required Create<T> create,
    Dispose<T>? dispose,
    this.child,
    this.lazy = true,
  })  : _create = create,
        _dispose = dispose,
        super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      InheritedProvider<T>(
        create: _create,
        dispose: _dispose,
        lazy: lazy,
        child: child,
      );

  /// Call this to access this object from lower parts of the tree.
  static T of<T extends CubitCreator>(
    BuildContext context, {
    bool listen = false,
  }) {
    try {
      return Provider.of<T>(context, listen: listen);
    } on ProviderNotFoundException catch (e) {
      if (e.valueType != T) rethrow;

      throw FlutterError(
        '''
        CreatorProvider.of() called with a context that does not contain a CubitCreator of type $T.
        No ancestor could be found starting from the context that was passed to CreatorProvider.of<$T>().

        This can happen if the context you used comes from a widget above the CreatorProvider.

        The context used was: $context
        ''',
      );
    }
  }
}
