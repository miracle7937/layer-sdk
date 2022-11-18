import 'package:collection/collection.dart';
import '../../../../../domain_layer/models.dart';
import '../../../presentation_layer/extensions.dart';

/// A use case that encapsulates the logic for configuring
/// the experience with user preferences and permissions.
///
/// A callable class.
class ConfigureUserExperienceWithPreferencesUseCase {
  /// Whether if the [ExperiencePage]s containers should be filtered by
  /// the [UserPermissions].
  ///
  /// Set this as `false` in case you want to handle the case where the
  /// pages don't have any container with user permissions.
  ///
  /// Default is `true`.
  final bool _shouldFilterExperiencePageContainersByUserPermissions;

  /// Creates a new [ConfigureUserExperienceWithPreferencesUseCase].
  const ConfigureUserExperienceWithPreferencesUseCase({
    bool shouldFilterExperiencePageContainersByUserPermissions = true,
  }) : _shouldFilterExperiencePageContainersByUserPermissions =
            shouldFilterExperiencePageContainersByUserPermissions;

  /// Returns [ExperiencePage]s filtered by the user preferred visibility
  /// and his permissions with containers sorted by his preferred order.
  ///
  /// A page is visible if at least one of it's containers is visible.
  Iterable<ExperiencePage> call({
    required Experience experience,
    UserPermissions? userPermissions,
  }) {
    final preferences = experience.preferences.firstWhereOrNull(
      (preferences) => preferences.experienceId == experience.id,
    );

    final visiblePages = experience.pages.where(
      (page) => page.containers.any(
        (container) {
          final containerPreferences =
              preferences?.forContainerId(container.id.toString());
          return containerPreferences == null ||
              (containerPreferences[
                      ExperienceContainerPreferences.visibilityKey] ??
                  true);
        },
      ),
    );
    final sortedVisiblePages = visiblePages.map(
      (page) => page.copyWith(
        containers: _sortContainers(
          containers: page.containers,
          preferences: preferences,
        ),
      ),
    );

    if (userPermissions != null &&
        _shouldFilterExperiencePageContainersByUserPermissions) {
      final pagesFilteredByPermissions = <ExperiencePage>[];
      for (final page in sortedVisiblePages) {
        final visibleContainers = page.containers
            .where((container) => container.type.isFeatureVisible(
                  userPermissions: userPermissions,
                ))
            .toList();

        if (visibleContainers.isNotEmpty) {
          pagesFilteredByPermissions.add(
            page.copyWith(containers: visibleContainers),
          );
        }
      }

      return pagesFilteredByPermissions;
    }

    return sortedVisiblePages;
  }

  /// Returns a copy of [containers] sorted by the order defined
  /// in the [preferences].
  ///
  /// Containers without a specified order will be placed at the end.
  Iterable<ExperienceContainer> _sortContainers({
    required List<ExperienceContainer> containers,
    required ExperiencePreferences? preferences,
  }) {
    return containers.sortedCopy((c1, c2) {
      final order1 = _preferredOrder(
        containerId: c1.id.toString(),
        preferences: preferences,
      );
      final order2 = _preferredOrder(
        containerId: c2.id.toString(),
        preferences: preferences,
      );
      if (order1 == null) return 1;
      if (order2 == null) return -1;
      return order1.compareTo(order2);
    });
  }

  /// Returns user preferred order for a specific container
  /// from the [preferences].
  ///
  /// Returns null if there are no container preferences for the [containerId]
  /// or they don't contain the order.
  int? _preferredOrder({
    required String containerId,
    ExperiencePreferences? preferences,
  }) {
    final containerPreferences = preferences?.forContainerId(containerId);
    return containerPreferences != null
        ? containerPreferences[ExperienceContainerPreferences.orderKey]
        : null;
  }
}
