import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/home/productButtonController.dart';
import 'package:kertasinapp/controllers/home/user_controller.dart';
import 'package:kertasinapp/routes/route_name.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';
import 'package:kertasinapp/widgets/ButtonCard.dart';
import 'package:kertasinapp/widgets/ButtonDefault.dart';
import 'package:kertasinapp/widgets/CardNews.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  final userController = Get.find<UserController>();
  final controller = Get.put(ProductButtonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPureWhite,
      body: Obx(() {
        final userName = userController.userName.value;

        // Kasih loading kalau masih kosong
        if (userName.isEmpty) {
          return Container(
            color: kColorPureWhite,
            width: double.infinity,
            height: double.infinity,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return _buildContent(userName);
      }),
    );
  }

// Pindahkan isi UI utama ke method terpisah agar lebih clean
  Widget _buildContent(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: kColorFirst,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
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
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.06),
                Obx(
                  () => Text(
                    "Hi ${userController.userName.value.split(' ').first}, welcome to",
                    style: TStyle.subtitle1.copyWith(color: kColorPureWhite),
                  ),
                ),
                Text(
                  "KERTASIN",
                  style: TStyle.title.copyWith(color: kColorPureWhite),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Buttondefault(
                      onTap: () => {
                        Get.toNamed(RoutesName.addInvoicePenjualanPage),
                      },
                      text: "Buat Invoice Sekarang",
                      isPrimary: false,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: Get.height * 0.03),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Produk   >>", style: TStyle.body1),
                const SizedBox(height: 16),
                Obx(() => SizedBox(
                      height: Get.height * 0.05,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.productButtons.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8.0),
                        itemBuilder: (context, index) {
                          final item = controller.productButtons[index];
                          return ButtonCard(
                            text: item['text'],
                            onTap: item['onTap'],
                          );
                        },
                      ),
                    )),
                const SizedBox(height: 18),
                Image.asset(
                  "assets/img/iklan.png",
                  width: Get.width,
                  height: Get.height * 0.2,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 18),
                Text("Berita Kertasin.id   >>", style: TStyle.body1),
                CardNews(),
                CardNews(),
                CardNews(),
                SizedBox(height: Get.height * 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
