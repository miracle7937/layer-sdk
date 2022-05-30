import '../helpers.dart';

/// Data transfer object for a branch.
class BranchDTO {
  /// The internal id of this branch.
  final String? id;

  /// This branch's location data.
  final BranchLocationDTO? location;

  /// If the branch has safe deposit boxes.
  final bool? hasSafeDeposit;

  /// If this is a virtual branch.
  final bool? isVirtual;

  /// A string with the branch's opening hours.
  final String? openingHours;

  /// The date the branch was created.
  final DateTime? created;

  /// The date the branch was last updated.
  final DateTime? updated;

  /// A string with the branch's working hours.
  final List<BranchWorkTimeDTO>? workingTime;

  /// Creates a new [BranchDTO].
  BranchDTO({
    this.id,
    this.location,
    this.hasSafeDeposit,
    this.isVirtual,
    this.openingHours,
    this.created,
    this.updated,
    this.workingTime,
  });

  /// Creates a new [BranchDTO] from the given JSON.
  factory BranchDTO.fromJson(Map<String, dynamic> json) => BranchDTO(
        id: json['branch_id'],
        location: json['location'] != null
            ? BranchLocationDTO.fromJson(json['location'])
            : null,
        hasSafeDeposit: json['has_safe_deposit'],
        isVirtual: json['virtual'],
        openingHours: json['opening_hours'],
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
        workingTime: json['worktime'] != null
            ? BranchWorkTimeDTO.fromJsonList(json['worktime'])
            : null,
      );

  /// Creates a list of [BranchDTO]s from the given JSON list.
  static List<BranchDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(BranchDTO.fromJson).toList();
}

/// Data transfer object for a branch location.
class BranchLocationDTO {
  /// The internal id of this branch location.
  final int? id;

  /// The name of this branch location.
  final String? name;

  /// The physical address of this branch location.
  final String? address;

  /// The latitude.
  final double? latitude;

  /// The longitude.
  final double? longitude;

  /// The e-mail address.
  final String? email;

  /// The website for this branch location.
  final String? website;

  /// The current distance for this branch location.
  final double? distance;

  /// The date the location branch was created.
  final DateTime? created;

  /// The date the location branch was last updated.
  final DateTime? updated;

  /// Creates a new [BranchLocationDTO].
  BranchLocationDTO({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.email,
    this.website,
    this.distance,
    this.created,
    this.updated,
  });

  /// Creates a new [BranchLocationDTO] from the given JSON.
  factory BranchLocationDTO.fromJson(Map<String, dynamic> json) =>
      BranchLocationDTO(
        id: JsonParser.parseInt(json['location_id']),
        name: json['name'],
        address: json['address'],
        latitude: JsonParser.parseDouble(json['latitude']),
        longitude: JsonParser.parseDouble(json['longitude']),
        email: json['email'],
        website: json['website'],
        distance: json['distance'],
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
      );
}

/// Data transfer object for a branch work time.
class BranchWorkTimeDTO {
  /// The branch work time id.
  final int? id;

  /// The id of the bundle that the work time belongs to.
  final String? bundleId;

  /// The day of the week for this specific work time.
  final int? dayOfWeek;

  /// The opening time of the branch.
  final String? startTime;

  /// The closing time of the branch.
  final String? stopTime;

  /// Creates a new [BranchWorkTimeDTO].
  BranchWorkTimeDTO({
    this.id,
    this.bundleId,
    this.dayOfWeek,
    this.startTime,
    this.stopTime,
  });

  /// Creates a new [BranchWorkTimeDTO] from the given JSON.
  factory BranchWorkTimeDTO.fromJson(Map<String, dynamic> json) =>
      BranchWorkTimeDTO(
        id: json['worktime_id'],
        bundleId: json['bundle_id'],
        dayOfWeek: json['dow'],
        startTime: json['start_time'],
        stopTime: json['stop_time'],
      );

  /// Creates a list of [BranchWorkTimeDTO]s from the given JSON list.
  static List<BranchWorkTimeDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(BranchWorkTimeDTO.fromJson).toList();
}
