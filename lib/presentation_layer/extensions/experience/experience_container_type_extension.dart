import 'package:logging/logging.dart';

import '../../../domain_layer/models.dart';

/// UI Extensions for the [ExperienceContainerType] class.
extension ExperienceContainerTypeExtension on ExperienceContainerType {
  /// Returns whether the container is visible or not.
  bool isFeatureVisible({required UserPermissions userPermissions}) {
    switch (this) {
      case ExperienceContainerType.campaign:
        return userPermissions.campaign.isFeatureVisible;

      case ExperienceContainerType.appointment:
      case ExperienceContainerType.appointments:
        return userPermissions.appointmentScheduling.isFeatureVisible;

      case ExperienceContainerType.transfer:
      case ExperienceContainerType.instantTransfer:
        return userPermissions.transfer.isFeatureVisible ||
            userPermissions.sendMoney.isFeatureVisible ||
            userPermissions.payment.topUp.isFeatureVisible;

      case ExperienceContainerType.bill:
        return userPermissions.payment.bill.isFeatureVisible;

      case ExperienceContainerType.payment:
        final paymentPermissionData = userPermissions.payment;

        /// We don't take in consideration the top ups since does not
        /// belong to the payments.
        return paymentPermissionData.bill.isFeatureVisible ||
            paymentPermissionData.mandates.isFeatureVisible ||
            paymentPermissionData.billers.isFeatureVisible ||
            paymentPermissionData.settings.isFeatureVisible;

      case ExperienceContainerType.dpa:
        return userPermissions.productRequest.isFeatureVisible;

      case ExperienceContainerType.settings:
        return userPermissions.securitySettings.isFeatureVisible;

      case ExperienceContainerType.forex:
        return userPermissions.currencies.isFeatureVisible;

      case ExperienceContainerType.locateUs:
        return userPermissions.locations.isFeatureVisible;

      case ExperienceContainerType.accounts:
        return userPermissions.info.accounts;

      case ExperienceContainerType.cards:
        return userPermissions.card.isFeatureVisible;

      case ExperienceContainerType.pfm:
        return userPermissions.pfmRules.isFeatureVisible;

      case ExperienceContainerType.inbox:
        return userPermissions.inbox.isFeatureVisible;

      case ExperienceContainerType.chatbot:
        return userPermissions.chatBot.isFeatureVisible;

      default:
        Logger(
          'ExperienceContainerTypeExtension',
        ).severe(
          'Unhandled permission for experience container type -> $this',
        );

        return true;
    }
  }
}
