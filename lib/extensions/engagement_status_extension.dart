import 'package:omegle_clone/enums/engagement_status.dart';

extension EngagementStatusExtension on EngagementStatus {
  String get toRawValue {
    switch (this) {
      case EngagementStatus.free:
        return 'free';
      case EngagementStatus.busy:
        return 'busy';
      case EngagementStatus.searching:
        return 'searching';
      default:
        return 'undetermined';
    }
  }
}
