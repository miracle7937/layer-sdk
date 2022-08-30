import 'dart:collection';

import 'package:equatable/equatable.dart';

/// Model used for the errors.
class ReceiptError extends Equatable {
  /// The action.
  final ReceiptAction action;

  /// The error.
  final ReceiptErrorStatus errorStatus;

  /// The error code.
  final String? code;

  /// The error message.
  final String? message;

  /// Creates a new [ReceiptError].
  const ReceiptError({
    required this.action,
    required this.errorStatus,
    this.code,
    this.message,
  });

  @override
  List<Object?> get props => [
        action,
        errorStatus,
        code,
        message,
      ];
}

/// The available error status
enum ReceiptErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the Receipt cubit
class ReceiptState extends Equatable {
  /// List of bytes representing receipt pdf
  final UnmodifiableListView<int> pdfBytes;

  /// List of bytes representing receipt image
  final UnmodifiableListView<int> imageBytes;

  /// The errors.
  final UnmodifiableSetView<ReceiptError> errors;

  /// The action that the cubit is performing.
  final ReceiptAction action;

  /// Creates a new [ReceiptState].
  ReceiptState({
    List<int> pdfBytes = const [],
    List<int> imageBytes = const [],
    this.action = ReceiptAction.none,
    Set<ReceiptError> errors = const <ReceiptError>{},
  })  : pdfBytes = UnmodifiableListView(pdfBytes),
        imageBytes = UnmodifiableListView(imageBytes),
        errors = UnmodifiableSetView(errors);

  @override
  List<Object?> get props => [
        pdfBytes,
        imageBytes,
        errors,
        action,
      ];

  /// Creates a new state based on this one.
  ReceiptState copyWith({
    List<int>? pdfBytes,
    List<int>? imageBytes,
    ReceiptAction? action,
    Set<ReceiptError>? errors,
  }) =>
      ReceiptState(
        pdfBytes: pdfBytes ?? this.pdfBytes,
        imageBytes: imageBytes ?? this.imageBytes,
        errors: errors ?? this.errors,
        action: action ?? this.action,
      );
}

/// All possible actions.
enum ReceiptAction {
  /// No action.
  none,

  /// The PDF receipt is being loaded
  receiptPdf,

  /// The image receipt is being loaded
  receiptImage,
}
