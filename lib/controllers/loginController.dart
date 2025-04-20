import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kertasinapp/pages/main/main_page.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // State variables menggunakan Rx dari GetX
  final RxBool showVerificationMessage = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSigningIn = false.obs;

  // TextEditingController untuk email dan password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _googleSignIn
        .signOut(); // Logout dari Google Sign-In saat controller diinisialisasi
  }

  Future<void> login() async {
    try {
      print("Attempting to login with email: ${emailController.text.trim()}");
      isLoading.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.reload();
        if (!user.emailVerified) {
          showVerificationMessage.value = true;
          isLoading.value = false;
          Get.snackbar(
            'Email Belum Terverifikasi',
            'Email Anda belum diverifikasi. Silakan cek inbox atau spam folder Anda.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        print("Login successful");
        // Update lastLogin timestamp
        await _firestore.collection('users').doc(user.uid).set({
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        isLoading.value = false;
        Get.off(() => MainPage());
      }
    } catch (e) {
      print("Login error: $e");
      isLoading.value = false;
      Get.snackbar(
        'Login Gagal',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      isLoading.value = true;
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print("Email verification resent to ${user.email}");
        isLoading.value = false;
        Get.snackbar(
          'Verifikasi Email',
          'Email verifikasi telah dikirim ulang ke ${emailController.text}. Silakan cek inbox Anda.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error resending email verification: $e");
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Gagal mengirim ulang email verifikasi: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<GoogleSignInAccount?> _attemptSignIn() async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        print("Attempt $attempt: Signing in with Google...");
        final GoogleSignInAccount? googleUser =
            await Future.delayed(Duration.zero, () => _googleSignIn.signIn());
        return googleUser;
      } catch (e) {
        print("Attempt $attempt failed: $e");
        if (attempt == 3) {
          rethrow;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    return null;
  }

  Future<void> handleGoogleSignIn() async {
    if (isSigningIn.value) {
      print("Sign-in already in progress, ignoring new request");
      return;
    }

    try {
      isLoading.value = true;
      isSigningIn.value = true;

      print("Attempting Google Sign-In...");
      await _googleSignIn.signOut();
      print("Previous Google Sign-In session cleared");

      final GoogleSignInAccount? googleUser = await _attemptSignIn();

      if (googleUser == null) {
        print("Google Sign-In cancelled by user");
        isLoading.value = false;
        isSigningIn.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print("Google Sign-In successful: ${user.email}");

        // Ambil data pengguna yang sudah ada dari Firestore (jika ada)
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        String? existingName;

        if (userDoc.exists) {
          existingName = userDoc.get('name') as String?;
        }

        // Prioritaskan nama dari Google Sign-In jika belum ada nama sebelumnya
        String finalName = existingName ??
            googleUser.displayName ??
            user.displayName ??
            'Unknown';

        // Simpan data pengguna ke Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': finalName,
          'email': googleUser.email ?? user.email ?? 'Unknown',
          'createdAt': userDoc.exists
              ? userDoc.get('createdAt')
              : FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        print("User data saved to Firestore: ${user.email}");
        isLoading.value = false;
        isSigningIn.value = false;
        Get.off(() => MainPage());
      } else {
        print("Google Sign-In failed: No user returned");
        isLoading.value = false;
        isSigningIn.value = false;
        Get.snackbar(
          'Google Sign-In Gagal',
          'Tidak dapat mengautentikasi pengguna.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      print("Google Sign-In error: $e\nStackTrace: $stackTrace");
      String errorMessage = e.toString();
      if (e is PlatformException) {
        errorMessage = "Kode error: ${e.code}\nPesan: ${e.message}";
      }
      isLoading.value = false;
      isSigningIn.value = false;
      Get.snackbar(
        'Google Sign-In Gagal',
        errorMessage,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
