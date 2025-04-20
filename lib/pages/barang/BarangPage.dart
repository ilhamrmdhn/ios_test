import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/barang/barang_controller.dart';
import 'package:kertasinapp/pages/barang/AddBarangDialog.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';
import 'package:intl/intl.dart';

class BarangPage extends StatelessWidget {
  final BarangController controller = Get.put(BarangController());
  final NumberFormat numberFormat = NumberFormat('#,##0', 'id_ID');

  BarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPureWhite,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: MyClip(),
              child: Container(
                height: 200.0,
                color: kColorFirst,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Text("Barang", style: TStyle.titleWhite),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              color: kColorPureWhite,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Data Barang",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print('Opening AddBarangDialog');
                      Get.dialog(AddBarangDialog());
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.add, size: 18.0, color: Colors.grey),
                        SizedBox(width: 4.0),
                        Text(
                          "Add",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Cari barang...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (value) {
                  controller.searchQuery.value = value.toLowerCase();
                },
              ),
            ),
            Obx(() {
              if (controller.isFetching.value) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.barangList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(controller.searchQuery.value.isEmpty
                          ? "Belum ada data barang"
                          : "Tidak ditemukan barang dengan nama '${controller.searchQuery.value}'"),
                      if (controller.searchQuery.value.isNotEmpty) ...[
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            controller.searchController.clear();
                            controller.searchQuery.value = '';
                          },
                          child: Text("Tampilkan Semua"),
                        ),
                      ],
                    ],
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.barangList.length,
                itemBuilder: (context, index) {
                  final barang = controller.barangList[index];
                  return Container(
                    margin: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: index == 0 ? 0 : 12,
                      bottom: 12,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              barang.nama, // Display as-is (lowercase)
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                                "Harga Jual: Rp${numberFormat.format(barang.hargaJual)}"),
                            Text("Stok: ${barang.stok}"),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Get.dialog(AddBarangDialog(barang: barang));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                controller.deleteBarang(barang.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class MyClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 50.0);
    path.quadraticBezierTo(
        size.width - 70.0, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(size.width / 3.0, size.height - 32, 0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
