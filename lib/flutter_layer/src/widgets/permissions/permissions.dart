import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../business_layer/business_layer.dart';
import '../../../../data_layer/data_layer.dart';

/// Provides permissions to the rest of the tree.
class Permissions extends InheritedWidget {
  /// The set of permissions to provide to the tree.
  final UserPermissions permissions;

  /// Creates a new [Permissions].
  const Permissions({
    Key? key,
    required this.permissions,
    required Widget child,
  }) : super(key: key, child: child);

  /// Used by the ancestors to get the provided permissions.
  static UserPermissions of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Permissions>()!.permissions;

  @override
  bool updateShouldNotify(Permissions old) => permissions != old.permissions;
}

/// Helper widget that listens to the [AuthenticationCubit] and provides
/// the permissions in an easy way for the tree.
///
/// If the user is not logged in, creates a [UserPermissions] that has no
/// permissions.
///
/// Use [Permissions.of] to get the permissions on the tree.
class AuthenticationPermissions extends StatelessWidget {
  /// This widget's child.
  final Widget child;

  /// Creates a new [AuthenticationPermissions].
  const AuthenticationPermissions({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final permissions = context.select<AuthenticationCubit, UserPermissions>(
      (cubit) => cubit.state.user?.permissions ?? UserPermissions(),
    );

    return Permissions(
      permissions: permissions,
      child: child,
    );
  }
}
