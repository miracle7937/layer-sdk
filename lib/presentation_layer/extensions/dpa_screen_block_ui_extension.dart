import '../../features/dpa.dart';

/// Extension that provides helper methods to [DPAScreenBlock].
extension DPAScreenBlockUIExtension on DPAScreenBlock {
  /// Returns whether or not a screen type should be blocked by stepping forward
  /// in the DPA process.
  bool shouldBlock(DPAScreenType? type) {
    if (type == null) return false;

    switch (this) {
      case DPAScreenBlock.none:
        return false;

      case DPAScreenBlock.email:
        return type == DPAScreenType.email;
    }
  }
}
