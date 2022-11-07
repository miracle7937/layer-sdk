/// DTO used to send a new report creation request
class InboxNewReportDTO {
  /// The InboxReport description
  final String description;

  /// The id of the report category
  final String categoryId;

  /// [InboxNewReportDTO] constructor
  InboxNewReportDTO({
    required this.description,
    required this.categoryId,
  });

  /// Generates a json object
  Map<String, Object> toJson() {
    return <String, Object>{
      'text': description,
      'report': {
        'category': categoryId,
      }
    };
  }
}
