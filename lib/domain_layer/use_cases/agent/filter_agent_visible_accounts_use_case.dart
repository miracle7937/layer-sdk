import 'package:collection/collection.dart';

import '../../models.dart';

/// Use Case that filters the list of [Account]s a Agent can see.
class FilterAgentVisibleAccountsUseCase {
  /// Creates a new [FilterAgentVisibleAccountsUseCase] instance.
  const FilterAgentVisibleAccountsUseCase();

  /// Filters the list of [Account]s a Agent can see.
  List<Account> call({
    required List<AgentACL> acls,
    required List<Account> accounts,
  }) =>
      acls
          .map((acl) => accounts.firstWhereOrNull(
                (e) => e.id == acl.accountId,
              ))
          .whereNotNull()
          .toList();
}
