/// Holds the data used for the configuration of the app.
class ConfigDTO {
  ///Used to show/hide the customers tab
  final bool? showCustomersTab;

  /// Whether or not the E-Statement is available in this environment.
  final bool? eStatementEnabled;

  /// The internal services' URLs
  final InternalServicesDTO? internalServices;

  /// Graphana URL
  final String? graphanaUrl;

  /// Creates a new [ConfigDTO].
  ConfigDTO({
    this.showCustomersTab = false,
    this.eStatementEnabled = false,
    this.internalServices,
    this.graphanaUrl,
  });

  /// Creates a [ConfigDTO] from a JSON
  factory ConfigDTO.fromJson(Map<String, dynamic> json) => ConfigDTO(
        showCustomersTab: json['SHOW_CUSTOMERS_TAB'],
        eStatementEnabled: json['E_STATEMENT_FLAG_ENABLED'],
        internalServices: InternalServicesDTO.fromJson(json['API_INTERNAL']),
        graphanaUrl: json['UUID_URL'],
      );
}

/// Holds the provider data for the internal services' URLs
class InternalServicesDTO {
  /// The infobanking service internal URL
  final String? infobanking;

  /// The customer-aaa service internal URL
  final String? authCustomer;

  /// Creates a new [InternalServicesDTO]
  InternalServicesDTO({
    this.infobanking = '',
    this.authCustomer = '',
  });

  /// Creates a [InternalServicesDTO] from a JSON
  factory InternalServicesDTO.fromJson(Map<String, dynamic> json) =>
      InternalServicesDTO(
        infobanking: json['INFOBANKING'],
        authCustomer: json['AUTH_CUSTOMER'],
      );
}
