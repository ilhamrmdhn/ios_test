import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';

import '../../../controllers/invoice/invoice_penjualan/tambahInvoicePenjualanController.dart';

class TambahInvoicePenjualanPage extends StatelessWidget {
  TambahInvoicePenjualanPage({Key? key}) : super(key: key);

  final TambahInvoicePenjualanController controller =
      Get.put(TambahInvoicePenjualanController());
  final namaPelangganController = TextEditingController();
  final searchController = TextEditingController();
  final jumlahBarangController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPureWhite,
      appBar: AppBar(
        backgroundColor: kColorFirst,
        elevation: 0,
        title: Text(
          "Tambah Invoice Penjualan",
          style: TStyle.headline4,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: kColorPureWhite),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInvoiceDetails(),
            _buildAddItemSection(),
            _buildItemsList(),
            _buildTotalSection(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Nomor Invoice",
          style: TStyle.subtitle2,
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: kColorLightGrey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kColorMediumGrey.withOpacity(0.3)),
          ),
          child: Obx(() => Text(
                controller.nomorInvoice.value,
                style: TStyle.body2.copyWith(color: kColorGrey),
              )),
        ),
        SizedBox(height: 12),
        _buildTextField(
          controller: namaPelangganController,
          label: "Nama Pelanggan",
          hint: "Masukkan nama pelanggan",
          onChanged: (value) => controller.namaPelanggan.value = value,
        ),
        SizedBox(height: 12),
        _buildDatePicker(),
      ]),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tanggal",
          style: TStyle.subtitle2,
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: Get.context!,
              initialDate: controller.tanggalInvoice.value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              controller.tanggalInvoice.value = picked;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: kColorMediumGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      "${controller.tanggalInvoice.value.day}/${controller.tanggalInvoice.value.month}/${controller.tanggalInvoice.value.year}",
                      style: TStyle.body2,
                    )),
                Icon(Icons.calendar_today, color: kColorMediumGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddItemSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kColorLightBlue5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kColorLightBlue, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tambah Barang",
            style: TStyle.subtitle1.copyWith(color: kColorPrimary),
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Barang",
                style: TStyle.subtitle2,
              ),
              SizedBox(height: 8),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  controller.searchQuery.value = value;
                  controller.searchBarang(value);
                },
                decoration: InputDecoration(
                  hintText: "Cari barang...",
                  hintStyle: TStyle.body2.copyWith(color: kColorMediumGrey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: kColorMediumGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: kColorMediumGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: kColorFirst, width: 2),
                  ),
                  prefixIcon: Icon(Icons.search, color: kColorGrey),
                  suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: kColorGrey),
                          onPressed: () {
                            searchController.clear();
                            controller.searchQuery.value = '';
                            controller.searchResults.clear();
                          },
                        )
                      : SizedBox.shrink()),
                ),
              ),
              Obx(() {
                if (controller.isSearching.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (controller.searchQuery.value.isNotEmpty &&
                    controller.searchResults.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Tidak ada barang ditemukan",
                      style: TStyle.body2.copyWith(color: kColorGrey),
                    ),
                  );
                } else if (controller.searchResults.isNotEmpty) {
                  return Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: kColorMediumGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final barang = controller.searchResults[index];
                        return ListTile(
                          title: Text(barang.nama, style: TStyle.subtitle2),
                          subtitle: Text(
                            "Stok: ${barang.stok} | Harga: Rp ${controller.formatNumber(barang.hargaJual)}",
                            style: TStyle.caption,
                          ),
                          onTap: () {
                            searchController.text = barang.nama;
                            controller.searchResults.clear();
                            _showQuantityDialog(barang);
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog(Barang barang) {
    jumlahBarangController.text = '1';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Jumlah ${barang.nama}",
                style: TStyle.headline3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                "Harga: Rp ${controller.formatNumber(barang.hargaJual)} / unit",
                style: TStyle.body2.copyWith(color: kColorGrey),
              ),
              Text(
                "Stok tersedia: ${barang.stok}",
                style: TStyle.body2.copyWith(color: kColorGrey),
              ),
              SizedBox(height: 16),
              TextField(
                controller: jumlahBarangController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Jumlah",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Batal", style: TStyle.button2),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final jumlah =
                          int.tryParse(jumlahBarangController.text) ?? 0;

                      if (jumlah <= 0) {
                        showErrorSnackbarFromTop(
                            "Error, \nJumlah harus lebih dari 0");
                        return;
                      }

                      final success = await controller.addItem(InvoiceItem(
                        nama: barang.nama,
                        jumlah: jumlah,
                        hargaJual: barang.hargaJual,
                      ));

                      if (success) {
                        Get.back();
                        searchController.clear();
                        controller.searchQuery.value = '';

                        showSuccessSnackbarFromTop(
                            "Sukses, \nBarang berhasil ditambahkan");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorThird,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Tambah", style: TStyle.captionWhite),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Konfirmasi Simpan Invoice",
                style: TStyle.headline3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                "Anda akan menyimpan invoice penjualan dengan:",
                style: TStyle.body2.copyWith(color: kColorGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Total Item: ${controller.items.length} barang",
                style: TStyle.body2.copyWith(color: kColorGrey),
              ),
              Text(
                "Total Harga: Rp ${controller.formatNumber(controller.totalHarga)}",
                style: TStyle.body2.copyWith(color: kColorGrey),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Batal", style: TStyle.button2),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.saveInvoice();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorThird,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Ya, Simpan", style: TStyle.captionWhite),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daftar Barang",
                style: TStyle.headline3,
              ),
              Obx(() => Text(
                    "${controller.items.length} item",
                    style: TStyle.body2.copyWith(color: kColorGrey),
                  )),
            ],
          ),
          SizedBox(height: 16),
          Obx(() => controller.items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "Belum ada barang. Tambahkan barang di atas.",
                      style: TStyle.body2.copyWith(color: kColorGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return _buildItemCard(item, index);
                  },
                )),
        ],
      ),
    );
  }

  Widget _buildItemCard(InvoiceItem item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kColorLightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: TStyle.subtitle2,
                ),
                SizedBox(height: 4),
                Text(
                  "${item.jumlah} unit",
                  style: TStyle.body2.copyWith(color: kColorGrey),
                ),
                SizedBox(height: 4),
                Text(
                  "Rp ${controller.formatNumber(item.hargaJual)} / unit",
                  style: TStyle.body2.copyWith(color: kColorGrey),
                ),
                SizedBox(height: 4),
                Text(
                  "Subtotal: Rp ${controller.formatNumber(item.hargaJual * item.jumlah)}",
                  style: TStyle.subtitle2,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: kColorFourth),
            onPressed: () => controller.removeItem(index),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kColorFirst.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Item:",
                  style: TStyle.body1,
                ),
                Obx(() => Text(
                      "${controller.items.length} barang",
                      style: TStyle.body1,
                    )),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Harga:",
                  style: TStyle.headline3,
                ),
                Obx(() => Text(
                      "Rp ${controller.formatNumber(controller.totalHarga)}",
                      style: TStyle.headline3.copyWith(color: kColorThird),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          if (controller.items.isEmpty) {
            showErrorSnackbarFromTop("Error, \nTambahkan minimal satu barang");
            return;
          }

          if (controller.namaPelanggan.value.trim().isEmpty) {
            showErrorSnackbarFromTop("Error, \nHarap masukkan nama pelanggan");
            return;
          }
          _showConfirmationDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kColorThird,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          "Simpan Invoice",
          style: TStyle.button1.copyWith(color: kColorPureWhite),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TStyle.subtitle2,
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TStyle.body2.copyWith(color: kColorMediumGrey),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kColorMediumGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kColorMediumGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kColorFirst, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  showSuccessSnackbarFromTop(String message) {
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

  showErrorSnackbarFromTop(String message) {
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
