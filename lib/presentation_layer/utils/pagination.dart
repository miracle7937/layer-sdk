import 'package:equatable/equatable.dart';

/// A helper widget that keeps the basic data needed for pagination.
class Pagination extends Equatable {
  /// Maximum number of items to load at a time.
  final int limit;

  /// The current offset for the loaded list.
  final int offset;

  /// If there is more data to be loaded.
  final bool canLoadMore;

  /// Creates a new [Pagination] with the default values.
  const Pagination({
    this.limit = 50,
    this.offset = 0,
    this.canLoadMore = false,
  });

  @override
  List<Object?> get props => [
        limit,
        offset,
        canLoadMore,
      ];

  /// Returns `true` if the it's on the first page.
  bool get firstPage => offset == 0;

  /// Returns a new [Pagination] with the updated offset for the new page.
  ///
  /// If [loadMore] is false, then it sets the offset to zero.
  Pagination paginate({
    required bool loadMore,
  }) =>
      copyWith(
        offset: loadMore ? offset + limit : 0,
      );

  /// Returns a new [Pagination] with the updated [canLoadMore], based on
  /// how many items were loaded -- given by the [loadedCount] parameter.
  Pagination refreshCanLoadMore({
    required int loadedCount,
  }) =>
      copyWith(
        canLoadMore: loadedCount >= limit,
      );

  /// Creates a new object based on this one.
  Pagination copyWith({
    int? limit,
    int? offset,
    bool? canLoadMore,
  }) =>
      Pagination(
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        canLoadMore: canLoadMore ?? this.canLoadMore,
      );
}
