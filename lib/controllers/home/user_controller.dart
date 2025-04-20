import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final userName = ''.obs;
  Stream<DocumentSnapshot>? _userStream;

  @override
  void onInit() {
    super.onInit();

    // Listen ke perubahan user login
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _listenToUserData(user.uid);
      } else {
        userName.value = ''; // Kosongkan jika logout
      }
    });
  }

  void _listenToUserData(String uid) {
    _userStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    _userStream!.listen((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        userName.value = data['name'] ?? 'Unknown';
      }
    });
  }

  void updateUserName(String newName) {
    userName.value = newName;
  }
}
