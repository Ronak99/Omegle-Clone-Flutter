import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/constants/strings.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/models/message.dart';

class FirestoreRefs {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<Engagement> get engagementCollection =>
      _firestore.collection(ENGAGEMENT_COLLECTION).withConverter(
            fromFirestore: (snapshot, options) =>
                Engagement.fromMap(snapshot.data()!),
            toFirestore: (data, options) => data.toMap(),
          );
  static CollectionReference<ChatRoom> get chatRoomCollection =>
      _firestore.collection(CHAT_ROOM_COLLECTION).withConverter(
            fromFirestore: (snapshot, options) =>
                ChatRoom.fromMap(snapshot.data()!),
            toFirestore: (data, options) => data.toMap(),
          );

  static CollectionReference<Message> getRoomMessageCollection(
          {required String roomId}) =>
      chatRoomCollection
          .doc(roomId)
          .collection(MESSAGES_COLLECTION)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                Message.fromMap(snapshot.data()!),
            toFirestore: (data, options) => data.toMap(),
          );
}
