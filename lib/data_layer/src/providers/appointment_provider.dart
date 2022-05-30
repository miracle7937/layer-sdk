import '../../../migration/data_layer/network.dart';
import '../dtos.dart';
import '../helpers/json_parser.dart';

/// Provides data for bank branch appointments
class AppointmentProvider {
  /// Network requests manager
  final NetClient _netClient;

  /// Creates a new [AppointmentProvider]
  AppointmentProvider({
    required NetClient netClient,
  }) : _netClient = netClient;

  /// List all appointments by branch
  Future<List<AppointmentDTO>> getAppointments() async {
    final dateTime = DateTime.now();
    final params = <String, dynamic>{
      'start_datetime': JsonParser.parseDateWithPattern(
        dateTime,
        'yyyy-MM-ddTHH:mm:ss',
        'en_US',
      ),
      'end_datetime': JsonParser.parseDateWithPattern(
        dateTime.add(Duration(days: 365)),
        'yyyy-MM-ddTHH:mm:ss',
        'en_US',
      ), //one year
    };

    final response = await _netClient.request(
      _netClient.netEndpoints.appointments,
      method: NetRequestMethods.get,
      forceRefresh: false,
      queryParameters: params,
    );

    return AppointmentDTO.fromJsonList(response.data);
  }

  /// Book an appointment
  Future<AppointmentDTO> bookAppointment(AppointmentDTO appointment) async {
    final response = await _netClient.request(
      '${_netClient.netEndpoints.integration}/branch/${appointment.branch}/appointment',
      method: NetRequestMethods.post,
      data: appointment.toJson(),
    );

    return AppointmentDTO.fromJson(response.data);
  }

  /// Delete a appointment
  Future<void> deleteAppointment(AppointmentDTO appointment) async {
    await _netClient.request(
      '${_netClient.netEndpoints.integration}/branch/${appointment.branch}/appointment/${appointment.appointmentId}',
      method: NetRequestMethods.delete,
    );
  }

  /// Delete an appointment
  Future<AppointmentDTO> updateAppointment(AppointmentDTO appointment) async {
    final response = await _netClient.request(
      '${_netClient.netEndpoints.integration}/branch/${appointment.branch}/appointment/${appointment.appointmentId}',
      method: NetRequestMethods.patch,
      data: appointment.toJson(),
    );

    return AppointmentDTO.fromJson(response.data);
  }

  /// List available timeslots for a specific Branch
  Future<List<BranchFreeTimeDTO>> getBranchFreeTime(
    String branchId,
    DateTime startDate, {
    DateTime? endDate,
  }) async {
    if (endDate == null) {
      endDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        23,
        59,
        59,
      );
    }

    final params = <String, dynamic>{
      'start_datetime': JsonParser.parseDateWithPattern(
        startDate,
        'yyyy-MM-ddTHH:mm:ss',
        'en_US',
      ),
      'end_datetime': JsonParser.parseDateWithPattern(
        endDate,
        'yyyy-MM-ddTHH:mm:ss',
        'en_US',
      ),
    };

    final response = await _netClient.request(
      '${_netClient.netEndpoints.integration}/branch/$branchId/freetime',
      method: NetRequestMethods.get,
      queryParameters: params,
    );

    return BranchFreeTimeDTO.fromJsonList(response.data);
  }
}
