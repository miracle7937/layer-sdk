import '../../abstract_repositories.dart';
import '../../models.dart';

/// Mark a report as read
class MarkReportAsReadUseCase {
  final InboxRepositoryInterface _inboxRepository;

  /// Creates a new instance of [MarkReportAsReadUseCase]
  MarkReportAsReadUseCase(this._inboxRepository);

  /// Mark a [InboxReport] as read
  Future<bool> call(InboxReport report) async {
    return await _inboxRepository.markReportAsRead(report);
  }
}
