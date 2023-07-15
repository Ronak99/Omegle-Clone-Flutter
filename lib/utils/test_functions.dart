import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omegle_clone/enums/engagement_status.dart';
import 'package:omegle_clone/models/engagement.dart';
import 'package:omegle_clone/services/random_chat_service.dart';
import 'package:omegle_clone/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';

class TestFunctions {
  List<String> uidList = [
    "BLbLykgGfUqgrvJNchLf",
    "EfNDWXGQixWoHs3ocTFuikdUvyy1",
    "LUklImkuYqREnlFoYNbg",
    "LswuHZEYAmXuXIfcsKUt",
    "OjtjvBTkKUcDeECrBPyx",
    "WUWoHIdIOJrCzfOeONmv",
    "dKNlNVSDiqSkKUBrBUYR",
    "eKdNakGsAPxpvuueUidV",
    "gfTcjhXcXsrvbOmrSgOI",
    "lfABArkJZLvikUwAJZJV",
    "maeeSKaedyiPUBYKYITy",
    "n8dhmCMOLWZ0CK70WOx9CG8So193",
  ];

  Future<bool> isMoto() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;

    return deviceInfo.model == "moto e(6s)";
  }

  createDummyUserEngagement() {
    for (int i = 0; i < 10; i++) {
      String uid = Utils.generateRandomId();
      FirebaseFirestore.instance
          .collection('engagement')
          .doc(uid)
          .set(Engagement(
            uid: uid,
            engagementStatus: EngagementStatus.free,
          ).toMap());
    }
  }

  testSearch() async {
    // List<String> subList;
    // if (await isMoto()) {
    //   subList = uidList.sublist(0, 6);
    // } else {
    //   subList = uidList.sublist(6);
    // }
    // RandomChatService _randomChatService = RandomChatService();

    // for (String uid in subList) {
    //   _randomChatService.searchUserToChat(uid: uid);
    // }
  }
}
