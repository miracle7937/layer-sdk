import '../../helpers.dart';

/// Enum that holds what is the category of a report
class InboxReportCategoryDTO extends EnumDTO {
  const InboxReportCategoryDTO._internal(String value) : super.internal(value);

  /// AppointmentReview category
  static const appointmentReview =
      InboxReportCategoryDTO._internal('appointment_review');

  /// Article feedback category
  static const articleFeedback =
      InboxReportCategoryDTO._internal('article_feedback');

  /// Offer inquiry category
  static const offerInquiry = InboxReportCategoryDTO._internal('offer_inquiry');

  /// Product inquiry category
  static const productInquiry =
      InboxReportCategoryDTO._internal('product_inquiry');

  /// General Comments category
  static const generalComments =
      InboxReportCategoryDTO._internal('general_comments');

  /// App issue category
  static const appIssue = InboxReportCategoryDTO._internal('app_issue');

  /// Other category
  static const other = InboxReportCategoryDTO._internal('other');

  /// A list containing all possible categories
  static const List<InboxReportCategoryDTO> values = [
    appointmentReview,
    articleFeedback,
    offerInquiry,
    productInquiry,
    generalComments,
    appIssue,
    other,
  ];

  /// Return a [InboxReportCategoryDTO] based on a string
  static InboxReportCategoryDTO fromRaw(String? value) {
    return values.firstWhere((it) => it.value == value);
  }
}
