import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kertasinapp/pages/login/LoginPage.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      print("Logged out from Google Sign-In");

      await FirebaseAuth.instance.signOut();
      print("Logged out from Firebase Authentication");

      Get.offAll(() => const LoginPage());

      Get.snackbar(
        'Logout Berhasil',
        'Anda telah logout. Silakan login dengan akun lain.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("Logout error: $e");
      Get.snackbar(
        'Logout Gagal',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
            tooltip: "Logout",
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error loading user data");
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text("User data not found");
            }
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final userName = userData['name'] as String? ?? 'Unknown';
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome, $userName!"),
                const SizedBox(height: 16),
                Text("Email: ${user?.email ?? 'Unknown'}"),
              ],
            );
          },
        ),
      ),
    );
  }
}