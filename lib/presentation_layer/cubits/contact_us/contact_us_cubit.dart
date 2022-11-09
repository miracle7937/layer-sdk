import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import '../../../../domain_layer/models.dart';
import '../../../_migration/data_layer/src/helpers/dto_helpers.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that for the contact us
class ContactUsCubit extends Cubit<ContactUsState> {
  final GetExperienceAndConfigureItUseCase _getExperienceAndConfigureItUseCase;
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;
  final OpenLinkUseCase _openLinkUseCase;

  /// Creates a new cubit [ContactUsItem]  cubit.
  ContactUsCubit({
    required GetExperienceAndConfigureItUseCase
        getExperienceAndConfigureItUseCase,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
    required OpenLinkUseCase openLinkUseCase,
  })  : _getExperienceAndConfigureItUseCase =
            getExperienceAndConfigureItUseCase,
        _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        _openLinkUseCase = openLinkUseCase,
        super(ContactUsState());

  /// Loads the contact us data
  /// Container data is fetched from public experience
  /// if [publicExperience] value is true
  Future<void> load({
    bool publicExperience = true,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({ContactUsBusyAction.load}),
        error: ContactUsErrorStatus.none,
      ),
    );

    try {
      final responses = await Future.wait(
        [
          _loadGlobalSettingsUseCase(
            codes: [
              'facebook_enabled',
              'facebook_app_id',
              'facebook_page_id',
              'twitter_enabled',
              'twitter_app_id',
              'email_enabled',
              'email_address',
              'complaints_email_enabled',
              'complaints_email',
              'linkedin_enabled',
              'linkedin_app_id',
              'instagram_enabled',
              'instagram_app_id',
              'website_enabled',
              'website_link',
              'call_local_number_enabled',
              'call_center_national',
              'call_international_number_enabled',
              'call_center_international',
              'call_complaints_number_enabled',
              'whatsapp_enabled',
              'whatsapp_link',
            ],
          ),
          _getExperienceAndConfigureItUseCase(
            public: publicExperience,
          )
        ],
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({ContactUsBusyAction.load}),
          globalSettings: responses[0] as List<GlobalSetting>,
          experience: responses[1] as Experience,
        ),
      );

      _setupContactUsItems();
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({ContactUsBusyAction.load}),
          error: ContactUsErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }

  void _setupContactUsItems() {
    var items = <ContactUsItem>[];

    if (_settingsAvailable("facebook_enabled", "facebook_app_id")) {
      var fbPage = getGlobalSettingValue(
        "facebook_app_id",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.facebook,
          title: getContainerMessage(message: "facebook_title"),
          subtitle: "https://www.facebook.com/$fbPage",
          onTap: () => _openLinkUseCase.openFacebookProfile(
            facebookPageId: fbPage,
          ),
        ),
      );
    }
    if (_settingsAvailable("twitter_enabled", "twitter_app_id")) {
      String? twitterSettings = getGlobalSettingValue(
        "twitter_app_id",
        "customer_service",
      );

      var link = "twitter://user?screen_name=$twitterSettings";

      items.add(
        ContactUsItem(
          type: ContactUsType.twitter,
          title: getContainerMessage(message: "twitter_title"),
          subtitle: "https://www.twitter.com/$twitterSettings",
          onTap: () => _openLinkUseCase.openLink(
            link: link,
            url: "https://www.twitter.com/$twitterSettings",
          ),
        ),
      );
    }

    if (_settingsAvailable("email_enabled", "email_address")) {
      String? subTitle = getGlobalSettingValue(
        "email_address",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.email,
          title: getContainerMessage(message: "email_title"),
          subtitle: subTitle,
          onTap: () => _openLinkUseCase.openLink(
            link: "mailto:$subTitle",
            url: subTitle ?? "",
          ),
        ),
      );
    }

    if (_settingsAvailable("complaints_email_enabled", "complaints_email")) {
      String? subTitle = getGlobalSettingValue(
        "complaints_email",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.complaintsEmail,
          title: getContainerMessage(message: "complaints_email_title"),
          subtitle: subTitle,
          onTap: () => _openLinkUseCase.openLink(
            link: "mailto:$subTitle",
            url: subTitle ?? "",
          ),
        ),
      );
    }

    if (_settingsAvailable("linkedin_enabled", "linkedin_app_id")) {
      String? settings = getGlobalSettingValue(
        "linkedin_app_id",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.linkedin,
          title: getContainerMessage(message: "linkedin_title"),
          subtitle: "https://www.linkedin.com/company/$settings",
          onTap: () => _openLinkUseCase.openLinkedIn(
            username: settings ?? "",
          ),
        ),
      );
    }

    if (_settingsAvailable("instagram_enabled", "instagram_app_id")) {
      String? settings = getGlobalSettingValue(
        "instagram_app_id",
        "customer_service",
      );

      var subTitle = "https://www.instagram.com/$settings";
      var link = "instagram://user?username=$settings";

      items.add(
        ContactUsItem(
          type: ContactUsType.instagram,
          title: getContainerMessage(message: "instagram_title"),
          subtitle: subTitle,
          onTap: () => _openLinkUseCase.openLink(
            link: link,
            url: subTitle,
          ),
        ),
      );
    }

    if (_settingsAvailable("website_enabled", "website_link")) {
      String? subTitle = getGlobalSettingValue(
        "website_link",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.website,
          title: getContainerMessage(message: "website_title"),
          subtitle: subTitle,
          onTap: () => _openLinkUseCase.openLink(
            link: subTitle ?? "",
            url: subTitle ?? "",
          ),
        ),
      );
    }

    if (_settingsAvailable(
        "call_local_number_enabled", "call_center_national")) {
      String? subTitle = getGlobalSettingValue(
        "call_center_national",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.local,
          title: getContainerMessage(message: "call_local_number_title"),
          subtitle: subTitle,
          onTap: () => _openLinkUseCase.openLink(
            link: "tel:$subTitle",
            url: subTitle ?? "",
          ),
        ),
      );
    }

    if (_settingsAvailable(
        "call_international_number_enabled", "call_center_international")) {
      String? subTitle = getGlobalSettingValue(
        "call_center_international",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.international,
          title:
              getContainerMessage(message: "call_international_number_title"),
          subtitle: subTitle,
          onTap: () => _openLinkUseCase.openLink(
            link: "tel:$subTitle",
            url: subTitle ?? "",
          ),
        ),
      );
    }

    if (_settingsAvailable("whatsapp_enabled", "whatsapp_link")) {
      String? subTitle = getGlobalSettingValue(
        "whatsapp_link",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.whatsapp,
          title: getContainerMessage(message: "whatsapp_title"),
          subtitle: subTitle,
          onTap: () => _openLinkUseCase.openLink(
            link: "https://wa.me/$subTitle",
            url: "https://wa.me/$subTitle",
          ),
        ),
      );
    }

    if (_settingsAvailable(
        "call_complaints_number_enabled", "complaints_phone")) {
      String? subTitle = getGlobalSettingValue(
        "complaints_phone",
        "customer_service",
      );

      items.add(
        ContactUsItem(
          type: ContactUsType.complaintsNumber,
          title: getContainerMessage(message: "call_complaints_number_title"),
          subtitle: subTitle,
          onTap: () => _openLinkUseCase.openLink(
            link: "tel:$subTitle",
            url: subTitle ?? "",
          ),
        ),
      );
    }
    emit(state.copyWith(contactUsList: items));
  }

  /// Returns the container settings
  List<ExperienceSetting?>? getContainerSettings() {
    return getContainer()?.settings.toList();
  }

  /// Returns the container message
  String? getContainerMessage({required String message}) {
    return getContainer()?.messages[message];
  }

  /// Returns the contact us container
  ExperienceContainer? getContainer() =>
      (state.experience?.pages.firstWhereOrNull(
        (pages) => pages.containers.contains(
          pages.containers.firstWhereOrNull(
            (container) => container.name == "gr_contact_us",
          ),
        ),
      ))
          ?.containers
          .firstWhereOrNull((element) => element.name == "gr_contact_us");

  bool _settingsAvailable(String containerSettingId, String globalSettingId) {
    return (getContainerSettings()
                ?.firstWhereOrNull(
                  (element) => element?.setting == containerSettingId,
                )
                ?.value ??
            false) &&
        isNotEmpty(getGlobalSettingValue(globalSettingId, "customer_service"));
  }

  /// Returns the global setting for this code/module
  dynamic getGlobalSettingValue(
    String code,
    String module,
  ) =>
      state.globalSettings
          .firstWhereOrNull(
              (element) => element?.code == code && element?.module == module)
          ?.value;
}
