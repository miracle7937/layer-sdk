import '../../../domain_layer/models.dart';

/// A abastract repository for the [Experience].
abstract class ExperienceRepositoryInterface {
  /// Fetches [Experience] configured for the application
  /// in the Experience studio.
  ///
  /// The [public] parameter is used to determine whether
  /// a public (pre-login) or after-login experience should be fetched.
  ///
  /// The [minPublicVersion] optional parameter can be used to set
  /// a minimum version of the public experience to fetch.
  /// If there is no experience meeting this criteria
  /// `public_experience_not_found` error will be returned.
  Future<Experience> getExperience({
    required bool public,
    int? minPublicVersion,
  });
}
