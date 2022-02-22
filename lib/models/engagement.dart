import 'dart:convert';

import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/extensions/engagement_status_extension.dart';
import 'package:omegle_clone/extensions/string_extensions.dart';
import 'package:omegle_clone/utils/value_convertors.dart';

class Engagement {
  String uid;
  String? roomId;
  EngagementStatus engagementStatus;
  int searchStartedOn;
  String? connectedWith;
  Engagement({
    required this.uid,
    this.roomId,
    this.connectedWith,
    required this.engagementStatus,
    required this.searchStartedOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'room_id': roomId,
      'status': engagementStatus.toRawValue,
      'search_started_on': searchStartedOn,
      'connected_with': connectedWith,
    };
  }

  factory Engagement.fromMap(Map<String, dynamic> map) {
    String _engagementStatus = map['status']!;

    return Engagement(
      uid: map['uid'],
      roomId: map['room_id'],
      engagementStatus: _engagementStatus.toEngagementStatus,
      searchStartedOn: map['search_started_on'],
      connectedWith: map['connected_with'],
    );
  }

  bool get isBusy => engagementStatus == EngagementStatus.busy;
}
