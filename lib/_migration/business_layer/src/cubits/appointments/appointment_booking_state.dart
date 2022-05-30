import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

import '../../../../data_layer/data_layer.dart';

/// Enum that indicates possible errors
enum AppointmentBookingStateError {
  /// No errors
  none,

  /// NetException
  network,

  /// Any other exception
  generic,
}

/// Enum that indicates if is loading the available timeslots
enum AppointmentFreeTimeStatus {
  /// is loading timeslots
  loading,

  /// is done loading
  done,

  /// Error
  error,
}

/// State of the AppointmentBooking cubit
/// Which holdes data for a [Branch], a list of [Product]
/// the date where the user will be attended
/// the available time slots
@immutable
class AppointmentBookingState extends Equatable {
  /// If the cubit is awaiting for a response
  final bool busy;

  /// If the cubit is loading the available timeslots
  final AppointmentFreeTimeStatus? freeTimeStatus;

  /// The error message
  final String? errorMessage;

  /// The occured error
  final AppointmentBookingStateError? error;

  /// A list of all selected products
  final UnmodifiableListView<Product> products;

  /// The branch where the user will be attended
  final Branch? branch;

  /// All available timeslots
  final UnmodifiableListView<BranchTimeSlot> timeSlots;

  /// The selected timeslot
  final BranchTimeSlot? selectedTimeSlot;

  /// Select date
  final DateTime? selectedDate;

  /// Appointments notes
  final String notes;

  /// Appointment Id
  final String? appointmentId;

  /// Creates a new instance of [AppointmentBookingState]
  AppointmentBookingState({
    Iterable<BranchTimeSlot> timeSlots = const <BranchTimeSlot>[],
    Iterable<Product> products = const <Product>[],
    this.freeTimeStatus = AppointmentFreeTimeStatus.done,
    this.errorMessage = '',
    this.error = AppointmentBookingStateError.none,
    this.busy = false,
    this.selectedTimeSlot,
    this.notes = '',
    this.branch,
    this.selectedDate,
    this.appointmentId,
  })  : timeSlots = UnmodifiableListView(timeSlots),
        products = UnmodifiableListView(products);

  @override
  List<Object?> get props {
    return [
      busy,
      freeTimeStatus,
      errorMessage,
      error,
      products,
      branch,
      timeSlots,
      selectedTimeSlot,
      selectedDate,
      appointmentId,
      notes,
    ];
  }

  /// Creates a new instance of [AppointmentBookingState]
  AppointmentBookingState copyWith({
    bool? busy,
    AppointmentFreeTimeStatus? freeTimeStatus,
    String? errorMessage,
    AppointmentBookingStateError? error,
    Iterable<Product>? products,
    Branch? branch,
    BranchTimeSlot? selectedTimeSlot,
    DateTime? selectedDate,
    String? notes,
    String? appointmentId,
    Iterable<BranchTimeSlot>? timeSlots,
    bool forceNullTimeslot = false,
  }) {
    return AppointmentBookingState(
      busy: busy ?? this.busy,
      freeTimeStatus: freeTimeStatus ?? this.freeTimeStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      error: error ?? this.error,
      products: products ?? this.products,
      branch: branch ?? this.branch,
      timeSlots: timeSlots ?? this.timeSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      appointmentId: appointmentId ?? this.appointmentId,
      notes: notes ?? this.notes,
      selectedTimeSlot: forceNullTimeslot
          ? null
          : (selectedTimeSlot ?? this.selectedTimeSlot),
    );
  }

  /// If all data is being set as it should
  bool get canSubmit => [
        products.isNotEmpty,
        branch != null,
        selectedDate != null,
        selectedTimeSlot != null,
      ].every((it) => it == true);
}
