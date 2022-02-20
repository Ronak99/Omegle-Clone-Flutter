import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/constants/strings.dart';

class FirestoreRefs{
  static final FirebaseFirestore _firestore =  FirebaseFirestore.instance;

  static CollectionReference get engagementCollection => _firestore.collection(ENGAGEMENT_COLLECTION);
  static CollectionReference get chatRoomCollection => _firestore.collection(CHAT_ROOM_COLLECTION);
}