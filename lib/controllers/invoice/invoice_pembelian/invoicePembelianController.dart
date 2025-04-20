import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kertasinapp/utilities/colors.dart';

class InvoicePembelianController extends GetxController {
  final filteredInvoices = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final invoices = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  late final DateFormat dateFormat;
  final numberFormat = NumberFormat('#,##0', 'id_ID');
  StreamSubscription<QuerySnapshot>? _streamSubscription;

  /// New parameter to control whether we limit the data
  final bool useLimit;
  InvoicePembelianController({this.useLimit = true});

  void filterByMonth(int? month) {
    if (month == null) {
      // Tampilkan semua
      filteredInvoices.assignAll(invoices);
    } else {
      filteredInvoices.assignAll(invoices.where((invoice) {
        final tanggal = invoice['tanggal'];
        if (tanggal is Timestamp) {
          return tanggal.toDate().month == month;
        } else if (tanggal is DateTime) {
          return tanggal.month == month;
        }
        return false;
      }).toList());
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await initializeDateFormatting('id_ID', null);
    dateFormat = DateFormat('dd - MM - yyyy', 'id_ID');
    _startStream();
  }

  void _startStream() {
    isLoading.value = true;
    Query query = _firestore
        .collection('invoices_pembelian')
        .where('uid', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true);

    // Apply limit if needed
    if (useLimit) {
      query = query.limit(3);
    }

    _streamSubscription?.cancel();
    _streamSubscription = query.snapshots().listen(
      (QuerySnapshot snapshot) {
        isLoading.value = false;
        final fetchedInvoices = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'nomorInvoice': data['nomorInvoice'],
            'tanggal': data['tanggal'],
            'totalItem': data['totalItem'],
            'totalHarga': data['totalHarga'],
          };
        }).toList();
        invoices.assignAll(fetchedInvoices);
        filterByMonth(null);
      },
      onError: (e) {
        isLoading.value = false;
        String errorMessage = 'Gagal memuat riwayat invoice: $e';
        if (e.toString().contains('requires an index')) {
          errorMessage =
              'Gagal memuat riwayat invoice: Indeks Firestore diperlukan. Silakan buat indeks di konsol Firebase.';
        }
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: kColorFourth.withOpacity(0.8),
          colorText: kColorPureWhite,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }

  void refreshData() {
    _startStream();
  }

  String formatDate(dynamic tanggal) {
    if (tanggal is Timestamp) {
      return dateFormat.format(tanggal.toDate());
    } else if (tanggal is DateTime) {
      return dateFormat.format(tanggal);
    }
    return '-';
  }

  String formatHarga(dynamic harga) {
    if (harga == null || harga == '') {
      return '';
    }
    return numberFormat.format(harga is num ? harga.floor() : 0);
  }
}
