import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that maps [InboxReportDTO]
extension InboxReportDTOMapper on InboxReportDTO {
  /// Maps a [InboxReportDTO] into a [InboxReport]
  InboxReport toInboxReport() {
    return InboxReport(
      id: id ?? 0,
      customerID: customerID ?? '',
      username: username ?? '',
      deviceID: deviceID ?? 0,
      description: description ?? '',
      deviceInfo: deviceInfo ?? '',
      status: status?.toReportStatus() ?? InboxReportStatus.unknown,
      category: category?.toReportCategory() ?? InboxReportCategory.other,
      osVersion: osVersion ?? '',
      privateNote: privateNote ?? '',
      assignee: assignee ?? '',
      assigneeFirstName: assigneeFirstName ?? '',
      assigneeLastName: assigneeLastName ?? '',
      categoryName: categoryName ?? '',
      read: read ?? false,
      messages: messages?.map((m) => m.toInboxReportMessage()).toList() ?? [],
      files: files ?? [],
      tsCreated: tsCreated,
      tsUpdated: tsUpdated,
      extra: extra,
    );
  }
}

/// Extension that maps [InboxReport]
extension InboxReportMapper on InboxReport {
  /// Maps a [InboxReport] into a [InboxReportDTO]
  InboxReportDTO toInboxReportDTO() {
    return InboxReportDTO(
      id: id,
      customerID: customerID,
      username: username,
      deviceID: deviceID,
      description: description,
      deviceInfo: deviceInfo,
      status: status.toReportStatusDTO(),
      category: category.toReportCategoryDTO(),
      osVersion: osVersion,
      privateNote: privateNote,
      assignee: assignee,
      assigneeFirstName: assigneeFirstName,
      assigneeLastName: assigneeLastName,
      categoryName: categoryName,
      read: read,
      messages: messages
          .map<InboxReportMessageDTO>((m) => m.toInboxReportMessageDTO())
          .toList(),
      files: files,
      tsCreated: tsCreated,
      tsUpdated: tsUpdated,
      extra: extra,
    );
  }
}

/// Extension that maps [InboxReportCategoryDTO]
extension InboxReportCategoryDTOMapper on InboxReportCategoryDTO {
  /// Maps a [InboxReportCategoryDTO] into a [InboxReportCategory]
  InboxReportCategory toInboxReportCategory() {
    switch (this) {
      case InboxReportCategoryDTO.appointmentReview:
        return InboxReportCategory.appointmentReview;
      case InboxReportCategoryDTO.articleFeedback:
        return InboxReportCategory.articleFeedback;
      case InboxReportCategoryDTO.offerInquiry:
        return InboxReportCategory.offerInquiry;
      case InboxReportCategoryDTO.productInquiry:
        return InboxReportCategory.productInquiry;
      case InboxReportCategoryDTO.generalComments:
        return InboxReportCategory.generalComments;
      case InboxReportCategoryDTO.appIssue:
        return InboxReportCategory.appIssue;
      case InboxReportCategoryDTO.other:
        return InboxReportCategory.other;
      default:
        return InboxReportCategory.other;
    }
  }
}

/// Extension that maps [InboxReportStatusDTO]
extension InboxReportStatusDTOMapper on InboxReportStatusDTO {
  /// Maps a [InboxReportStatusDTO] into a [InboxReportStatus]
  InboxReportStatus toReportStatus() {
    switch (this) {
      case InboxReportStatusDTO.deleted:
        return InboxReportStatus.deleted;
      case InboxReportStatusDTO.closed:
        return InboxReportStatus.closed;
      case InboxReportStatusDTO.unknown:
        return InboxReportStatus.unknown;
      default:
        return InboxReportStatus.unknown;
    }
  }
}

/// Extension that maps [InboxReportStatus]
extension on InboxReportStatus {
  /// Maps a [InboxReportStatus] into a [InboxReportStatusDTO]
  InboxReportStatusDTO toReportStatusDTO() {
    switch (this) {
      case InboxReportStatus.deleted:
        return InboxReportStatusDTO.deleted;
      case InboxReportStatus.closed:
        return InboxReportStatusDTO.closed;
      case InboxReportStatus.unknown:
        return InboxReportStatusDTO.unknown;
      default:
        return InboxReportStatusDTO.unknown;
    }
  }
}

/// Extension that maps [InboxReportCategory]
extension InboxReportCategoryMapper on InboxReportCategoryDTO {
  /// Maps a [InboxReportCategory] into a [InboxReportStatus]
  InboxReportCategory toReportCategory() {
    switch (this) {
      case InboxReportCategoryDTO.appointmentReview:
        return InboxReportCategory.appointmentReview;

      case InboxReportCategoryDTO.articleFeedback:
        return InboxReportCategory.articleFeedback;

      case InboxReportCategoryDTO.offerInquiry:
        return InboxReportCategory.offerInquiry;

      case InboxReportCategoryDTO.productInquiry:
        return InboxReportCategory.productInquiry;

      case InboxReportCategoryDTO.generalComments:
        return InboxReportCategory.generalComments;

      case InboxReportCategoryDTO.appIssue:
        return InboxReportCategory.appIssue;

      case InboxReportCategoryDTO.other:
        return InboxReportCategory.other;

      default:
        return InboxReportCategory.other;
    }
  }
}

/// Extension that maps [InboxReportCategoryDTO]
extension on InboxReportCategory {
  /// Maps a [InboxReportCategory] into a [InboxReportCategoryDTO]
  InboxReportCategoryDTO toReportCategoryDTO() {
    switch (this) {
      case InboxReportCategory.appointmentReview:
        return InboxReportCategoryDTO.appointmentReview;

      case InboxReportCategory.articleFeedback:
        return InboxReportCategoryDTO.articleFeedback;

      case InboxReportCategory.offerInquiry:
        return InboxReportCategoryDTO.offerInquiry;

      case InboxReportCategory.productInquiry:
        return InboxReportCategoryDTO.productInquiry;

      case InboxReportCategory.generalComments:
        return InboxReportCategoryDTO.generalComments;

      case InboxReportCategory.appIssue:
        return InboxReportCategoryDTO.appIssue;

      case InboxReportCategory.other:
        return InboxReportCategoryDTO.other;

      default:
        return InboxReportCategoryDTO.other;
    }
  }
}
