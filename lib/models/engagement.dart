import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/enums/engagement_type.dart';

class Engagement {
  String uid;
  String engagementStatus;
  String? roomId;
  int? searchStartedOn;
  String? connectedWith;
  String? engagementType;
  Engagement({
    required this.uid,
    this.roomId,
    this.connectedWith,
    required this.engagementStatus,
    this.searchStartedOn,
    this.engagementType,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'room_id': roomId,
      'status': engagementStatus,
      'search_started_on': searchStartedOn,
      'connected_with': connectedWith,
      'type': engagementType,
    };
  }

  factory Engagement.empty() {
    return Engagement(
      uid: '',
      engagementStatus: EngagementStatus.free,
    );
  }

  factory Engagement.fromMap(Map<String, dynamic> map) {
    String _engagementStatus = map['status']!;
    String? _engagementType = map['type'];

    return Engagement(
      uid: map['uid'],
      roomId: map['room_id'],
      engagementStatus: _engagementStatus,
      searchStartedOn: map['search_started_on'],
      connectedWith: map['connected_with'],
      engagementType: _engagementType,
    );
  }

  bool get isBusy => engagementStatus == EngagementStatus.engaged;

  bool get isForVideo => engagementType == EngagementType.video;
  bool get isForChat => engagementType == EngagementType.chat;
}
