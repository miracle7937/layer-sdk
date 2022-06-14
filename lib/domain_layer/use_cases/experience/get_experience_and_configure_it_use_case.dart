import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case for getting the user experience and configuring it
/// with the default configuration.
class GetExperienceAndConfigureItUseCase {
  final ExperienceRepositoryInterface _repository;

  /// Creates a new [GetExperienceAndConfigureItUseCase].
  GetExperienceAndConfigureItUseCase({
    required ExperienceRepositoryInterface repository,
  }) : _repository = repository;

  /// Get's the user experience.
  ///
  /// Makes following modifications:
  /// - sorts pages by their [order].
  /// - sorts containers by their [order].
  Future<Experience> call({
    required bool public,
    int? minPublicVersion,
  }) async {
    final experience = await _repository.getExperience(
        public: public, minPublicVersion: minPublicVersion);

    return experience.copyWith(pages: _configureExperience(experience));
  }

  /// Modifies the [Experience]..
  ///
  /// Makes following modifications:
  /// - sorts pages by their [order].
  /// - sorts containers by their [order].
  List<ExperiencePage> _configureExperience(Experience experience) {
    final pages = experience.pages.toList();
    pages.sort((p1, p2) => p1.order.compareTo(p2.order));

    pages.sort((p1, p2) => p1.order.compareTo(p2.order));
    for (var page in pages) {
      page.copyWith(containers: _sortPageContainers(page));
    }
    pages.expand((page) => page.containers);

    return pages;
  }

  /// Sorts containers by their [order].
  ///
  /// Containers without an order value will come first.
  List<ExperienceContainer> _sortPageContainers(ExperiencePage page) {
    final containers = page.containers.toList();
    containers.sort((a, b) => a.order.compareTo(b.order));

    return containers;
  }
}
