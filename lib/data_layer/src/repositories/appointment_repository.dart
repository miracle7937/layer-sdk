
import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handle Appointment data
class AppointmentRepository {
  /// [AppointmentProvider] instance
  final AppointmentProvider _provider;

  /// Creates a new instance of [AppointmentRepository]
  AppointmentRepository(
    AppointmentProvider provider,
  ) : _provider = provider;

  /// List all appointments
  Future<List<Appointment>> listAppointments({bool sort = false}) async {
    final appointmentDtos = await _provider.getAppointments();
    final appointments = appointmentDtos.map((a) => a.toAppointment()).toList();

    if (sort) {
      appointments.sort(
        (appointment1, appointment2) =>
            appointment1.startDatetime.compareTo(appointment2.startDatetime),
      );
    }

    return appointments;
  }

  /// Book an appointment
  Future<Appointment> bookAppointment(Appointment appointment) async {
    final result =
        await _provider.bookAppointment(appointment.toAppointmentDTO());

    return result.toAppointment();
  }

  /// Delete an appointment
  Future<void> deleteAppointment(Appointment appointment) async {
    return await _provider.deleteAppointment(appointment.toAppointmentDTO());
  }

  /// Update an appointment
  Future<Appointment> updateAppointment(Appointment appointment) async {
    final result =
        await _provider.updateAppointment(appointment.toAppointmentDTO());

    return result.toAppointment();
  }

  /// List all available free timeslots
  Future<List<BranchFreeTime>> listBranchFreeTime(
    String branchId,
    DateTime startDate, {
    DateTime? endDate,
  }) async {
    final result = await _provider.getBranchFreeTime(
      branchId,
      startDate,
      endDate: endDate,
    );

    return result.map((f) => f.toBranchFreeTime()).toList();
  }
}
