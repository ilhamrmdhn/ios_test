import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/pages/register/RegisterPage.dart';

class ResetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controller untuk input email
  final emailController = TextEditingController();

  // Status untuk menampilkan pesan sukses
  var showSuccessMessage = false.obs;

  // Status loading
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Fungsi untuk reset password
  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    // Validasi input kosong
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validasi format email
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Masukkan email yang valid.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      print("Mencoba mengirim email reset password ke: $email");

      // Kirim email reset password menggunakan Firebase
      await _auth.sendPasswordResetEmail(email: email);

      print("Email reset password berhasil dikirim ke: $email");
      showSuccessMessage.value = true;

      Get.snackbar(
        'Sukses',
        'Link reset password telah dikirim ke $email. Silakan cek inbox atau folder spam Anda. Tidak menerima? Hubungi dukungan.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      print("Error reset password: $e");
      String errorMessage = 'Gagal mengirim link reset password.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Email tidak valid.';
            break;
          case 'user-not-found':
            errorMessage = 'Email tidak terdaftar. Daftar sekarang?';
            Get.snackbar(
              'Error',
              errorMessage,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              mainButton: TextButton(
                onPressed: () => Get.to(() => const RegisterPage()),
                child: const Text('Daftar', style: TextStyle(color: Colors.white)),
              ),
            );
            return;
          case 'too-many-requests':
            errorMessage = 'Terlalu banyak percobaan. Tunggu beberapa menit dan coba lagi.';
            break;
          case 'network-request-failed':
            errorMessage = 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
            break;
          default:
            errorMessage = 'Error: ${e.message ?? e.toString()}';
        }
      }
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}