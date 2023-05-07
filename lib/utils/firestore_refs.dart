import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/models/message.dart';
import 'package:omegle_clone/utils/firestore_collection.dart';

class FirestoreRefs {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference<Engagement> get engagementCollection =>
      _firestore.collection(FirestoreCollection.engagement).withConverter(
            fromFirestore: (snapshot, options) =>
                Engagement.fromMap(snapshot.data()!),
            toFirestore: (data, options) => data.toMap(),
          );
  static CollectionReference<ChatRoom> getChatRoomCollection(
          {required bool isVideoRoom}) =>
      _firestore
          .collection(isVideoRoom
              ? FirestoreCollection.videoRoom
              : FirestoreCollection.chatRoom)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                ChatRoom.fromMap(snapshot.data()!),
            toFirestore: (data, options) => data.toMap(),
          );

  static CollectionReference<Message> getRoomMessageCollection(
          {required String roomId}) =>
      getChatRoomCollection(isVideoRoom: false)
          .doc(roomId)
          .collection(FirestoreCollection.messages)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                Message.fromMap(snapshot.data()!),
            toFirestore: (data, options) => data.toMap(),
          );
}
