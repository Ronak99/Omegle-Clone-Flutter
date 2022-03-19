import 'package:flutter/material.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/services/engagement_service.dart';

abstract class RoomData extends ChangeNotifier {
  final EngagementService engagementService = EngagementService();
  final RandomChatService randomChatService = RandomChatService();

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  setSearchToTrue() {
    _isSearching = true;
    notifyListeners();
  }

  setSearchToFalse() {
    _isSearching = false;
    notifyListeners();
  }

  // Search for random users to chat with
  searchRandomUser({
    required String currentUserId,
    required bool isEngagementNull,
  });
}
