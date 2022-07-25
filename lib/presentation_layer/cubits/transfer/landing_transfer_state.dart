import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import '../../utils.dart';

enum LandingTransferErrorStatus {
  none,
  generic,
  network,
}

class LandingTransferState extends Equatable {
  final bool busy;

  final LandingTransferErrorStatus error;

  final int limit;

  final Pagination pagination;

  final UnmodifiableListView<Transfer> recentTransfers;

  LandingTransferState({
    Iterable<Transfer> recentTransfers = const <Transfer>[],
    this.busy = false,
    this.error = LandingTransferErrorStatus.none,
    this.limit = 50,
    this.pagination = const Pagination(),
  }) : this.recentTransfers = UnmodifiableListView(recentTransfers);

  LandingTransferState copyWith({
    bool? busy,
    LandingTransferErrorStatus? error,
    int? limit,
    Pagination? pagination,
    Iterable<Transfer>? recentTransfers,
  }) {
    return LandingTransferState(
      busy: busy ?? this.busy,
      error: error ?? this.error,
      limit: limit ?? this.limit,
      pagination: pagination ?? this.pagination,
      recentTransfers: recentTransfers ?? this.recentTransfers,
    );
  }

  @override
  List<Object?> get props => [busy, error, limit, pagination, recentTransfers];
}
