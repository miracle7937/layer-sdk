# Layer SDK

## IMPORTANT - MIGRATION WORK ONLY

This package contains a copy of our current 3 layers (Flutter, Business and Data) just for migration purposes. You should NOT use this package for developing new features, this package should be only used for working on migrating each feature to the new architecture. Here is a link for the documentation for the new architecture:

- [New Layer SDK Architecture](https://outline.ubanquity.io/doc/layer-sdk-architecture-yv9Kg2nglh)

## Breaking changes

- The `CurrencyCubit` does not contain a method for formatting an amount with a currency anymore. Instead, the `AmountFormatter` util class should be used.
- The old loyalty related objects (Loyalty, LoyaltyCubit, etc) were renamed since they are indeed related to the loyalty points feature. Now all the files naming and classes starts with `LoyaltyPoints`. The files that changed where:
  - `Loyalty` -> `LoyaltyPoints`
  - `LoyaltyExchange` -> `LoyaltyPointsExchange`
  - `LoyaltyExpiration` -> `LoyaltyPointsExpiration`
  - `LoyaltyRate` -> `LoyaltyPointsRate`
  - `LoyaltyTransaction` -> `LoyaltyPointsTransaction`
  - `LoyaltyCubit` -> `LoyaltyPointsCubit`
  - `LoyaltyExchangeCubit` -> `LoyaltyPointsExchangeCubit`
  - `LoyaltyTransactionCubit` -> `LoyaltyPointsTransactionCubit`
- The old loyalty repository was divided into 5 separte repositories:
  - `LoyaltyPointsRepository`
  - `LoyaltyPointsExchangeRepository`
  - `LoyaltyPointsExpiration`
  - `LoyaltyPointsRateRepository`
  - `LoyaltyPointsTransactionRepository`
