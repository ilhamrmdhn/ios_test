import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/model/barang/barang_model.dart';
import 'package:intl/intl.dart';

class BarangController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List barang
  final RxList<BarangModel> barangList = <BarangModel>[].obs;

  // Loading states
  final RxBool isLoading = false.obs; // For add/update/delete operations
  final RxBool isFetching = true.obs; // For fetching data

  // Form controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  // Search controller
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final formKey = GlobalKey<FormState>();
  final NumberFormat numberFormat = NumberFormat('#,##0', 'id_ID');

  StreamSubscription<QuerySnapshot>? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    print('BarangController initialized at ${DateTime.now()}');
    final currentUserId = _auth.currentUser?.uid ?? '';
    print('Current user UID: $currentUserId');
    if (currentUserId.isNotEmpty) {
      _startStream();
    } else {
      isFetching.value = false;
      print('No user logged in. Please login first.');
      Get.snackbar(
        "Error",
        "Silakan login untuk melihat data barang",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    // Listen for search query changes
    debounce(searchQuery, (value) {
      _startStream();
    }, time: Duration(milliseconds: 300));
  }

  void _startStream() {
    final currentUserId = _auth.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) {
      print('No user logged in, cannot fetch barang');
      isFetching.value = false;
      Get.snackbar(
        "Error",
        "User tidak terautentikasi. Silakan login kembali.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    print('Starting stream for UID: $currentUserId at ${DateTime.now()}');
    isFetching.value = true;

    _streamSubscription?.cancel();
    Query query;

    if (searchQuery.value.isEmpty) {
      query = _firestore
          .collection('barang')
          .where('uid', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .limit(5);
    } else {
      // Search query: filter by nama (case-sensitive)
      String searchTerm = searchQuery.value;
      query = _firestore
          .collection('barang')
          .where('uid', isEqualTo: currentUserId)
          .where('nama', isGreaterThanOrEqualTo: searchTerm)
          .where('nama', isLessThan: searchTerm + '\uf8ff')
          .orderBy('nama', descending: false);
    }

    _streamSubscription = query.snapshots().listen(
      (QuerySnapshot snapshot) {
        print('Snapshot received at ${DateTime.now()}, docs: ${snapshot.docs.length}');
        barangList.value = snapshot.docs.map((doc) {
          return BarangModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        print('Fetched ${barangList.length} barang at ${DateTime.now()}');
        isFetching.value = false;
      },
      onError: (e) {
        print('Error fetching barang at ${DateTime.now()}: $e');
        isFetching.value = false;
        String errorMessage = "Gagal mengambil data barang: $e";
        if (e.toString().contains('PERMISSION_DENIED')) {
          errorMessage = "Akses ditolak. Periksa izin Firestore atau login ulang.";
        } else if (e.toString().contains('requires an index')) {
          errorMessage =
              "Gagal mengambil data barang: Indeks Firestore diperlukan. Silakan buat indeks di konsol Firebase.";
        }
        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      },
    );
  }

  Future<void> addBarang() async {
    if (!formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    isLoading.value = true;
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      isLoading.value = false;
      print('No user logged in, cannot add barang');
      Get.snackbar(
        "Error",
        "User tidak terautentikasi. Silakan login kembali.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      return;
    }

    try {
      print('Adding barang with UID: $uid');
      final cleanHargaJual = hargaJualController.text.replaceAll('.', '');
      print('Clean hargaJual: $cleanHargaJual');
      final stok = stokController.text.trim();
      print('Stok: $stok');
      await _firestore.collection('barang').add({
        'uid': uid,
        'nama': namaController.text.trim(),
        'hargaJual': int.tryParse(cleanHargaJual) ?? 0,
        'stok': int.tryParse(stok) ?? 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Barang added successfully');
      Get.back();
      Get.snackbar(
        "Sukses",
        "Barang berhasil ditambahkan",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      clearForm();
    } catch (e) {
      print('Error adding barang: $e');
      String errorMessage = "Gagal menambahkan barang: $e";
      if (e.toString().contains('PERMISSION_DENIED')) {
        errorMessage = "Akses ditolak. Periksa izin Firestore atau login ulang.";
      }
      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBarang(String id) async {
    if (!formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    isLoading.value = true;
    try {
      print('Updating barang with ID: $id');
      final cleanHargaJual = hargaJualController.text.replaceAll('.', '');
      print('Clean hargaJual: $cleanHargaJual');
      await _firestore.collection('barang').doc(id).update({
        'nama': namaController.text.trim(),
        'hargaJual': int.tryParse(cleanHargaJual) ?? 0,
        'stok': int.tryParse(stokController.text.trim()) ?? 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('Barang updated successfully');
      Get.back();
      Get.snackbar(
        "Sukses",
        "Barang berhasil diupdate",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      clearForm();
    } catch (e) {
      print('Error updating barang: $e');
      String errorMessage = "Gagal mengupdate barang: $e";
      if (e.toString().contains('PERMISSION_DENIED')) {
        errorMessage = "Akses ditolak. Periksa izin Firestore atau login ulang.";
      }
      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBarang(String id) async {
    try {
      print('Deleting barang with ID: $id');
      await _firestore.collection('barang').doc(id).delete();
      print('Barang deleted successfully');
      Get.snackbar(
        "Berhasil",
        "Barang berhasil dihapus",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting barang: $e');
      String errorMessage = "Gagal menghapus barang: $e";
      if (e.toString().contains('PERMISSION_DENIED')) {
        errorMessage = "Akses ditolak. Periksa izin Firestore atau login ulang.";
      }
      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void fillForm(BarangModel barang) {
    namaController.text = barang.nama;
    hargaJualController.text = numberFormat.format(barang.hargaJual);
    stokController.text = barang.stok.toString();
    print('Form filled with barang: ${barang.nama}, ${barang.hargaJual}, ${barang.stok}');
  }

  void clearForm() {
    namaController.clear();
    hargaJualController.clear();
    stokController.clear();
    print('Form cleared');
  }

  void refreshData() {
    print('Refreshing barang data');
    _startStream();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    namaController.dispose();
    hargaJualController.dispose();
    stokController.dispose();
    searchController.dispose();
    super.onClose();
    print('BarangController closed');
  }
}