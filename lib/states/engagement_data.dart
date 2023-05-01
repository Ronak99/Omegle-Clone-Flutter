import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/ui/screens/chat/chat_screen.dart';
import 'package:omegle_clone/utils/utils.dart';

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
      if (engagementDoc.data() != null) {
        _engagement = engagementDoc.data();

        if (_engagement == null) return;

        if (_engagement!.isForChat &&
            _engagement!.isBusy &&
            _engagement!.roomId != null) {
          Utils.navigateTo(ChatScreen());
        }
        notifyListeners();
      }
    });
  }
}
