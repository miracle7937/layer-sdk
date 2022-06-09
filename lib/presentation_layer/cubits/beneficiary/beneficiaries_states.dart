import 'dart:collection';
import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The available error status
enum BeneficiariesErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the Beneficiaries cubit
class BeneficiariesState extends Equatable {
  /// The customer id of the user that has these beneficiaries.
  final String customerID;

  /// A list of Beneficiaries
  final UnmodifiableListView<Beneficiary> beneficiaries;

  /// The current error status.
  final BeneficiariesErrorStatus errorStatus;

  /// True if the cubit is processing something.
  final bool busy;

  /// True if there are more beneficiaries to load
  final bool canLoadMore;

  /// Has all the data needed to handle the list of customers.
  final BeneficiaryListData listData;

  /// Creates a new [BeneficiariesState].
  BeneficiariesState({
    required this.customerID,
    Iterable<Beneficiary> beneficiaries = const <Beneficiary>[],
    this.errorStatus = BeneficiariesErrorStatus.none,
    this.busy = false,
    this.canLoadMore = true,
    this.listData = const BeneficiaryListData(),
  }) : beneficiaries = UnmodifiableListView(beneficiaries);

  @override
  List<Object?> get props => [
        customerID,
        beneficiaries,
        errorStatus,
        busy,
        canLoadMore,
        listData,
      ];

  /// Creates a new state based on this one.
  BeneficiariesState copyWith({
    String? customerID,
    List<Beneficiary>? beneficiaries,
    BeneficiariesErrorStatus? errorStatus,
    bool? busy,
    bool? canLoadMore,
    BeneficiaryListData? listData,
  }) =>
      BeneficiariesState(
        customerID: customerID ?? this.customerID,
        beneficiaries: beneficiaries ?? this.beneficiaries,
        errorStatus: errorStatus ?? this.errorStatus,
        busy: busy ?? this.busy,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        listData: listData ?? this.listData,
      );
}

/// Keeps all the data needed for filtering the customer
class BeneficiaryListData extends Equatable {
  /// If there is more data to be loaded.
  final bool canLoadMore;

  /// The current offset for the loaded list.
  final int offset;

  /// The text used to filter the results.
  final String? searchText;

  /// Creates a new [BeneficiaryListData] with the default values.
  const BeneficiaryListData({
    this.canLoadMore = false,
    this.offset = 0,
    this.searchText,
  });

  @override
  List<Object?> get props => [
        canLoadMore,
        offset,
        searchText,
      ];

  /// Creates a new object based on this one.
  BeneficiaryListData copyWith({
    bool? canLoadMore,
    int? offset,
    String? searchText,
  }) =>
      BeneficiaryListData(
        canLoadMore: canLoadMore ?? this.canLoadMore,
        offset: offset ?? this.offset,
        searchText: searchText ?? this.searchText,
      );
}
