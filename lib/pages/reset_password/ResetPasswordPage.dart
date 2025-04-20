import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/resetPasswordController.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';
import 'package:kertasinapp/widgets/ButtonDefault.dart';
import 'package:kertasinapp/widgets/CustomeTextField.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller menggunakan GetX
    final ResetPasswordController controller = Get.put(ResetPasswordController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kColorPureWhite,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: Get.height * 0.06,
              width: Get.width,
              decoration: const BoxDecoration(
                color: kColorFirst,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(150),
                ),
              ),
            ),
          ),
          Positioned(
            top: Get.height * 0.2,
            left: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: kColorFirst,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            top: Get.height * 0.4,
            right: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: kColorFirst,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(100),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reset Password",
                  style: TStyle.title,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 217, 226, 255).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() => Column(
                          children: [
                            if (!controller.showSuccessMessage.value) ...[
                              CustomTextField(
                                hintText: 'Email',
                                controller: controller.emailController,
                              ),
                              const SizedBox(height: 16),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Buttondefault(
                                    text: "Kirim Link Reset Password",
                                    onTap: controller.isLoading.value
                                        ? null
                                        : controller.resetPassword,
                                  ),
                                  if (controller.isLoading.value)
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          kColorPrimary),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Kembali ke",
                                    style: TStyle.textChat,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      " Login",
                                      style: TStyle.textChat
                                          .copyWith(color: kColorPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Text(
                                "Link Reset Password Terkirim",
                                style: TStyle.subtitle1
                                    .copyWith(color: kColorDarkGrey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Link reset password telah dikirim ke (${controller.emailController.text}). Silakan cek inbox atau folder spam Anda.",
                                style: TStyle.body2,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Buttondefault(
                                    text: "Kirim Ulang Link",
                                    onTap: controller.isLoading.value
                                        ? null
                                        : controller.resetPassword,
                                  ),
                                  if (controller.isLoading.value)
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          kColorPrimary),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Kembali ke",
                                    style: TStyle.textChat,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      " Login",
                                      style: TStyle.textChat
                                          .copyWith(color: kColorPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: Get.height * 0.06,
              width: Get.width,
              decoration: const BoxDecoration(
                color: kColorFirst,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(150),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}