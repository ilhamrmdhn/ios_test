import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/pages/login/LoginPage.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State variables menggunakan Rx dari GetX
  final RxBool isLoading = false.obs;

  // TextEditingController untuk name, email, password, dan confirm password
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); // Controller baru

  Future<void> register() async {
    try {
      // Validasi input
      if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
        Get.snackbar(
          'Error',
          'Password dan konfirmasi password tidak cocok.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (nameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Semua field harus diisi.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      print("Attempting to register with email: ${emailController.text.trim()}");
      isLoading.value = true;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Kirim email verifikasi
        await user.sendEmailVerification();

        // Simpan data pengguna ke Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });

        print("Registration successful");
        isLoading.value = false;

        Get.snackbar(
          'Registrasi Berhasil',
          'Silakan verifikasi email Anda untuk login.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Kembali ke halaman login
        Get.off(() => const LoginPage());
      }
    } catch (e) {
      print("Registration error: $e");
      isLoading.value = false;
      Get.snackbar(
        'Registrasi Gagal',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose(); // Dispose controller baru
    super.onClose();
  }
}