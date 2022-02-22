import 'package:omegle_clone/enums/engagement_status.dart';

extension StringExtensions on String {
  EngagementStatus get toEngagementStatus {
    switch (this) {
      case 'free':
        return EngagementStatus.free;
      case 'busy':
        return EngagementStatus.busy;
      case 'searching':
        return EngagementStatus.searching;
      default:
        return EngagementStatus.undetermined;
    }
  }
}
