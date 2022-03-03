import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/enums/engagement_type.dart';
import 'package:omegle_clone/extensions/engagement_status_extension.dart';
import 'package:omegle_clone/extensions/string_extensions.dart';

class Engagement {
  String uid;
  EngagementStatus engagementStatus;
  String? roomId;
  String? roomToken;
  int? searchStartedOn;
  String? connectedWith;
  EngagegmentType? engagegmentType;
  Engagement({
    required this.uid,
    this.roomId,
    this.roomToken,
    this.connectedWith,
    required this.engagementStatus,
    this.searchStartedOn,
    this.engagegmentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'room_id': roomId,
      'room_token': roomToken,
      'status': engagementStatus.toRawValue,
      'search_started_on': searchStartedOn,
      'connected_with': connectedWith,
      'type': engagegmentType,
    };
  }

  factory Engagement.fromMap(Map<String, dynamic> map) {
    String _engagementStatus = map['status']!;
    String _engagementType = map['type']!;

    return Engagement(
      uid: map['uid'],
      roomId: map['room_id'],
      roomToken: map['room_token'],
      engagementStatus: _engagementStatus.toEngagementStatus,
      searchStartedOn: map['search_started_on'],
      connectedWith: map['connected_with'],
      engagegmentType: _engagementType.toEngagementType,
    );
  }

  bool get isBusy => engagementStatus == EngagementStatus.busy;

  bool get isForVideo => engagegmentType == EngagegmentType.video;
  bool get isForChat => engagegmentType == EngagegmentType.chat;
}
