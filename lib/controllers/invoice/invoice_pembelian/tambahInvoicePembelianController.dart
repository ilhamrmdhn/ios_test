import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:kertasinapp/utilities/colors.dart';

class Barang {
  final String id;
  final String nama;

  Barang({
    required this.id,
    required this.nama,
  });

  factory Barang.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Barang(
      id: doc.id,
      nama: data['nama'] ?? '',
    );
  }
}

class InvoiceItem {
  String nama;
  int jumlah;
  double hargaBeli;
  double hargaJual;
  bool updateHargaBeli;
  bool updateHargaJual;

  InvoiceItem({
    required this.nama,
    required this.jumlah,
    required this.hargaBeli,
    required this.hargaJual,
    required this.updateHargaBeli,
    required this.updateHargaJual,
  });
}

class TambahInvoicePembelianController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  final items = <InvoiceItem>[].obs;
  final namaPemasok = ''.obs;
  final tanggalInvoice = DateTime.now().obs;
  final nomorInvoice = ''.obs;
  final searchQueryBarang = ''.obs;
  final searchResultsBarang = <Barang>[].obs;
  final isSearchingBarang = false.obs;
  final numberFormat = NumberFormat('#,##0', 'id_ID');

  @override
  void onInit() {
    super.onInit();
    generateInvoiceNumber();
  }

  void generateInvoiceNumber() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyyMMdd-HHmmss');
    final dateStr = dateFormat.format(now);
    final random = Random().nextInt(10000).toString().padLeft(4, '0');
    nomorInvoice.value = 'INV-PUR-$dateStr-$random';
  }

  double get totalHarga =>
      items.fold(0, (sum, item) => sum + (item.hargaBeli * item.jumlah));

  String formatNumber(double number) {
    return numberFormat.format(number.floor()).replaceAll(',', '.');
  }

  Future<bool> addItem(InvoiceItem item) async {
    try {
      if (item.jumlah <= 0) {
        showErrorSnackbarFromTop('Error, \nJumlah harus lebih dari 0');
        return false;
      }
      if (item.hargaBeli <= 0 && item.updateHargaBeli) {
        showErrorSnackbarFromTop(
          'Error, \nHarga beli harus lebih dari 0 jika ingin diupdate',
        );
        return false;
      }
      if (item.hargaJual <= 0 && item.updateHargaJual) {
        showErrorSnackbarFromTop(
          'Error, \nHarga jual harus lebih dari 0 jika ingin diupdate',
        );
        return false;
      }
      if (item.nama.trim().isEmpty) {
        showErrorSnackbarFromTop('Error, \nNama barang tidak boleh kosong');
        return false;
      }

      final existingIndex =
          items.indexWhere((element) => element.nama == item.nama);
      if (existingIndex >= 0) {
        final existingItem = items[existingIndex];
        items[existingIndex] = InvoiceItem(
          nama: existingItem.nama,
          jumlah: existingItem.jumlah + item.jumlah,
          hargaBeli: item.hargaBeli,
          hargaJual: item.hargaJual,
          updateHargaBeli: item.updateHargaBeli,
          updateHargaJual: item.updateHargaJual,
        );
      } else {
        items.add(item);
      }
      return true;
    } catch (e) {
      print('Error adding item: $e');
      showErrorSnackbarFromTop(
        'Error, \nGagal menambahkan barang: $e',
      );
      return false;
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  Future<void> searchBarang(String query) async {
    if (query.isEmpty) {
      searchResultsBarang.clear();
      isSearchingBarang.value = false;
      return;
    }

    isSearchingBarang.value = true;
    searchResultsBarang.clear();

    try {
      final querySnapshot = await _firestore
          .collection('barang')
          .where('uid', isEqualTo: currentUserId)
          .get();

      final allBarang =
          querySnapshot.docs.map((doc) => Barang.fromFirestore(doc)).toList();

      final filteredResults = allBarang
          .where((barang) =>
              barang.nama.toLowerCase().contains(query.trim().toLowerCase()))
          .toList();

      searchResultsBarang.assignAll(filteredResults);
    } catch (e) {
      print('Error searching products: $e');
      showErrorSnackbarFromTop(
        'Error, \nGagal mencari barang: $e',
      );
    } finally {
      isSearchingBarang.value = false;
    }
  }

  Future<Map<String, dynamic>?> checkExistingBarang(String namaBarang) async {
    try {
      final querySnapshot = await _firestore
          .collection('barang')
          .where('nama', isEqualTo: namaBarang)
          .where('uid', isEqualTo: currentUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error checking barang: $e');
      return null;
    }
  }

  Future<void> saveInvoice() async {
    try {
      generateInvoiceNumber();
      final invoiceNumber = nomorInvoice.value;

      final invoiceDoc = await _firestore
          .collection('invoices_pembelian')
          .doc(invoiceNumber)
          .get();
      if (invoiceDoc.exists) {
        showErrorSnackbarFromTop(
            'Error, \nNomor invoice "$invoiceNumber" sudah digunakan, coba lagi');
        return;
      }

      final batch = _firestore.batch();

      // Simpan ke invoices_pembelian
      final invoiceData = {
        'nomorInvoice': invoiceNumber,
        'namaPemasok': namaPemasok.value,
        'tanggal': Timestamp.fromDate(tanggalInvoice.value),
        'totalItem': items.length,
        'totalHarga': totalHarga,
        'uid': currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
        'items': items
            .map((item) => {
                  'nama': item.nama,
                  'jumlah': item.jumlah,
                  'hargaBeli': item.hargaBeli,
                  'subtotal': item.hargaBeli * item.jumlah,
                })
            .toList(),
      };

      print('Saving invoice to invoices_pembelian: $invoiceData');
      final invoiceRef =
          _firestore.collection('invoices_pembelian').doc(invoiceNumber);
      batch.set(invoiceRef, invoiceData);

      // Update koleksi barang
      for (var item in items) {
        final querySnapshot = await _firestore
            .collection('barang')
            .where('nama', isEqualTo: item.nama)
            .where('uid', isEqualTo: currentUserId)
            .get();

        if (querySnapshot.docs.isEmpty) {
          // Barang baru: buat dokumen dengan hargaBeli dan hargaJual
          final newBarangRef = _firestore.collection('barang').doc();
          batch.set(newBarangRef, {
            'nama': item.nama,
            'harga': item.hargaBeli,
            'hargaJual': item.hargaJual,
            'stok': item.jumlah,
            'uid': currentUserId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Barang existing: update stok, harga, dan hargaJual berdasarkan kondisi
          final barangRef = querySnapshot.docs.first.reference;
          final barangData =
              querySnapshot.docs.first.data() as Map<String, dynamic>;
          final hargaBeliLama = (barangData['harga'] ?? item.hargaBeli) as num;
          final hargaJualLama =
              (barangData['hargaJual'] ?? item.hargaJual) as num;

          final updateData = {
            'stok': FieldValue.increment(item.jumlah),
            if (item.updateHargaBeli) 'harga': item.hargaBeli,
            if (item.updateHargaJual) 'hargaJual': item.hargaJual,
          };

          if (!item.updateHargaBeli) updateData['harga'] = hargaBeliLama;
          if (!item.updateHargaJual) updateData['hargaJual'] = hargaJualLama;

          batch.update(barangRef, updateData);
        }
      }

      await batch.commit();

      items.clear();
      namaPemasok.value = '';
      tanggalInvoice.value = DateTime.now();
      generateInvoiceNumber();

      Get.back(result: true);

      showSuccessSnackbarFromTop(
        'Sukses, \nInvoice pembelian berhasil disimpan',
      );
    } catch (e) {
      print('Error saving invoice: $e');
      showErrorSnackbarFromTop(
          'Error, \nGagal menyimpan invoice atau memperbarui stok/harga: $e');
    }
  }

  void showSuccessSnackbarFromTop(String message) {
    Get.rawSnackbar(
      messageText: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
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
}
