import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/utils/custom_exception.dart';

class TestService {
  // createRandomUsers() {
  //   for (int i = 0; i < 30; i++) {
  //     String _randomUid = Utils.generateRandomId();
  //     FirestoreRefs.engagementCollection
  //         .doc(_randomUid)
  //         .set({'status': 'free', 'uid': _randomUid});
  //   }
  // }

  T genericTryCatch<T>(T a) {
    try {
      return a;
    } on FirebaseException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
