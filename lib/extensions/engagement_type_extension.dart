import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/enums/engagement_type.dart';

extension EngagementTypeExtension on EngagegmentType {
  String get toRawValue {
    switch (this) {
      case EngagegmentType.chat:
        return 'chat';
      case EngagegmentType.video:
      default:
        return 'video';
    }
  }
}
