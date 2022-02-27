import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/services/engagement_service.dart';

class EngagementData extends ChangeNotifier {
  final EngagementService _engagementService = EngagementService();
  Engagement? _engagement;
  Engagement? get engagement => _engagement;
  late StreamSubscription<DocumentSnapshot<Engagement>> _engagementStreamSub;

  initialize(uid) async {
    // create initial engagement record
    _engagementStreamSub = _engagementService
        .userEngagementStream(uid: uid)
        .listen((engagementDoc) {
      _engagement = engagementDoc.data()!;
      notifyListeners();
    });
  }
}
