// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/invoice/invoice_pembelian/history_pembelian_controller.dart';
import 'package:kertasinapp/pages/invoice/widget/filter_item.dart';
import 'package:kertasinapp/utilities/colors.dart';

import '../../../controllers/invoice/invoice_pembelian/invoicePembelianController.dart';
import '../../../utilities/assets_constants.dart';
import '../../../utilities/typhography.dart';
import '../../../widgets/AppbarDefault.dart';

class HistoryPembelianPage extends StatelessWidget {
  final HistoryPembelianController controller =
      Get.put(HistoryPembelianController());
  final ctrlInvoicePembelian = Get.put(
    InvoicePembelianController(useLimit: false),
    tag: 'history',
    permanent: true,
  );

  HistoryPembelianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPureWhite,
      body: Column(
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: kColorPureWhite,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(AssetsConstant.bgNotif),
              ),
              const AppBarDefault(
                title: "History Invoice Pembelian",
                bgColor: Colors.transparent,
                textColor: kColorPureBlack,
                useShadow: false,
              ),
            ],
          ),
          Container(
            width: Get.width,
            color: kColorPrimary,
            padding: EdgeInsets.symmetric(vertical: 28),
            child: SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.filters.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final item = controller.filters[index];
                    final isSelected = controller.selectedIndex.value == index;
                    return FilterItem(
                        text: item.label,
                        isActive: isSelected,
                        isFirstIndex: index == 0,
                        onTap: () {
                          controller.selectFilter(index);
                          final selectedMonth = controller.filters[index].month;
                          ctrlInvoicePembelian.filterByMonth(selectedMonth);
                        });
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 24),
          Obx(() => Text(
                "${controller.filters[controller.selectedIndex.value].label} history",
                style: TStyle.headline3,
              )),
          SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (ctrlInvoicePembelian.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (ctrlInvoicePembelian.invoices.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "Belum ada riwayat invoice pembelian",
                      style: TStyle.body2.copyWith(color: kColorGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  itemCount: ctrlInvoicePembelian.filteredInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice =
                        ctrlInvoicePembelian.filteredInvoices[index];

                    print('Rendering invoice: ${invoice['id']}');
                    return _buildHistoryItem(
                      invoice['nomorInvoice'] ?? 'INV-Unknown',
                      ctrlInvoicePembelian.formatDate(invoice['tanggal']),
                      invoice['totalItem']?.toString() ?? '0',
                      ctrlInvoicePembelian.formatHarga(invoice['totalHarga']),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String nomorInvoice, String tanggal,
      String totalItem, String totalHarga) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: kColorLightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No. Invoice: $nomorInvoice",
            style: TStyle.body2.copyWith(color: kColorGrey),
          ),
          SizedBox(height: 4),
          Text(
            "Tanggal: $tanggal",
            style: TStyle.body2.copyWith(color: kColorGrey),
          ),
          SizedBox(height: 4),
          Text(
            "Total item: $totalItem",
            style: TStyle.body2.copyWith(color: kColorGrey),
          ),
          SizedBox(height: 4),
          Text(
            "Total harga: Rp. $totalHarga",
            style: TStyle.body2.copyWith(color: kColorGrey),
          ),
        ],
      ),
    );
  }
}
