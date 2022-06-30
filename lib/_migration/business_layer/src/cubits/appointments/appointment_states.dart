import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';
import '../../../../data_layer/data_layer.dart';

/// The available errors.
enum AppointmentStateError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// Class that holds state of [AppointmentCubit]
class AppointmentState extends Equatable {
  /// The selected branch for the scheduled appointment
  final Branch? branch;

  /// List of selected products for the scheduled appointment
  final List<Product>? products;

  /// Appointment instance
  final Appointment? appointment;

  /// Error status
  final AppointmentStateError error;

  /// Error message
  final String errorMessage;

  /// If the cubit is loading information
  final bool busy;

  /// Creates a new instance of [AppointmentState]
  AppointmentState({
    this.branch,
    this.products,
    this.appointment,
    this.busy = false,
    this.error = AppointmentStateError.none,
    this.errorMessage = '',
  });

  /// If the user as an scheduled appointment
  bool get hasAppointments => appointment != null;

  /// Branch name
  String get branchName => branch?.location.name ?? '';

  /// Appointment time
  ///
  /// [hasAppointments] must be true in order to get [appointmentTime]
  DateTime get appointmentTime => appointment!.startDatetime;

  @override
  List<Object?> get props {
    return [
      branch,
      products,
      appointment,
      error,
      errorMessage,
      busy,
    ];
  }

  /// Make a copy of [AppointmentState]
  AppointmentState copyWith({
    Branch? branch,
    List<Product>? products,
    Appointment? appointment,
    AppointmentStateError? error,
    String? errorMessage,
    bool? busy,
    bool forceNullAppointment = false,
  }) {
    return AppointmentState(
      branch: branch ?? this.branch,
      products: products ?? this.products,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      busy: busy ?? this.busy,
      appointment:
          forceNullAppointment ? null : (appointment ?? this.appointment),
    );
  }
}
