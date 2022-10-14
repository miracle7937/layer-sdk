import 'package:contacts_service/contacts_service.dart';
import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../mixins.dart';
import '../../utils.dart';
import '../header/sdk_header.dart';

/// A screen for picking a contact from a the list of contacts on the device.
class ContactPickerScreen extends StatefulWidget {
  /// Creates a new [ContactPickerScreen].
  const ContactPickerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactPickerScreen> createState() => _ContactPickerScreenState();
}

class _ContactPickerScreenState extends State<ContactPickerScreen>
    with ContactPickerMixin {
  /// Whether if the contacts are loading or not.
  bool _loadingContacts = true;
  bool get loadingContacts => _loadingContacts;
  set loadingContacts(bool loadingContacts) =>
      setState(() => _loadingContacts = loadingContacts);

  /// The list of contacts.
  List<Contact> _contacts = <Contact>[];
  List<Contact> get contacts => _contacts;
  set contacts(List<Contact> contacts) => setState(() => _contacts = contacts);

  /// The list of filtered contacts.
  List<Contact> _filteredContacts = <Contact>[];
  List<Contact> get filteredContacts => _filteredContacts;
  set filteredContacts(List<Contact> filteredContacts) =>
      setState(() => _filteredContacts = filteredContacts);

  /// The effective list of contacts.
  List<Contact> get effectiveContactList =>
      filteredContacts.isNotEmpty ? filteredContacts : contacts;

  @override
  void initState() {
    _loadContacts();

    super.initState();
  }

  /// Loads the contacts from the device.
  Future<void> _loadContacts() async {
    loadingContacts = true;

    final contacts = await loadContacts();
    this.contacts = contacts;

    loadingContacts = false;
  }

  /// Filters the contacts with the passed [query].
  void _filterContacts(
    String query,
  ) {
    filteredContacts = contacts
        .where(
          (contact) =>
              (contact.displayName ?? '').toLowerCase().contains(query) ||
              (contact.phones ?? <Item>[])
                  .where((phone) => (phone.value ?? '').contains(query))
                  .isNotEmpty,
        )
        .toList();
  }

  /// Returns a list of widgets that represents the contacts on the device
  /// segmented and separated alphabetically.
  List<Widget> buildSegmentedContactWidgetList(
    LayerDesign layerDesign,
    Translation translation,
  ) {
    if (contacts.isEmpty) {
      return <Widget>[
        Text(
          translation.translate('there_are_no_contacts_on_your_device'),
          style: layerDesign.bodyM(),
        ),
      ];
    }

    final addedHeaderInitials = <String>[];

    final contactWidgetList = <Widget>[];
    for (final contact in effectiveContactList) {
      final initial = (contact.displayName ?? '').characters.first;
      var shouldAddDivider = false;

      if (!addedHeaderInitials.contains(initial)) {
        if (addedHeaderInitials.isNotEmpty) {
          contactWidgetList.add(const SizedBox(height: 8.0));
        }
        addedHeaderInitials.add(initial);

        contactWidgetList.add(buildInitialHeader(layerDesign, initial));
      } else {
        shouldAddDivider = true;
      }

      if (shouldAddDivider) {
        contactWidgetList.add(
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: layerDesign.surfaceSeptenary4,
          ),
        );
      }

      contactWidgetList.add(buildContainerTile(layerDesign, contact));
    }

    return contactWidgetList;
  }

  /// Builds an initial header for the contacts widget list.
  Widget buildInitialHeader(
    LayerDesign layerDesign,
    String initial,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            initial,
            style: layerDesign.titleS(
              color: layerDesign.baseQuaternary,
            ),
          ),
          const SizedBox(height: 8.0),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: layerDesign.surfaceSeptenary4,
          ),
        ],
      );

  Widget buildContainerTile(
    LayerDesign layerDesign,
    Contact contact,
  ) {
    final hasPhone = (contact.phones?.isNotEmpty ?? false);
    final hasAvatar = contact.avatar?.isNotEmpty ?? false;

    final initials = <String>[];
    final givenName = (contact.givenName ?? '').trim();
    final familyName = (contact.familyName ?? '').trim();
    if (givenName.isNotEmpty) {
      initials.add(givenName.substring(0, 1).toUpperCase());
    }
    if (familyName.isNotEmpty) {
      initials.add(familyName.substring(0, 1).toUpperCase());
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context, contact),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          children: [
            Container(
              height: 36.0,
              width: 36.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: layerDesign.surfaceSeptenary4),
                image: (hasAvatar)
                    ? DecorationImage(image: MemoryImage(contact.avatar!))
                    : null,
                color: layerDesign.surfaceNonary3,
              ),
              child: !hasAvatar
                  ? Center(
                      child: Text(
                        initials.join(),
                        style: layerDesign.titleS(
                          color: layerDesign.brandPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.displayName ?? '',
                    style: layerDesign.titleM(),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    hasPhone ? (contact.phones!.first.value ?? '') : '',
                    style: layerDesign.bodyM(
                      color: layerDesign.baseQuaternary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);
    final translation = Translation.of(context);

    final contactWidgetList = buildSegmentedContactWidgetList(
      layerDesign,
      translation,
    );

    return Scaffold(
      appBar: SDKHeader(
        title: translation.translate('contacts'),
        prefixSvgIcon: DKImages.arrowLeft,
        onPrefixIconPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            DKSearchField(
              hint: translation.translate('search'),
              onChanged: _filterContacts,
            ),
            loadingContacts
                ? Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: DKLoader(),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      itemBuilder: (context, index) => contactWidgetList[index],
                      itemCount: contactWidgetList.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
