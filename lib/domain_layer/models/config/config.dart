import 'package:equatable/equatable.dart';

/// Holds the data used for the configuration of the app.
class Config extends Equatable {
  ///Used to show/hide the customers tab
  final bool showCustomersTab;

  /// The internal services' URLs.
  /// These URLs will be used when redirecting a request to the maker/checker flow
  final InternalServices internalServices;

  /// Graphana URL
  final String graphanaUrl;

  /// Creates a new [ConfigDTO].
  const Config({
    this.showCustomersTab = false,
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
      ];

  /// Creates a new [Config] based on this one.
  Config copyWith({
    bool? showCustomersTab,
    InternalServices? internalServices,
    String? graphanaUrl,
  }) =>
      Config(
        showCustomersTab: showCustomersTab ?? this.showCustomersTab,
        internalServices: internalServices ?? this.internalServices,
        graphanaUrl: graphanaUrl ?? this.graphanaUrl,
      );
}

/// Holds the internal services' URLs
class InternalServices extends Equatable {
  /// The infobanking service internal URL
  final String infobanking;

  /// The customer-aaa service internal URL
  final String authCustomer;

  /// Creates a new [InternalServices].
  const InternalServices({
    this.infobanking = '',
    this.authCustomer = '',
  });

  @override
  List<Object?> get props => [
        infobanking,
        authCustomer,
      ];

  /// Creates a new [InternalServices] based on this one.
  InternalServices copyWith({
    String? infobanking,
    String? authCustomer,
  }) =>
      InternalServices(
        infobanking: infobanking ?? this.infobanking,
        authCustomer: authCustomer ?? this.authCustomer,
      );
}
