import 'dart:collection';

import 'package:equatable/equatable.dart';

/// All the fields that can be used to sort the customers in a list.
enum CustomerSort {
  /// Name.
  name,

  /// Id.
  id,

  /// Country.
  country,

  /// Registered date.
  registered,

  /// Managing Branch.
  managingBranch,
}

/// The available values to filter the KYC expiration date.
enum KYCExpiredFilter {
  /// Allows all, without filtering.
  all,

  /// Allows only customers with valid KYC dates.
  valid,

  /// Allows only customers with expired KYC dates.
  expired,
}

/// Holds the data used to filter a list of customers.
class CustomerFilters extends Equatable {
  /// Allows only the customer with the specified [id] to be returned.
  ///
  /// Not used if empty.
  final String id;

  /// Allows only customers with names that contain [name] to be returned.
  ///
  /// Not used if empty.
  final String name;

  /// Allows only the customer with the specified [username] to be returned.
  ///
  /// Not used if empty.
  final String username;

  /// Allows only the customer that owns the account with the specified
  /// [accountId] to be returned.
  ///
  /// Not used if empty.
  final String accountId;

  /// Allows only customers with the specified [kycExpired] status to be
  /// returned.
  ///
  /// Defaults to [KYCExpiredFilter.all], which returns all values, without
  /// filtering any.
  final KYCExpiredFilter kycExpired;

  /// Allows only customers managed by one of the specified [branchIds] to
  /// be returned.
  ///
  /// Not used if empty.
  final UnmodifiableSetView<String> branchIds;

  /// Allows only customers created after [createdStart] to be returned.
  ///
  /// Not used if null.
  final DateTime? createdStart;

  /// Allows only customers created before [createdEnd] to be returned.
  ///
  /// Not used if null.
  final DateTime? createdEnd;

  /// Creates a new [CustomerFilters].
  CustomerFilters({
    this.id = '',
    this.name = '',
    this.username = '',
    this.accountId = '',
    this.kycExpired = KYCExpiredFilter.all,
    Set<String>? branchIds,
    this.createdStart,
    this.createdEnd,
  }) : branchIds = UnmodifiableSetView(branchIds ?? {});

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        accountId,
        kycExpired,
        branchIds,
        createdStart,
        createdEnd,
      ];

  /// Returns a copy of the filters with select different values.
  ///
  /// If [clearCreatedPeriod] is `true`, clears the [createdStart] and
  /// [createdEnd] properties. Defaults to `false`.
  CustomerFilters copyWith({
    String? id,
    String? name,
    String? username,
    String? accountId,
    KYCExpiredFilter? kycExpired,
    Set<String>? branchIds,
    DateTime? createdStart,
    DateTime? createdEnd,
    bool clearCreatedPeriod = false,
  }) =>
      CustomerFilters(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        accountId: accountId ?? this.accountId,
        kycExpired: kycExpired ?? this.kycExpired,
        branchIds: branchIds ?? this.branchIds,
        createdStart:
            clearCreatedPeriod ? null : (createdStart ?? this.createdStart),
        createdEnd: clearCreatedPeriod ? null : (createdEnd ?? this.createdEnd),
      );
}
