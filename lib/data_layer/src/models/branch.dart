import 'package:equatable/equatable.dart';

/// Keeps the data associated with a branch
class Branch extends Equatable {
  /// The internal id of this branch.
  final String id;

  /// This branch's location data.
  final BranchLocation location;

  /// If the branch has safe deposit boxes.
  ///
  /// Defaults to `false`.
  final bool hasSafeDeposit;

  /// If this is a virtual branch.
  ///
  /// Defaults to `false`.
  final bool isVirtual;

  /// A string with the branch's opening hours.
  final String openingHours;

  /// The date the branch was created.
  final DateTime? created;

  /// The date the branch was last updated.
  final DateTime? updated;

  // TODO: add when we have the values
  //final WorktimeStatus worktimeStatus;

  /// Creates a new [Branch].
  const Branch({
    this.id = '',
    this.location = const BranchLocation(),
    this.hasSafeDeposit = false,
    this.isVirtual = false,
    this.openingHours = '',
    this.created,
    this.updated,
  });

  /// Creates a new branch based on this one.
  Branch copyWith({
    String? id,
    BranchLocation? location,
    bool? hasSafeDeposit,
    bool? isVirtual,
    String? openingHours,
    DateTime? created,
    DateTime? updated,
    String? workingHours,
  }) =>
      Branch(
        id: id ?? this.id,
        location: location ?? this.location,
        hasSafeDeposit: hasSafeDeposit ?? this.hasSafeDeposit,
        isVirtual: isVirtual ?? this.isVirtual,
        openingHours: openingHours ?? this.openingHours,
        created: created ?? this.created,
        updated: updated ?? this.updated,
      );

  @override
  List<Object?> get props => [
        id,
        location,
        hasSafeDeposit,
        isVirtual,
        openingHours,
        created,
        updated,
      ];
}

/// Keeps the data of a branch location.
class BranchLocation extends Equatable {
  /// The internal id of this branch location.
  final int id;

  /// The name of this branch location.
  final String name;

  /// The physical address of this branch location.
  final String address;

  /// The latitude.
  final double? latitude;

  /// The longitude.
  final double? longitude;

  /// The e-mail address.
  final String email;

  /// The website for this branch location.
  final String website;

  /// The current distance for this branch location.
  final double? distance;

  // TODO: add when we know the data we want here.
  //final String phone;

  /// The date the location branch was created.
  final DateTime? created;

  /// The date the location branch was last updated.
  final DateTime? updated;

  /// Creates a new [BranchLocation].
  const BranchLocation({
    this.id = 0,
    this.name = '',
    this.address = '',
    this.latitude,
    this.longitude,
    this.email = '',
    this.website = '',
    this.distance,
    this.created,
    this.updated,
  });

  /// Creates a new branch location based on this one.
  BranchLocation copyWith({
    int? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? email,
    String? website,
    double? distance,
    DateTime? created,
    DateTime? updated,
  }) =>
      BranchLocation(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        email: email ?? this.email,
        website: website ?? this.website,
        distance: distance ?? this.distance,
        created: created ?? this.created,
        updated: updated ?? this.updated,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        email,
        website,
        distance,
        created,
        updated,
      ];
}
