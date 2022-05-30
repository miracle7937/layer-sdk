import 'package:equatable/equatable.dart';

/// Class that holds data for branch appointments
class Appointment extends Equatable {
  /// Id of the appointment
  final String? appointmentId;

  /// Id of branch
  final String branch;

  /// Email of the console user that will attend the bank client
  final String? csrEmail;

  /// The id of the customer
  final String customerId;

  /// When the appointment ends
  final DateTime endDatetime;

  /// Details about the appointment
  final String? message;

  /// When the appointment starts
  final DateTime startDatetime;

  /// Subject on the bank’s calendar
  final String subject;

  /// Notes added by the customer
  final String? customerNotes;

  /// Creates a new [Appointment] instance
  Appointment({
    this.appointmentId,
    required this.branch,
    required this.customerId,
    required this.endDatetime,
    required this.startDatetime,
    required this.subject,
    this.csrEmail,
    this.message,
    this.customerNotes,
  });

  @override
  List<Object?> get props {
    return [
      appointmentId,
      branch,
      csrEmail,
      customerId,
      endDatetime,
      message,
      startDatetime,
      subject,
      customerNotes,
    ];
  }
}
