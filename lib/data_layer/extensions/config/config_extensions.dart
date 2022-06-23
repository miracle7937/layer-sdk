import '../../../domain_layer/models.dart';

/// Extensions on the [Config] model.
extension ConfigExtensions on Config? {
  /// Returns the graphana url for the passed Audit object.
  String getGraphanaURLFromAudit(Audit audit) {
    var url = '${this?.graphanaUrl}&var-uuid=${audit.uuid}';

    final eventDate = audit.created;
    if (eventDate != null) {
      final from = eventDate.millisecondsSinceEpoch - 5 * 60000;
      final to = eventDate.millisecondsSinceEpoch + 5 * 60000;

      url = '$url&from=$from&to=$to';
    }

    return url;
  }
}
