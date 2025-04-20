import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/invoice/invoice_pembelian/invoicePembelianController.dart';
import '../../controllers/invoice/invoice_penjualan/invoicePenjualanController.dart';
import '../../utilities/colors.dart';
import '../../utilities/typhography.dart';

class PencatatanBiayaPage extends StatelessWidget {
  final InvoicePenjualanController penjualanController =
      Get.put(InvoicePenjualanController());
  final InvoicePembelianController pembelianController =
      Get.put(InvoicePembelianController());

  final numberFormat = NumberFormat('#,##0', 'id_ID');

  PencatatanBiayaPage({super.key});

  int getTotalPemasukan() {
    return penjualanController.invoices.fold<num>(0, (sum, item) {
      return sum + (item['totalHarga'] ?? 0);
    }).toInt();
  }

  int getTotalPengeluaran() {
    return pembelianController.invoices.fold<num>(0, (sum, item) {
      return sum + (item['totalHarga'] ?? 0);
    }).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPureWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top + 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            width: Get.width,
            decoration: BoxDecoration(
              color: kColorFirst,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Pencatatan Biaya",
                  style: TStyle.headline3.copyWith(color: kColorPureWhite),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),
                Obx(() {
                  final totalPemasukan = getTotalPemasukan();
                  final totalPengeluaran = getTotalPengeluaran();
                  final totalKeseluruhan = totalPemasukan + totalPengeluaran;

                  double pemasukanRatio = 0.0;
                  double pengeluaranRatio = 0.0;

                  if (totalKeseluruhan > 0) {
                    pemasukanRatio = totalPemasukan / totalKeseluruhan;
                    pengeluaranRatio = totalPengeluaran / totalKeseluruhan;
                  }

                  final historyList = [
                    ...penjualanController.invoices.map((e) => {
                          ...e,
                          'tipe': 'Pemasukan',
                        }),
                    ...pembelianController.invoices.map((e) => {
                          ...e,
                          'tipe': 'Pengeluaran',
                        }),
                  ]..sort((a, b) {
                      final aDate = a['tanggal'] as Timestamp?;
                      final bDate = b['tanggal'] as Timestamp?;
                      return bDate!.compareTo(aDate!);
                    });

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressBar(
                          labelWidget: Text(
                            "Total Pemasukan",
                            style: TStyle.captionWhite.copyWith(fontSize: 16),
                          ),
                          progressValue: pemasukanRatio,
                          valueText:
                              "Rp ${numberFormat.format(totalPemasukan).replaceAll(',', '.')}",
                          backgroundColor:
                              totalKeseluruhan == 0 ? Colors.grey : Colors.blue,
                        ),
                        const SizedBox(height: 16),
                        _buildProgressBar(
                          labelWidget: Text(
                            "Total Pengeluaran",
                            style: TStyle.captionWhite.copyWith(fontSize: 16),
                          ),
                          progressValue: pengeluaranRatio,
                          valueText:
                              "Rp ${numberFormat.format(totalPengeluaran).replaceAll(',', '.')}",
                          backgroundColor: totalKeseluruhan == 0
                              ? Colors.grey
                              : const Color.fromARGB(255, 185, 30, 30),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("History", style: TStyle.headline3),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final historyList = [
                  ...penjualanController.invoices.map((e) => {
                        ...e,
                        'tipe': 'Pemasukan',
                      }),
                  ...pembelianController.invoices.map((e) => {
                        ...e,
                        'tipe': 'Pengeluaran',
                      }),
                ]..sort((a, b) {
                    final aDate = a['tanggal'] as Timestamp?;
                    final bDate = b['tanggal'] as Timestamp?;
                    return bDate!.compareTo(aDate!);
                  });
                return SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ...historyList
                          .map((item) => _buildHistoryItem(item))
                          .toList(),
                      SizedBox(
                        height: Get.height * 0.1,
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required Widget labelWidget,
    required double progressValue,
    required String valueText,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 8),
    Color backgroundColor = Colors.blue,
  }) {
    final isZero = progressValue == 0;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget,
          const SizedBox(height: 4),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 36,
                  backgroundColor: isZero
                      ? Colors.grey.shade300
                      : backgroundColor.withOpacity(0.25), // lebih terang
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isZero ? Colors.grey : backgroundColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  valueText,
                  style: TextStyle(
                    color: isZero ? Colors.black87 : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final date = item['tanggal']?.toDate();
    final formattedDate =
        date != null ? DateFormat('dd MMM yyyy').format(date) : '-';
    final formattedTime =
        date != null ? DateFormat('hh:mm a').format(date) : '';
    final isPemasukan = item['tipe'] == 'Pemasukan';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kColorLightGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isPemasukan
                ? Colors.blue
                : const Color.fromARGB(255, 239, 78, 66)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("No. Inovice: ${item['nomorInvoice']}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isPemasukan ? Colors.blue.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['tipe'],
                  style: TextStyle(
                    color: isPemasukan ? Colors.blue : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Text(
              "Total Biaya: Rp ${numberFormat.format(item['totalHarga']).replaceAll(',', '.')}"),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Text("$formattedDate\n$formattedTime",
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }
}
