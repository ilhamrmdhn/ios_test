import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/registerController.dart';
import 'package:kertasinapp/pages/login/LoginPage.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';
import 'package:kertasinapp/widgets/ButtonDefault.dart';
import 'package:kertasinapp/widgets/CustomeTextField.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller menggunakan GetX
    final RegisterController controller = Get.put(RegisterController());

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
                "Register",
                style: TStyle.title,
              ),
              Container(
                margin: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 217, 226, 255).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: 'Name',
                        controller: controller.nameController,
                      ),
                      CustomTextField(
                        hintText: 'Email',
                        controller: controller.emailController,
                      ),
                      CustomTextField(
                        hintText: 'Password',
                        isPassword: true,
                        controller: controller.passwordController,
                      ),
                      CustomTextField(
                        hintText: 'Confirm Password',
                        isPassword: true,
                        controller: controller.confirmPasswordController, // Field baru
                      ),
                      const SizedBox(height: 16),
                      Obx(() => Stack(
                            alignment: Alignment.center,
                            children: [
                              Buttondefault(
                                text: "Register",
                                onTap: controller.register,
                              ),
                              if (controller.isLoading.value)
                                const CircularProgressIndicator(),
                            ],
                          )),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah punya akun?",
                            style: TStyle.textChat,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => const LoginPage());
                            },
                            child: Text(
                              " Login",
                              style: TStyle.textChat.copyWith(color: kColorPrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.2,
              ),
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