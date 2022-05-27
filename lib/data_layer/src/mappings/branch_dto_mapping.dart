import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mapping for [BranchDTO]
extension BranchDTOMapping on BranchDTO {
  /// Maps into a [Branch] model.
  Branch toBranch() => Branch(
        id: id ?? '',
        location: location?.toBranchLocation() ?? BranchLocation(),
        hasSafeDeposit: hasSafeDeposit ?? false,
        isVirtual: isVirtual ?? false,
        openingHours: openingHours ?? '',
        created: created,
        updated: updated,
      );
}

/// Extension that provides mapping for [BranchLocationDTO]
extension BranchLocationDTOMapping on BranchLocationDTO {
  /// Maps into a [BranchLocation] model.
  BranchLocation toBranchLocation() => BranchLocation(
        id: id ?? 0,
        name: name ?? '',
        address: address ?? '',
        latitude: latitude,
        longitude: longitude,
        email: email ?? '',
        website: website ?? '',
        distance: distance,
        created: created,
        updated: updated,
      );
}
