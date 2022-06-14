import 'package:collection/collection.dart';
import '../../../../../domain_layer/models.dart';
import '../../../presentation_layer/extensions.dart';

/// A use case that encapsulates the logic for configuring
/// the experience with user preferences and permissions.
///
/// A callable class.
class ConfigureUserExperienceByExperiencePreferencesUseCase {
  /// Returns [ExperiencePage]s filtered by the user preferred visibility
  /// and his permissions with containers sorted by his preferred order.
  ///
  /// A page is visible if at least one of it's containers is visible.
  // TODO: Filter the containers by user permissions after they are implemented.
  Iterable<ExperiencePage> call({
    required Experience experience,
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
