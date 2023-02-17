import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../cubits.dart';
import '../widgets/contact_phone_field/contact_picker_screen.dart';

/// Mixin for picking contacts.
mixin ContactPickerMixin {
  /// Checks if the device has camera permissions.
  Future<bool> checkReadContactsPermission(
    DevicePermissionsCubit devicePermissionsCubit, {
    ValueGetter<Future<bool>>? permissionDeniedCallback,
  }) async {
    final permissionStatus = await devicePermissionsCubit.requestPermission(
      openSettings: () async {
        if (await permissionDeniedCallback?.call() ?? true) {
          await openAppSettings();
        }
        return;
      },
      permission: Permission.contacts,
    );

    return permissionStatus.isGranted;
  }

  /// Opens the contact picker screen and returns a contact when picked.
  Future<Contact?> openContactPickerScreen(
    BuildContext context, {
    ValueGetter<Future<bool>>? permissionDeniedCallback,
  }) async {
    final devicePermissionsCubit = context.read<DevicePermissionsCubit>();
    final hasPermission = await checkReadContactsPermission(
      devicePermissionsCubit,
      permissionDeniedCallback: permissionDeniedCallback,
    );

    Contact? contact;

    if (hasPermission) {
      contact = await Navigator.push<Contact>(
        context,
        MaterialPageRoute(
          builder: (_) => ContactPickerScreen(),
        ),
      );
    }

    return contact;
  }

  /// Returns a lits of sorted contacts.
  ///
  /// Use the [query] parameter for filtering purposses.
  Future<List<Contact>> loadContacts({
    String? query,
  }) async {
    final contacts = await ContactsService.getContacts(query: query);
    final effectiveContacts = contacts
        .where((contact) => contact.phones?.isNotEmpty ?? false)
        .toList();

    effectiveContacts.sort(
      (c1, c2) => c1.displayName?.compareTo(c2.displayName ?? '') ?? -1,
    );

    return effectiveContacts;
  }
}
