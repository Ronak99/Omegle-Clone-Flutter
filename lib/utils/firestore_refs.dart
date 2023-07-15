import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/models/app_user.dart';
import 'package:omegle_clone/models/chat_room.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/models/friend.dart';
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

  static CollectionReference<AuthenticatedUser> get userCollection =>
      _firestore.collection(FirestoreCollection.engagement).withConverter(
            fromFirestore: (snapshot, options) =>
                AuthenticatedUser.fromMap(snapshot.data()!),
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
                snapshot.data()!['type'] == 'text'
                    ? TextMessage.fromMap(snapshot.data()!)
                    : FriendRequestMessage.fromMap(snapshot.data()!),
            toFirestore: (data, options) => data.toMap(),
          );

  static CollectionReference<Friend> getFriendsCollection(
          {required String uid}) =>
      _firestore
          .collection('users/$uid/${FirestoreCollection.friends}')
          .withConverter(
            fromFirestore: (snapshot, options) =>
                Friend.fromMap(snapshot.data()!),
            toFirestore: (data, options) => data.toMap(),
          );

  static DocumentReference<Friend> getFriendsDoc(
          {required String uid, required String friendUid}) =>
      getFriendsCollection(uid: uid).doc(friendUid);
}
