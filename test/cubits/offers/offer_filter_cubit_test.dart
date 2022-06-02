import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:test/test.dart';

final _defaultCategories = [1, 30, 27];
final _fromDate = DateTime.now().subtract(const Duration(days: 3, hours: 2));
final _toDate = DateTime.now().subtract(const Duration(days: 1, seconds: 30));

final _changedCategories = [999, 12];
final _changedFrom = DateTime.now().subtract(const Duration(days: 2));
final _changedTo = DateTime.now().subtract(const Duration(days: 1));

void main() {
  EquatableConfig.stringify = true;

  blocTest<OfferFilterCubit, OfferFilterState>(
    'starts on empty state',
    build: OfferFilterCubit.new,
    verify: (c) => expect(
      c.state,
      OfferFilterState(),
    ),
  ); // starts on empty state

  blocTest<OfferFilterCubit, OfferFilterState>(
    'clears all filters',
    build: OfferFilterCubit.new,
    seed: () => OfferFilterState(
      categories: _defaultCategories,
      from: _fromDate,
      to: _toDate,
    ),
    act: (c) => c.clearFilters(),
    expect: () => [
      OfferFilterState(),
    ],
  ); // clears all filters

  blocTest<OfferFilterCubit, OfferFilterState>(
    'clears from date',
    build: OfferFilterCubit.new,
    seed: () => OfferFilterState(
      categories: _defaultCategories,
      from: _fromDate,
      to: _toDate,
    ),
    act: (c) => c.clearFromDate(),
    expect: () => [
      OfferFilterState(
        categories: _defaultCategories,
        to: _toDate,
      ),
    ],
  ); // clears from date

  blocTest<OfferFilterCubit, OfferFilterState>(
    'clears to date',
    build: OfferFilterCubit.new,
    seed: () => OfferFilterState(
      categories: _defaultCategories,
      from: _fromDate,
      to: _toDate,
    ),
    act: (c) => c.clearToDate(),
    expect: () => [
      OfferFilterState(
        categories: _defaultCategories,
        from: _fromDate,
      ),
    ],
  ); // clears to date

  blocTest<OfferFilterCubit, OfferFilterState>(
    'changes filters',
    build: OfferFilterCubit.new,
    seed: () => OfferFilterState(
      categories: _defaultCategories,
      from: _fromDate,
      to: _toDate,
    ),
    act: (c) => c.changeFilters(
      categories: _changedCategories,
      from: _changedFrom,
      to: _changedTo,
    ),
    expect: () => [
      OfferFilterState(
        categories: _changedCategories,
        from: _changedFrom,
        to: _changedTo,
      ),
    ],
  ); // changes filters
}
