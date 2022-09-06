import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that maps [InboxReportCategoryDTO]
extension InboxReportMessageDTOMapper on InboxReportMessageDTO {
  /// Maps a [InboxReportMessageDTO] into a [InboxReportMessage]
  InboxReportMessage toInboxReportMessage() {
    return InboxReportMessage(
      reportId: reportId ?? 0,
      messageId: messageId ?? 0,
      files: files?.replaceAll(' ', '').split('') ?? [],
      attachmentUrls: attachmentUrls ?? [],
      sender: sender ?? 0,
      senderType: senderType?.toSenderType() ?? InboxReportSenderType.unknown,
      text: text ?? '',
      tsCreated: tsCreated,
      tsUpdated: tsUpdated,
      read: read,
    );
  }
}

/// Extension that maps [InboxReportMessage]
extension InboxReportMessageMapper on InboxReportMessage {
  /// Maps a [InboxReportMessage] into a [InboxReportMessageDTO]
  InboxReportMessageDTO toInboxReportMessageDTO() {
    return InboxReportMessageDTO(
      reportId: reportId,
      messageId: messageId,
      files: files.join(''),
      attachmentUrls: attachmentUrls,
      sender: sender,
      senderType: senderType.toSenderTypeDTO(),
      text: text,
      tsCreated: tsCreated,
      tsUpdated: tsUpdated,
      read: read,
    );
  }
}

/// Extension that maps [InboxReportSenderTypeDTO]
extension InboxReportSenderTypeDTOMapper on InboxReportSenderTypeDTO {
  /// Maps a [InboxReportSenderTypeDTO] into a [InboxReportSenderType]
  InboxReportSenderType toSenderType() {
    switch (this) {
      case InboxReportSenderTypeDTO.customer:
        return InboxReportSenderType.customer;
      case InboxReportSenderTypeDTO.public:
        return InboxReportSenderType.public;
      case InboxReportSenderTypeDTO.unknown:
        return InboxReportSenderType.unknown;
      default:
        return InboxReportSenderType.unknown;
    }
  }
}

/// Extension that maps [InboxReportSenderType]
extension on InboxReportSenderType {
  /// Maps a [InboxReportSenderType] into a [InboxReportSenderTypeDTO]
  InboxReportSenderTypeDTO toSenderTypeDTO() {
    switch (this) {
      case InboxReportSenderType.customer:
        return InboxReportSenderTypeDTO.customer;
      case InboxReportSenderType.public:
        return InboxReportSenderTypeDTO.public;
      case InboxReportSenderType.unknown:
        return InboxReportSenderTypeDTO.unknown;
      default:
        return InboxReportSenderTypeDTO.unknown;
    }
  }
}
