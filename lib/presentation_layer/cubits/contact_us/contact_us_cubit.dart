import 'package:bloc/bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../_migration/data_layer/src/helpers/dto_helpers.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that for the contact us
class ContactUsCubit extends Cubit<ContactUsState> {
  final GetExperienceAndConfigureItUseCase _getExperienceAndConfigureItUseCase;
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;

  /// Creates a new cubit [ContactUs] cubit.
  ContactUsCubit({
    required GetExperienceAndConfigureItUseCase
        getExperienceAndConfigureItUseCase,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
  })  : _getExperienceAndConfigureItUseCase =
            getExperienceAndConfigureItUseCase,
        _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        super(ContactUsState());

  /// Loads the contact us data
  Future<void> load({
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
            ],
          ),
          _getExperienceAndConfigureItUseCase(
            public: true,
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
    var items = <ContactUs>[];

    if (_settingsAvailable("facebook_enabled", "facebook_app_id")) {
      var fbPage = getGlobalSettingValue(
        "facebook_app_id",
        "customer_service",
      );
      var fbPageId = getGlobalSettingValue(
            "facebook_page_id",
            "customer_service",
          ) ??
          "";

      items.add(
        ContactUs(
          id: ContactUsType.facebook,
          title: getContainerMessage(message: "facebook_title"),
          subtitle: "https://www.facebook.com/$fbPage",
          androidValue: "fb://page/$fbPageId",
          iosValue: "fb://profile/$fbPageId/",
          actionType: ContactUsActionType.link,
        ),
      );
    }
    if (_settingsAvailable("twitter_enabled", "twitter_app_id")) {
      String? twitterSettings = getGlobalSettingValue(
        "twitter_app_id",
        "customer_service",
      );

      var value = "twitter://user?screen_name=$twitterSettings";

      items.add(
        ContactUs(
          id: ContactUsType.twitter,
          title: getContainerMessage(message: "twitter_title"),
          subtitle: "https://www.twitter.com/$twitterSettings",
          androidValue: value,
          iosValue: value,
          actionType: ContactUsActionType.link,
        ),
      );
    }

    if (_settingsAvailable("email_enabled", "email_address")) {
      String? subTitle = getGlobalSettingValue(
        "email_address",
        "customer_service",
      );

      items.add(
        ContactUs(
          id: ContactUsType.email,
          title: getContainerMessage(message: "email_title"),
          subtitle: subTitle,
          androidValue: "mailto:$subTitle",
          iosValue: "mailto:$subTitle",
          actionType: ContactUsActionType.email,
        ),
      );
    }

    if (_settingsAvailable("complaints_email_enabled", "complaints_email")) {
      String? subTitle = getGlobalSettingValue(
        "complaints_email",
        "customer_service",
      );

      items.add(
        ContactUs(
          id: ContactUsType.complaintsEmail,
          title: getContainerMessage(message: "complaints_email_title"),
          subtitle: subTitle,
          androidValue: "mailto:$subTitle",
          iosValue: "mailto:$subTitle",
          actionType: ContactUsActionType.email,
        ),
      );
    }

    if (_settingsAvailable("linkedin_enabled", "linkedin_app_id")) {
      String? settings = getGlobalSettingValue(
        "linkedin_app_id",
        "customer_service",
      );

      items.add(
        ContactUs(
          id: ContactUsType.linkedin,
          title: getContainerMessage(message: "linkedin_title"),
          subtitle: "https://www.linkedin.com/company/$settings",
          androidValue: "linkedin://$settings",
          iosValue: "linkedin://company/$settings",
          actionType: ContactUsActionType.link,
        ),
      );
    }

    if (_settingsAvailable("instagram_enabled", "instagram_app_id")) {
      String? settings = getGlobalSettingValue(
        "instagram_app_id",
        "customer_service",
      );

      var subTitle = "https://www.instagram.com/$settings";
      var value = "instagram://user?username=$settings";

      items.add(
        ContactUs(
          id: ContactUsType.instagram,
          title: getContainerMessage(message: "instagram_title"),
          subtitle: subTitle,
          androidValue: value,
          iosValue: value,
          actionType: ContactUsActionType.link,
        ),
      );
    }

    if (_settingsAvailable("website_enabled", "website_link")) {
      String? subTitle = getGlobalSettingValue(
        "website_link",
        "customer_service",
      );

      items.add(
        ContactUs(
          id: ContactUsType.website,
          title: getContainerMessage(message: "website_title"),
          subtitle: subTitle,
          androidValue: subTitle,
          iosValue: subTitle,
          actionType: ContactUsActionType.link,
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
        ContactUs(
          id: ContactUsType.local,
          title: getContainerMessage(message: "call_local_number_title"),
          subtitle: subTitle,
          androidValue: "tel:$subTitle",
          iosValue: "tel:$subTitle",
          actionType: ContactUsActionType.phone,
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
        ContactUs(
          id: ContactUsType.international,
          title:
              getContainerMessage(message: "call_international_number_title"),
          subtitle: subTitle,
          androidValue: "tel:$subTitle",
          iosValue: "tel:$subTitle",
          actionType: ContactUsActionType.phone,
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
        ContactUs(
          id: ContactUsType.complaintsNumber,
          title: getContainerMessage(message: "call_complaints_number_title"),
          subtitle: subTitle,
          androidValue: "tel:$subTitle",
          iosValue: "tel:$subTitle",
          actionType: ContactUsActionType.phone,
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
  ExperienceContainer? getContainer() => (state.experience?.pages.firstWhere(
        (pages) => pages.containers.contains(
          pages.containers.firstWhere(
            (container) => container.name == "gr_contact_us",
          ),
        ),
      ))?.containers.firstWhere((element) => element.name == "gr_contact_us");

  bool _settingsAvailable(String containerSettingId, String globalSettingId) {
    return (getContainerSettings()?.firstWhere(
              (element) => element?.setting == containerSettingId,
            ) !=
            null) &&
        (getContainerSettings()?.firstWhere(
              (element) => element?.setting == containerSettingId,
            ) !=
            false) &&
        isNotEmpty(getGlobalSettingValue(globalSettingId, "customer_service"));
  }

  /// Returns the global setting for this code/module
  dynamic getGlobalSettingValue(
    String code,
    String module,
  ) =>
      state.globalSettings
          .firstWhere(
              (element) => element?.code == code && element?.module == module,
              orElse: () => null)
          ?.value;
}
