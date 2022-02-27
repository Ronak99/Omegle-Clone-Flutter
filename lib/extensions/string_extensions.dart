import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/enums/engagement_type.dart';

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

  EngagegmentType get toEngagementType {
    switch (this) {
      case 'chat':
        return EngagegmentType.chat;
      case 'video':
      default:
        return EngagegmentType.video;
    }
  }
}
