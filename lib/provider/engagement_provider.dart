// supplies engagement state of the currently logged in user throughout the app

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/provider/user_provider.dart';
import 'package:omegle_clone/services/engagement_service.dart';
import 'package:omegle_clone/ui/screens/call/call_screen.dart';
import 'package:omegle_clone/ui/screens/chat/chat_screen.dart';
import 'package:omegle_clone/utils/utils.dart';

var engagementProvider = StateNotifierProvider<EngagementNotifier, Engagement>(
    (ref) => EngagementNotifier(ref));

class EngagementNotifier extends StateNotifier<Engagement> {
  StateNotifierProviderRef ref;

  // Services
  final EngagementService _engagementService = EngagementService();

  // Local State
  StreamSubscription<DocumentSnapshot<Engagement>>? _subscription;

// Constructor
  EngagementNotifier(this.ref) : super(Engagement.empty()) {
    _init();
  }

  _init() async {
    String uid = ref.read(userProvider).uid;
    
    _subscription = _engagementService.userEngagementStream(uid: uid).listen(
        (engagementDoc) => _engagementListener(engagementDoc, uid: uid));
  }

  void _engagementListener(DocumentSnapshot<Engagement> engagementDoc,
      {required String uid}) {
    if (!engagementDoc.exists) {
      _engagementService.createInitialEngagementRecord(uid: uid);
    } else {
      if (engagementDoc.data() == null) return;

      // if user was not busy previously
      if (!state.isBusy) {
        // but gets busy
        if (engagementDoc.data()!.isBusy) {
          // and it gets busy for chat
          if (engagementDoc.data()!.isForChat) {
            Utils.navigateTo(ChatScreen());
          }
        }
      }

      state = engagementDoc.data()!;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
