# 0.0.6

- Added the meawallet plugin.

## 0.0.5

\* BREAKING CHANGE \*

- The `FirebaseAnalyticsObserver` is no longer added by default to the `navigatorObservers` of the `MaterialApp`. The apps that require it to be added should specify `firebaseAnalyticsEnabled: true` in their `AppConfiguration` instance.

## 0.0.4

- The firebase libraries was upgraded to newer versions.

## 0.0.3

\* BREAKING CHANGE \*

- The `onError` callback on the `DPAFlow` was modified. Now it returns also the `errorMessage`.
- The `upload` method on the `DPARepository` now throws the exception back to the `DPAProcessCubit`.

## 0.0.2

\* BREAKING CHANGE \*

- `builder` parameter in the `BankApp` widget now includes the navigator key.
- the `child` parameter in the `builder` is no longer optional.

## 0.0.1

- Initial release
