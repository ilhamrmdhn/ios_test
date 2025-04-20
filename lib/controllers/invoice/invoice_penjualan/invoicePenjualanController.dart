import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kertasinapp/utilities/colors.dart';

class InvoicePenjualanController extends GetxController {
  final filteredInvoices = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final invoices = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  late final DateFormat dateFormat;
  final numberFormat = NumberFormat('#,##0', 'id_ID');
  StreamSubscription<QuerySnapshot>? _streamSubscription;

  final bool useLimit;
  InvoicePenjualanController({this.useLimit = true});

  @override
  void onInit() async {
    super.onInit();
    print(
        'Initializing InvoicePenjualanController with user ID: $currentUserId');
    await initializeDateFormatting('id_ID', null);
    dateFormat = DateFormat('dd - MM - yyyy', 'id_ID');
    _startStream();
  }

  void _startStream() {
    print('Starting Firestore stream for invoices_penjualan');
    isLoading.value = true;

    Query query = _firestore
        .collection('invoices_penjualan')
        .where('uid', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true);

    if (useLimit) {
      query = query.limit(5);
    }

    _streamSubscription?.cancel();
    _streamSubscription = query.snapshots().listen(
      (QuerySnapshot snapshot) {
        print('Stream received snapshot with ${snapshot.docs.length} docs');
        for (var change in snapshot.docChanges) {
          final data = change.doc.data() as Map<String, dynamic>;
          print(
              'Doc change: ${change.type}, ID: ${change.doc.id}, nomorInvoice: ${data['nomorInvoice']}');
        }
        isLoading.value = false;
        final fetchedInvoices = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final nomorInvoice =
              data['nomorInvoice']?.toString() ?? 'INV-SALE-N/A';
          return {
            'id': doc.id,
            'nomorInvoice': nomorInvoice,
            'tanggal': data['tanggal'],
            'totalItem': data['totalItem'],
            'totalHarga': data['totalHarga'],
          };
        }).toList();
        invoices.assignAll(fetchedInvoices);

        /// 🟢 Auto-filter saat pertama kali data masuk
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
    print('InvoicePenjualanController closed, cancelling stream');
    _streamSubscription?.cancel();
    super.onClose();
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
    return numberFormat
        .format(harga is num ? harga.floor() : 0)
        .replaceAll(',', '.');
  }

  void restartStream() {
    _startStream();
  }

  void filterByMonth(int? month) {
    if (month == null) {
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
}
