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
      public: public,
      minPublicVersion: minPublicVersion,
    );

    return experience.copyWith(
      pages: _configureExperience(
        experience,
      ),
    );
  }

  /// Modifies the [Experience]..
  ///
  /// Makes following modifications:
  /// - sorts pages by their [order].
  /// - sorts containers by their [order].
  List<ExperiencePage> _configureExperience(Experience experience) {
    final pages = <ExperiencePage>[];
    for (var page in experience.pages) {
      final containers = page.containers.toList();
      containers.sort((a, b) => a.order.compareTo(b.order));
      pages.add(page.copyWith(containers: containers));
    }
    pages.sort((a, b) => a.order.compareTo(b.order));
    pages.expand((page) => page.containers);

    return pages;
  }
}
