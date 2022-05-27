/// A [CubitCreator] is normally provided on the top of the tree, where you
/// have access to providers and repositories, and serves to create a new cubit
/// somewhere down the tree where you won't have access to the data layer.
///
/// This is an interface that for now doesn't do anything, but that must be
/// implemented by all [CubitCreator]s. This way, you can use [CreatorProvider]
/// ou [MultiCreatorProvider] on top of the tree to provide the creator for the
/// subtree.
///
/// Having the creator provided on top of the tree, you just have to get
/// it from the provider and call the methods to create the cubit you need
/// on your subtree.
///
/// Example of how to implement a [CubitCreator].
///
/// ```dart
/// class DeviceSessionCreator implements CubitCreator {
///   final DeviceSessionRepository _repository;
///
///   const DeviceSessionCreator({
///     Key key,
///     @required DeviceSessionRepository deviceSessionRepository,
///   })  : assert(deviceSessionRepository != null),
///         _repository = deviceSessionRepository;
///
///   DeviceSessionCubit create({
///     @required String customerId,
///     @required CustomerType customerType,
///   }) {
///     assert(customerId != null);
///     assert(customerType != null);
///
///     return DeviceSessionCubit(
///       repository: _repository,
///       customerId: customerId,
///       customerType: customerType,
///     )..load(forceRefresh: true);
///   }
/// }
/// ```
///
/// This example only creates one cubit, but you can have one creator that
/// supplies all different cubits that one feature provides -- each on their
/// own method.
abstract class CubitCreator {}
