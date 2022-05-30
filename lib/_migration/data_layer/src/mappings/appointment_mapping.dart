import '../../models.dart';
import '../dtos.dart';

/// Extension that provide mappings from [AppointmentDTO] to [Appointment]
extension AppointmentDtoMapping on AppointmentDTO {
  /// Mapps [AppointmentDTO] into [Appointment]
  Appointment toAppointment() {
    final _defaultDate = DateTime.now();
    return Appointment(
      appointmentId: appointmentId,
      branch: branch ?? '',
      csrEmail: csrEmail,
      customerId: customerId ?? '',
      endDatetime: endDatetime ?? _defaultDate,
      message: message,
      startDatetime: startDatetime ?? _defaultDate,
      subject: subject ?? '',
      customerNotes: customerNotes,
    );
  }
}

/// Extension that provide mappings from [Appointment] to [AppointmentDTO]
extension AppointmentMapping on Appointment {
  /// Mapps [Appointment] into [AppointmentDTO]
  AppointmentDTO toAppointmentDTO() {
    return AppointmentDTO(
      appointmentId: appointmentId,
      branch: branch,
      csrEmail: csrEmail,
      customerId: customerId,
      endDatetime: endDatetime,
      message: message,
      startDatetime: startDatetime,
      subject: subject,
      customerNotes: customerNotes,
    );
  }
}
