import '../../errors.dart';
import '../../models.dart';
import '../dtos.dart';
import '../mappings.dart';

/// Extension that provides mappings for [DeviceSessionDTO]
extension DeviceSessionDTOMapping on DeviceSessionDTO {
  /// Maps into a [DeviceSession]
  DeviceSession toDeviceSession() => DeviceSession(
        status: status?.toSessionStatus() ?? SessionStatus.other,
        deviceId: deviceId?.toString(),
        deviceName: deviceName,
        type: type?.toSessionType(),
        model: model,
        resolution: resolution?.toResolution(),
        carrier: carrier,
        login: loginName,
        appVersion: appVersion,
        appBuildNumber: appBuildNumber,
        osFamily: osFamily,
        osVersion: osVersion,
        browser: browser,
        lastIP: lastIP,
        lastLocation: lastLocation,
        location: locationDetails?.toLocation(),
        created: dateCreated,
        expires: expiresAt,
        lastActivity: lastActivity,
      );
}

///Extension that provides mappings for [DeviceSession]
extension DeviceSessionMapping on DeviceSession {
  /// Maps a [DeviceSession] into a [DeviceSessionDTO]
  DeviceSessionDTO toDeviceSessionDTO() => DeviceSessionDTO(
        deviceName: deviceName,
        model: model,
        resolution: resolution != null
            ? '${resolution!.width} x ${resolution!.height}'
            : null,
        carrier: carrier,
        osVersion: osVersion,
      );
}

/// Extension that provides mappings for [SessionStatusDTO]
extension SessionStatusDTOMapping on SessionStatusDTO {
  /// Maps into a [SessionStatus]
  SessionStatus toSessionStatus() {
    switch (this) {
      case SessionStatusDTO.active:
        return SessionStatus.active;

      case SessionStatusDTO.inactive:
        return SessionStatus.inactive;

      case SessionStatusDTO.wiped:
        return SessionStatus.wiped;

      case SessionStatusDTO.loggedOut:
        return SessionStatus.loggedOut;

      case SessionStatusDTO.other:
        return SessionStatus.other;

      default:
        throw MappingException(from: SessionStatusDTO, to: SessionStatus);
    }
  }
}

/// Extension that provides mappings for [SessionTypeDTO]
extension SessionTypeDTOMapping on SessionTypeDTO {
  /// Maps into a [SessionType]
  SessionType toSessionType() {
    switch (this) {
      case SessionTypeDTO.android:
        return SessionType.android;

      case SessionTypeDTO.iphone:
        return SessionType.iOS;

      case SessionTypeDTO.web:
        return SessionType.web;

      case SessionTypeDTO.other:
        return SessionType.other;

      default:
        throw MappingException(from: SessionTypeDTO, to: SessionType);
    }
  }
}

/// Extension that provides mappings for [LocationDetailsDTO]
extension LocationDetailsDTOMapping on LocationDetailsDTO {
  /// Maps into a [Location]
  Location toLocation() => Location(
        city: city,
        continent: continent,
        country: country,
        countryISO: countryISO,
        latitude: latitude?.toDouble(),
        longitude: longitude?.toDouble(),
      );
}
