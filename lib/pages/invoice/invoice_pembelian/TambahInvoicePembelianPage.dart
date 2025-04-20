import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/invoice/invoice_pembelian/tambahInvoicePembelianController.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';

class TambahInvoicePembelianPage extends StatelessWidget {
  TambahInvoicePembelianPage({Key? key}) : super(key: key);

  final TambahInvoicePembelianController controller =
      Get.put(TambahInvoicePembelianController());
  final namaPemasokController = TextEditingController();
  final searchBarangController = TextEditingController();
  final jumlahBarangController = TextEditingController();
  final hargaBeliController = TextEditingController();
  final hargaJualController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPureWhite,
      appBar: AppBar(
        backgroundColor: kColorFirst,
        elevation: 0,
        title: Text(
          "Tambah Invoice Pembelian",
          style: TStyle.headline4,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kColorPureWhite),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nomor Invoice",
            style: TStyle.subtitle2,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          const SizedBox(height: 12),
          Text(
            "Nama Pemasok",
            style: TStyle.subtitle2,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: namaPemasokController,
            onChanged: (value) {
              controller.namaPemasok.value = value;
            },
            decoration: InputDecoration(
              hintText: "Masukkan nama pemasok",
              hintStyle: TStyle.body2.copyWith(color: kColorMediumGrey),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kColorMediumGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kColorMediumGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kColorFirst, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildDatePicker(),
        ],
      ),
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
        const SizedBox(height: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                const Icon(Icons.calendar_today, color: kColorMediumGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddItemSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 16),
          Text(
            "Nama Barang",
            style: TStyle.subtitle2,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: searchBarangController,
            onChanged: (value) {
              controller.searchQueryBarang.value = value;
              controller.searchBarang(value);
            },
            decoration: InputDecoration(
              hintText: "Cari atau masukkan nama barang...",
              hintStyle: TStyle.body2.copyWith(color: kColorMediumGrey),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kColorMediumGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kColorMediumGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kColorFirst, width: 2),
              ),
              prefixIcon: const Icon(Icons.search, color: kColorGrey),
              suffixIcon:
                  Obx(() => controller.searchQueryBarang.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: kColorGrey),
                          onPressed: () {
                            searchBarangController.clear();
                            controller.searchQueryBarang.value = '';
                            controller.searchResultsBarang.clear();
                          },
                        )
                      : const SizedBox.shrink()),
            ),
          ),
          Obx(() {
            if (controller.isSearchingBarang.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (controller.searchQueryBarang.value.isNotEmpty &&
                controller.searchResultsBarang.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Tidak ada barang ditemukan",
                      style: TStyle.body2.copyWith(color: kColorGrey),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        final nama = searchBarangController.text.trim();
                        if (nama.isEmpty) {
                          showErrorSnackbarFromTop(
                              'Error, \nNama barang tidak boleh kosong');
                          return;
                        }
                        controller.searchResultsBarang.clear();
                        _showQuantityDialog(nama);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorThird,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Tambah Barang Baru",
                        style: TStyle.captionWhite,
                      ),
                    ),
                  ],
                ),
              );
            } else if (controller.searchResultsBarang.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: kColorMediumGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.searchResultsBarang.length,
                  itemBuilder: (context, index) {
                    final barang = controller.searchResultsBarang[index];
                    return ListTile(
                      title: Text(barang.nama, style: TStyle.subtitle2),
                      onTap: () {
                        searchBarangController.text = barang.nama;
                        controller.searchResultsBarang.clear();
                        _showQuantityDialog(barang.nama);
                      },
                    );
                  },
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          const SizedBox(height: 16),
          Obx(() {
            return controller.searchQueryBarang.value.isNotEmpty &&
                    controller.searchResultsBarang.isEmpty
                ? const SizedBox.shrink()
                : ElevatedButton(
                    onPressed: () {
                      final nama = searchBarangController.text.trim();
                      if (nama.isEmpty) {
                        showErrorSnackbarFromTop(
                          'Error, \nNama barang tidak boleh kosong',
                        );
                        return;
                      }
                      controller.searchResultsBarang.clear();
                      _showQuantityDialog(nama);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorThird,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Tambah Barang",
                      style: TStyle.button1.copyWith(color: kColorPureWhite),
                    ),
                  );
          }),
        ],
      ),
    );
  }

  void _showQuantityDialog(String namaBarang) async {
    jumlahBarangController.text = '1';
    hargaBeliController.text = '';
    hargaJualController.text = '';
    bool updateHargaBeli = true;
    bool updateHargaJual = true;
    bool isExistingBarang = false;

    final barangData = await controller.checkExistingBarang(namaBarang);

    if (barangData != null) {
      isExistingBarang = true;
      updateHargaBeli = false;
      updateHargaJual = false;
      final hargaBeli = (barangData['harga'] ?? 0).toDouble();
      final hargaJual = (barangData['hargaJual'] ?? 0).toDouble();
      hargaBeliController.text =
          hargaBeli > 0 ? controller.formatNumber(hargaBeli) : '';
      hargaJualController.text =
          hargaJual > 0 ? controller.formatNumber(hargaJual) : '';
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Jumlah $namaBarang",
                    style: TStyle.headline3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: jumlahBarangController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Jumlah",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: updateHargaBeli,
                        onChanged: (value) {
                          setState(() {
                            updateHargaBeli = value ?? false;
                            if (!updateHargaBeli &&
                                isExistingBarang &&
                                barangData != null) {
                              final hargaBeli =
                                  (barangData['harga'] ?? 0).toDouble();
                              hargaBeliController.text = hargaBeli > 0
                                  ? controller.formatNumber(hargaBeli)
                                  : '';
                            }
                          });
                        },
                      ),
                      const Text("Update Harga Beli"),
                    ],
                  ),
                  TextField(
                    controller: hargaBeliController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    enabled: updateHargaBeli,
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      // Hapus titik pemisah untuk parsing
                      final cleanValue = value.replaceAll('.', '');
                      final number = double.tryParse(cleanValue) ?? 0;
                      // Format ulang dengan pemisah ribuan
                      final formatted = controller.formatNumber(number);
                      hargaBeliController.value = TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    },
                    decoration: InputDecoration(
                      labelText: "Harga Beli per Unit (Rp)",
                      border: const OutlineInputBorder(),
                      fillColor: updateHargaBeli
                          ? null
                          : kColorLightGrey.withOpacity(0.5),
                      filled: !updateHargaBeli,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: updateHargaJual,
                        onChanged: (value) {
                          setState(() {
                            updateHargaJual = value ?? false;
                            if (!updateHargaJual &&
                                isExistingBarang &&
                                barangData != null) {
                              final hargaJual =
                                  (barangData['hargaJual'] ?? 0).toDouble();
                              hargaJualController.text = hargaJual > 0
                                  ? controller.formatNumber(hargaJual)
                                  : '';
                            }
                          });
                        },
                      ),
                      const Text("Update Harga Jual"),
                    ],
                  ),
                  TextField(
                    controller: hargaJualController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    enabled: updateHargaJual,
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      // Hapus titik pemisah untuk parsing
                      final cleanValue = value.replaceAll('.', '');
                      final number = double.tryParse(cleanValue) ?? 0;
                      // Format ulang dengan pemisah ribuan
                      final formatted = controller.formatNumber(number);
                      hargaJualController.value = TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    },
                    decoration: InputDecoration(
                      labelText: "Harga Jual per Unit (Rp)",
                      border: const OutlineInputBorder(),
                      fillColor: updateHargaJual
                          ? null
                          : kColorLightGrey.withOpacity(0.5),
                      filled: !updateHargaJual,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                          final hargaBeli = double.tryParse(hargaBeliController
                                  .text
                                  .replaceAll('.', '')) ??
                              0;
                          final hargaJual = double.tryParse(hargaJualController
                                  .text
                                  .replaceAll('.', '')) ??
                              0;

                          if (jumlah <= 0) {
                            showErrorSnackbarFromTop(
                                "Error, \nJumlah harus lebih dari 0");
                            return;
                          }
                          if (updateHargaBeli && hargaBeli <= 0) {
                            showErrorSnackbarFromTop(
                              "Error, \nHarga beli harus lebih dari 0 jika diupdate",
                            );
                            return;
                          }
                          if (updateHargaJual && hargaJual <= 0) {
                            showErrorSnackbarFromTop(
                                "Error, \nHarga jual harus lebih dari 0 jika diupdate");
                            return;
                          }

                          final success = await controller.addItem(InvoiceItem(
                            nama: namaBarang,
                            jumlah: jumlah,
                            hargaBeli: hargaBeli,
                            hargaJual: hargaJual,
                            updateHargaBeli: updateHargaBeli,
                            updateHargaJual: updateHargaJual,
                          ));

                          if (success) {
                            Get.back();
                            searchBarangController.clear();
                            controller.searchQueryBarang.value = '';

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
              );
            },
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
                "Anda akan menyimpan invoice pembelian dengan:",
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
          const SizedBox(height: 16),
          Obx(() {
            return controller.items.isEmpty
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      return _buildItemCard(item, index);
                    },
                  );
          }),
        ],
      ),
    );
  }

  Widget _buildItemCard(InvoiceItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 4),
                Text(
                  "${item.jumlah} unit",
                  style: TStyle.body2.copyWith(color: kColorGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Harga Beli: Rp ${controller.formatNumber(item.hargaBeli)} / unit${item.updateHargaBeli ? '' : ' (tidak diupdate)'}",
                  style: TStyle.body2.copyWith(color: kColorGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Harga Jual: Rp ${controller.formatNumber(item.hargaJual)} / unit${item.updateHargaJual ? '' : ' (tidak diupdate)'}",
                  style: TStyle.body2.copyWith(color: kColorGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Subtotal: Rp ${controller.formatNumber(item.hargaBeli * item.jumlah)}",
                  style: TStyle.subtitle2,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: kColorFourth),
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
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 8),
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

          if (controller.namaPemasok.value.trim().isEmpty) {
            showErrorSnackbarFromTop("Error, \nHarap masukkan nama pemasok");
            return;
          }

          _showConfirmationDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kColorThird,
          minimumSize: const Size(double.infinity, 50),
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
