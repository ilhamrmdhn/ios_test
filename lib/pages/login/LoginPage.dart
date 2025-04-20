import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/loginController.dart';
import 'package:kertasinapp/pages/register/RegisterPage.dart';
import 'package:kertasinapp/pages/reset_password/ResetPasswordPage.dart';
import 'package:kertasinapp/utilities/assets_constants.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';
import 'package:kertasinapp/widgets/ButtonDefault.dart';
import 'package:kertasinapp/widgets/CustomeTextField.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller menggunakan GetX
    final LoginController controller = Get.put(LoginController());

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
            top: Get.height * 0.3,
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
            top: Get.height * 0.5,
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
          Column(
            children: [
              const Spacer(),
              Text(
                "Log In",
                style: TStyle.title,
              ),
              Container(
                margin: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 217, 226, 255)
                      .withOpacity(0.25),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() => Column(
                        children: [
                          if (!controller.showVerificationMessage.value) ...[
                            CustomTextField(
                              hintText: 'Email',
                              controller: controller.emailController,
                            ),
                            CustomTextField(
                              hintText: 'Password',
                              isPassword: true,
                              controller: controller.passwordController,
                            ),
                            const SizedBox(height: 16),
                            Buttondefault(
                              text: "Login",
                              onTap: controller.login,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Belum punya akun?",
                                  style: TStyle.textChat,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => const RegisterPage());
                                  },
                                  child: Text(
                                    " Register",
                                    style: TStyle.textChat
                                        .copyWith(color: kColorPrimary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Lupa kata sandi?",
                                  style: TStyle.textChat,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => const ResetPasswordPage());
                                  },
                                  child: Text(
                                    " Reset Password",
                                    style: TStyle.textChat
                                        .copyWith(color: kColorPrimary),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Text(
                              "Verifikasi Email Anda",
                              style: TStyle.subtitle1
                                  .copyWith(color: kColorDarkGrey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Email Anda (${controller.emailController.text}) belum diverifikasi. Silakan cek inbox atau spam folder Anda.",
                              style: TStyle.body2,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Buttondefault(
                              text: "Kirim Ulang Email Verifikasi",
                              onTap: controller.resendVerificationEmail,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Email sudah terverifikasi?",
                                  style: TStyle.textChat,
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.showVerificationMessage.value =
                                        false;
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
              Obx(() => SizedBox(
                    height: controller.showVerificationMessage.value
                        ? Get.height *
                            0.2 // Tinggi untuk tampilan Kirim Ulang Verifikasi
                        : Get.height * 0.1, // Tinggi untuk tampilan Login
                  )),
              Obx(() => !controller.showVerificationMessage.value
                  ? Column(
                      children: [
                        Text(
                          "atau Login Cepat dengan",
                          style: TStyle.textChat,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              onPressed: controller.handleGoogleSignIn,
                              icon: Image.asset(
                                AssetsConstant.icGoogle,
                                width: 46,
                                height: 46,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            if (controller.isLoading.value)
                              const CircularProgressIndicator(),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 26),
              Container(
                height: Get.height * 0.06,
                decoration: const BoxDecoration(
                  color: kColorFirst,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(150),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}