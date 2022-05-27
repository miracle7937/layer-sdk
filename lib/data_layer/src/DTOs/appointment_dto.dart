import '../helpers/json_parser.dart';

/// Class that holds appointment info
class AppointmentDTO {
  /// Id of the appointment
  final String? appointmentId;

  /// Id of branch
  final String? branch;

  /// Email of the console user that will attend the bank client
  final String? csrEmail;

  /// The id of the customer
  final String? customerId;

  /// When the appointment ends
  final DateTime? endDatetime;

  /// Details about the appointment
  final String? message;

  /// Id of the product that the bank client will talk about
  final String? productId;

  /// When the appointment starts
  final DateTime? startDatetime;

  /// Subject on the bank’s calendar
  final String? subject;

  /// Notes added by the customer
  final String? customerNotes;

  /// Creates a new [AppointmentDTO] instance
  AppointmentDTO({
    this.appointmentId,
    this.branch,
    this.csrEmail,
    this.customerId,
    this.endDatetime,
    this.message,
    this.productId,
    this.startDatetime,
    this.subject,
    this.customerNotes,
  });

  /// Parses a json map into a [AppointmentDTO] object
  factory AppointmentDTO.fromJson(Map<String, dynamic> json) {
    return AppointmentDTO(
      appointmentId: json['appointment_id'],
      branch: json['branch'],
      csrEmail: json['csr_email'],
      customerId: json['customer_id'],
      endDatetime: JsonParser.parseStringDate(json['end_datetime']),
      message: json['message'],
      productId: json['product_id'],
      startDatetime: JsonParser.parseStringDate(json['start_datetime']),
      subject: json['subject'],
      customerNotes: json['customer_notes'],
    );
  }

  /// Maps a instance of [AppointmentDTO] into a json map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'start_datetime': JsonParser.parseDateWithPattern(
        startDatetime!,
        'yyyy-MM-ddTHH:mm:ss',
        'en_US',
      ),
      'end_datetime': JsonParser.parseDateWithPattern(
        endDatetime!,
        'yyyy-MM-ddTHH:mm:ss',
        'en_US',
      ),
      'subject': subject,
      'costumer_notes': customerNotes,
    };
  }

  /// Returns a list of [AppointmentDTO] based on a json list
  static List<AppointmentDTO> fromJsonList(List json) {
    return json.map((a) => AppointmentDTO.fromJson(a)).toList();
  }

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'AppointmentDTO(appointmentId: $appointmentId, branch: $branch, csrEmail: $csrEmail, customerId: $customerId, endDatetime: $endDatetime, message: $message, productId: $productId, startDatetime: $startDatetime, subject: $subject, customerNotes: $customerNotes)';
  }
}
