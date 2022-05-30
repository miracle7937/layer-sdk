import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creator_provider.dart';

/// Provides a list of Cubit Creators to the tree.
class MultiCreatorProvider extends MultiProvider {
  /// Creates a new [MultiCreatorProvider] with the given cubit creators.
  MultiCreatorProvider({
    Key? key,
    required List<CreatorSingleChildWidget> creators,
    required Widget child,
  }) : super(key: key, providers: creators, child: child);
}
