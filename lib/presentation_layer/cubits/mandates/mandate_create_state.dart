import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

///  The current error status
enum MandateCreateErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Holds MandateCreationCubit
class MandateCreateState extends Equatable {
  /// If the cubit is doing stuff
  final bool busy;

  /// A possible error message
  final String errorMessage;

  /// The error status
  final MandateCreateErrorStatus errorStatus;

  /// The selected account
  final Account? account;

  /// If the user accepted the terms for generating the Mandate file
  final bool hasAccepted;

  /// The customer information
  final Customer? customer;

  /// The PDF file containing a Mandate
  final Uint8List? mandatePDFFile;

  /// Creates a new [MandateCreateState] instance
  const MandateCreateState({
    this.busy = false,
    this.errorMessage = '',
    this.errorStatus = MandateCreateErrorStatus.none,
    this.hasAccepted = false,
    this.account,
    this.customer,
    this.mandatePDFFile,
  });

  @override
  List<Object?> get props {
    return [
      busy,
      errorMessage,
      errorStatus,
      account,
      hasAccepted,
      customer,
      mandatePDFFile,
    ];
  }

  /// Creates a copy of [MandateCreateState]
  MandateCreateState copyWith({
    bool? busy,
    String? errorMessage,
    MandateCreateErrorStatus? errorStatus,
    Account? account,
    bool? hasAccepted,
    Customer? customer,
    Uint8List? mandatePDFFile,
  }) {
    return MandateCreateState(
      busy: busy ?? this.busy,
      errorMessage: errorMessage ?? this.errorMessage,
      errorStatus: errorStatus ?? this.errorStatus,
      account: account ?? this.account,
      hasAccepted: hasAccepted ?? this.hasAccepted,
      customer: customer ?? this.customer,
      mandatePDFFile: mandatePDFFile ?? this.mandatePDFFile,
    );
  }
}
