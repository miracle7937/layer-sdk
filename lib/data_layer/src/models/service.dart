import 'package:equatable/equatable.dart';

/// Keeps the data of a service
class Service extends Equatable {
  /// The service unique identifier
  final int? serviceId;

  /// The biller id linked to this service
  final String? billerId;

  /// The name of the service
  final String? name;

  /// The billing id tag of the service
  final String? billingIdTag;

  /// The billing id tag help of the service
  final String? billingIdTagHelp;

  /// The billing id description of the service
  final String? billingIdDesc;

  /// Date this service was created.
  final DateTime? created;

  /// Date this service was last updated.
  final DateTime? updated;

  /// Creates a new [Bill]
  Service({
    this.serviceId,
    this.billerId,
    this.name,
    this.billingIdTag,
    this.billingIdTagHelp,
    this.billingIdDesc,
    this.created,
    this.updated,
  });

  @override
  List<Object?> get props => [
        serviceId,
        billerId,
        name,
        billingIdTag,
        billingIdTagHelp,
        billingIdDesc,
        created,
        updated,
      ];

  /// Creates a copy of this service with different values
  Service copyWith({
    int? serviceId,
    String? billerId,
    String? name,
    String? billingIdTag,
    String? billingIdTagHelp,
    String? billingIdDesc,
    DateTime? created,
    DateTime? updated,
  }) =>
      Service(
        serviceId: serviceId ?? this.serviceId,
        billerId: billerId ?? this.billerId,
        name: name ?? this.name,
        billingIdTag: billingIdTag ?? this.billingIdTag,
        billingIdTagHelp: billingIdTagHelp ?? this.billingIdTagHelp,
        billingIdDesc: billingIdDesc ?? this.billingIdDesc,
        created: created ?? this.created,
        updated: updated ?? this.updated,
      );
}
