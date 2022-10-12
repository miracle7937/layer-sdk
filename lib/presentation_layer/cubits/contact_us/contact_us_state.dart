import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';
import '../../../../domain_layer/models.dart';

/// The available error status
enum ContactUsErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// Describe what the cubit may be busy performing.
enum ContactUsBusyAction {
  /// Loading the settings
  load,
}

/// All the data needed to handle the contact us screen
class ContactUsState extends Equatable {
  /// The experience data as configured in the Experience Studio.
  ///
  /// This field is null before the experience is fetched.
  final Experience? experience;

  /// The current error status.
  final ContactUsErrorStatus error;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<ContactUsBusyAction> actions;

  /// The contact us settings taken from the console
  final UnmodifiableListView<GlobalSetting?> globalSettings;

  /// The contact us list
  final UnmodifiableListView<ContactUsItem> contactUsList;

  /// Creates a new contact us state
  ContactUsState({
    this.experience,
    this.error = ContactUsErrorStatus.none,
    Set<ContactUsBusyAction> actions = const <ContactUsBusyAction>{},
    Iterable<GlobalSetting?>? globalSettings = const <GlobalSetting>{},
    Iterable<ContactUsItem> contactUsList = const <ContactUsItem>{},
  })  : actions = UnmodifiableSetView(actions),
        globalSettings = UnmodifiableListView(globalSettings ?? []),
        contactUsList = UnmodifiableListView(contactUsList);

  @override
  List<Object?> get props => [
        experience,
        error,
        actions,
        globalSettings,
        contactUsList,
      ];

  /// Creates a new state based on this one.
  ContactUsState copyWith({
    Experience? experience,
    Set<ContactUsBusyAction>? actions,
    ContactUsErrorStatus? error,
    Iterable<GlobalSetting?>? globalSettings,
    Iterable<ContactUsItem>? contactUsList,
  }) =>
      ContactUsState(
        experience: experience ?? this.experience,
        error: error ?? this.error,
        actions: actions ?? this.actions,
        globalSettings: globalSettings,
        contactUsList: contactUsList ?? this.contactUsList,
      );
}
