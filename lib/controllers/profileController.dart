import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kertasinapp/pages/login/LoginPage.dart';

class ProfileController extends GetxController {
  final user = FirebaseAuth.instance.currentUser;

  var isEditing = false.obs;
  var isLoading = false.obs;

  final namaPerusahaanController = TextEditingController();
  final bidangController = TextEditingController();
  final alamatController = TextEditingController();

  final namaLengkapController = TextEditingController();
  final roleManualController = TextEditingController();

  final List<String> roleOptions = [
    'Pemilik Toko',
    'Owner',
    'CEO',
    'Asisten',
    'Manager',
    'Lainnya',
  ];

  var selectedRole = Rxn<String>();
  var showRoleManualField = false.obs;

  var userData = Rx<Map<String, dynamic>?>(null);
  var currentRole = ''.obs;
  var completionPercentage = 0.0.obs;
  var incompleteFieldsMessage = ''.obs;

  static const int maxRoleLength = 15;

  @override
  void onInit() {
    super.onInit();
    listenToUserData();
  }

  void listenToUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        userData.value = snapshot.data() as Map<String, dynamic>;
        initializeFields();
        updateCurrentRole();
        calculateAndUpdateCompletion();
      } else {
        Get.snackbar("Error", "User data not found");
      }
    }, onError: (error) {
      Get.snackbar("Error", "Failed to load user data: $error");
    });
  }

  void initializeFields() {
    final userName = userData.value?['name'] as String? ?? 'Unknown';
    final userRole = userData.value?['role'] as String? ?? '';

    if (namaLengkapController.text.isEmpty) {
      namaLengkapController.text = userName;
    }
    if (namaPerusahaanController.text.isEmpty) {
      namaPerusahaanController.text =
          userData.value?['namaPerusahaan'] as String? ?? '';
    }
    if (bidangController.text.isEmpty) {
      bidangController.text = userData.value?['bidang'] as String? ?? '';
    }
    if (alamatController.text.isEmpty) {
      alamatController.text = userData.value?['alamat'] as String? ?? '';
    }

    if (selectedRole.value == null) {
      if (roleOptions.contains(userRole)) {
        selectedRole.value = userRole;
      } else if (userRole.isNotEmpty) {
        selectedRole.value = 'Lainnya';
        roleManualController.text = userRole.length > maxRoleLength
            ? userRole.substring(0, maxRoleLength)
            : userRole;
        showRoleManualField.value = true;
      } else {
        selectedRole.value = null;
        roleManualController.text = '';
        showRoleManualField.value = false;
      }
    }
  }

  void updateCurrentRole() {
    final userRole = userData.value?['role'] as String? ?? '';
    if (isEditing.value) {
      currentRole.value = selectedRole.value == 'Lainnya'
          ? roleManualController.text
          : selectedRole.value ?? '';
    } else {
      currentRole.value = userRole;
    }
  }

  void calculateAndUpdateCompletion() {
    completionPercentage.value = calculateCompletionPercentage(
      namaLengkapController.text,
      namaPerusahaanController.text,
      bidangController.text,
      alamatController.text,
      currentRole.value,
    );

    incompleteFieldsMessage.value = getIncompleteFields(
      namaLengkapController.text,
      namaPerusahaanController.text,
      bidangController.text,
      alamatController.text,
      currentRole.value,
    );
  }

  double calculateCompletionPercentage(
    String namaLengkap,
    String namaPerusahaan,
    String bidang,
    String alamat,
    String role,
  ) {
    int totalFields = 5;
    int filledFields = 0;

    if (namaLengkap.isNotEmpty) filledFields++;
    if (namaPerusahaan.isNotEmpty) filledFields++;
    if (bidang.isNotEmpty) filledFields++;
    if (alamat.isNotEmpty) filledFields++;
    if (role.isNotEmpty) filledFields++;

    return (filledFields / totalFields) * 100;
  }

  String getIncompleteFields(
    String namaLengkap,
    String namaPerusahaan,
    String bidang,
    String alamat,
    String role,
  ) {
    List<String> incompleteFields = [];
    if (namaLengkap.isEmpty) incompleteFields.add("Nama Lengkap");
    if (namaPerusahaan.isEmpty) incompleteFields.add("Nama Perusahaan");
    if (bidang.isEmpty) incompleteFields.add("Bidang");
    if (alamat.isEmpty) incompleteFields.add("Alamat");
    if (isEditing.value) {
      if (selectedRole.value == null) {
        incompleteFields.add("Role");
      } else if (selectedRole.value == 'Lainnya' &&
          roleManualController.text.isEmpty) {
        incompleteFields.add("Role (Masukkan Role Manual)");
      }
    } else {
      if (role.isEmpty) incompleteFields.add("Role");
    }

    if (incompleteFields.isEmpty) {
      return "Semua data telah lengkap!";
    } else {
      return "Lengkapi data berikut: ${incompleteFields.join(", ")}";
    }
  }

  bool validateRoleLength() {
    if (selectedRole.value == 'Lainnya' &&
        roleManualController.text.length > maxRoleLength) {
      showErrorSnackbarFromTop(
          'Panjang Role melebihi batas (maksimum $maxRoleLength karakter)');

      return false;
    }
    return true;
  }

  Future<void> saveData() async {
    if (selectedRole.value == 'Lainnya' && roleManualController.text.isEmpty) {
      showErrorSnackbarFromTop(
          'Error, Lengkapi data berikut: Role (Masukkan Role Manual)');
      return;
    }

    if (!validateRoleLength()) {
      return;
    }

    if (!validateRoleLength()) {
      return;
    }

    isLoading.value = true;

    try {
      String finalRole = selectedRole.value == 'Lainnya'
          ? roleManualController.text
          : (selectedRole.value ?? '');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'namaPerusahaan': namaPerusahaanController.text,
        'bidang': bidangController.text,
        'alamat': alamatController.text,
        'name': namaLengkapController.text,
        'role': finalRole,
      });

      showSuccessSnackbarFromTop();

      isEditing.value = false;
    } catch (e) {
      showErrorSnackbarFromTop('Terjadi kesalahan saat menyimpan data!');
    } finally {
      isLoading.value = false;
    }
  }

  void showSuccessSnackbarFromTop() {
    Get.rawSnackbar(
      messageText: Row(
        children: const [
          Icon(Icons.check_circle_outline, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Data berhasil disimpan!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade600,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }

  void showErrorSnackbarFromTop(String message) {
    Get.rawSnackbar(
      messageText: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade600,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }

  void toggleEditMode() {
    isEditing.value = !isEditing.value;
    updateCurrentRole();
    calculateAndUpdateCompletion();
  }

  Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      print("Logged out from Google Sign-In");

      await FirebaseAuth.instance.signOut();
      print("Logged out from Firebase Authentication");

      Get.offAll(() => const LoginPage());

      Get.rawSnackbar(
        messageText: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Anda telah logout. Silakan login dengan akun lain.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        animationDuration: const Duration(milliseconds: 300),
        duration: const Duration(seconds: 2),
        isDismissible: true,
      );
    } catch (e) {
      print("Logout error: $e");

      Get.rawSnackbar(
        messageText: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Logout gagal: ${e.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        animationDuration: const Duration(milliseconds: 300),
        duration: const Duration(seconds: 2),
        isDismissible: true,
      );
    }
  }

  @override
  void onClose() {
    namaPerusahaanController.dispose();
    bidangController.dispose();
    alamatController.dispose();
    namaLengkapController.dispose();
    roleManualController.dispose();
    super.onClose();
  }
}
