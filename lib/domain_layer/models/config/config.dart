import 'package:equatable/equatable.dart';

/// Holds the data used for the configuration of the app.
class Config extends Equatable {
  ///Used to show/hide the customers tab
  final bool showCustomersTab;

  /// Whether or not E-Statement is enabled on this environment.
  final bool eStatementEnabled;

  /// The internal services' URLs.
  /// These URLs will be used when redirecting a request to the maker/checker flow
  final InternalServices internalServices;

  /// Graphana URL
  final String graphanaUrl;

  /// Creates a new [ConfigDTO].
  const Config({
    this.showCustomersTab = false,
    this.eStatementEnabled = false,
    this.internalServices = const InternalServices(
      infobanking: '',
    ),
    this.graphanaUrl = '',
  });

  @override
  List<Object> get props => [
        showCustomersTab,
        internalServices,
        graphanaUrl,
        eStatementEnabled,
      ];

  /// Creates a new [Config] based on this one.
  Config copyWith({
    bool? showCustomersTab,
    bool? eStatementEnabled,
    InternalServices? internalServices,
    String? graphanaUrl,
  }) =>
      Config(
        showCustomersTab: showCustomersTab ?? this.showCustomersTab,
        internalServices: internalServices ?? this.internalServices,
        graphanaUrl: graphanaUrl ?? this.graphanaUrl,
        eStatementEnabled: eStatementEnabled ?? this.eStatementEnabled,
      );
}

/// Holds the internal services' URLs
class InternalServices extends Equatable {
  /// The infobanking service internal URL
  final String infobanking;

  /// The customer-aaa service internal URL
  final String authCustomer;

  /// The txnbanking service internal URL
  final String txnbanking;

  /// Creates a new [InternalServices].
  const InternalServices({
    this.infobanking = '',
    this.authCustomer = '',
    this.txnbanking = '',
  });

  @override
  List<Object?> get props => [
        infobanking,
        authCustomer,
        txnbanking,
      ];

  /// Creates a new [InternalServices] based on this one.
  InternalServices copyWith({
    String? infobanking,
    String? authCustomer,
    String? txnbanking,
  }) =>
      InternalServices(
        infobanking: infobanking ?? this.infobanking,
        authCustomer: authCustomer ?? this.authCustomer,
        txnbanking: txnbanking ?? this.txnbanking,
      );
}
