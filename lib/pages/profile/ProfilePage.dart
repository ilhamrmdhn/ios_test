import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/controllers/profileController.dart';
import 'package:kertasinapp/pages/home/HomeScreen.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Obx(() {
      if (controller.userData.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final userName =
          controller.userData.value?['name'] as String? ?? 'Unknown';
      final userEmail =
          controller.userData.value?['email'] as String? ?? 'Unknown';
      final userRole = controller.userData.value?['role'] as String? ?? '';

      return Stack(
        children: [
          Scaffold(
            backgroundColor: kColorPureWhite,
            body: CustomScrollView(
              slivers: [
                // Bagian yang dipin: "Akun Saya" dan ikon edit/simpan
                SliverAppBar(
                  pinned: true,
                  backgroundColor: kColorFirst,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 48.0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Akun Saya",
                        style: TStyle.subtitle1.copyWith(
                          color: kColorPureWhite,
                          fontSize: 16,
                        ),
                      ),
                      Obx(() => Row(
                            children: [
                              if (!controller.isEditing.value)
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: kColorPureWhite),
                                  onPressed: () {
                                    controller.toggleEditMode();
                                  },
                                  tooltip: "Edit Profil",
                                ),
                              if (controller.isEditing.value)
                                IconButton(
                                  icon: const Icon(Icons.save,
                                      color: kColorPureWhite),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Konfirmasi"),
                                        content: const Text(
                                            "Apakah Anda yakin ingin menyimpan perubahan?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              controller.saveData();
                                            },
                                            child: const Text("Simpan"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  tooltip: "Simpan",
                                ),
                            ],
                          )),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          color: kColorFirst,
                          borderRadius: const BorderRadius.only(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: kColorPureWhite,
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: kColorFirst,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kColorPureWhite,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        userRole.isNotEmpty
                                            ? userRole
                                            : 'Role belum diisi',
                                        style: TStyle.caption.copyWith(
                                          color: kColorFirst,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName,
                                        style: TStyle.title.copyWith(
                                          color: kColorPureWhite,
                                          fontSize: 20,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        userEmail,
                                        style: TStyle.body2.copyWith(
                                          color: kColorPureWhite,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      // Progress Bar
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${controller.completionPercentage.value.toStringAsFixed(0)}%",
                                  style: TStyle.subtitle1.copyWith(
                                    color: kColorFirst,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    controller.incompleteFieldsMessage.value,
                                    style: TStyle.body2.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value:
                                  controller.completionPercentage.value / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                kColorFirst,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Data Perusahaan
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Data Perusahaan",
                          style: TStyle.subtitle1.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Obx(() => TextFormField(
                                  controller:
                                      controller.namaPerusahaanController,
                                  enabled: controller.isEditing.value,
                                  decoration: InputDecoration(
                                    labelText: "Nama Perusahaan",
                                    labelStyle: TStyle.body2.copyWith(
                                      color: Colors.grey,
                                    ),
                                    floatingLabelStyle: TStyle.body2.copyWith(
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 16),
                            Obx(() => TextFormField(
                                  controller: controller.bidangController,
                                  enabled: controller.isEditing.value,
                                  decoration: InputDecoration(
                                    labelText: "Bidang",
                                    labelStyle: TStyle.body2.copyWith(
                                      color: Colors.grey,
                                    ),
                                    floatingLabelStyle: TStyle.body2.copyWith(
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 16),
                            Obx(() => TextFormField(
                                  controller: controller.alamatController,
                                  enabled: controller.isEditing.value,
                                  decoration: InputDecoration(
                                    labelText: "Alamat",
                                    labelStyle: TStyle.body2.copyWith(
                                      color: Colors.grey,
                                    ),
                                    floatingLabelStyle: TStyle.body2.copyWith(
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Data Pribadi
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Data Pribadi",
                          style: TStyle.subtitle1.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Obx(() => TextFormField(
                                  controller: controller.namaLengkapController,
                                  enabled: controller.isEditing.value,
                                  decoration: InputDecoration(
                                    labelText: "Nama Lengkap",
                                    labelStyle: TStyle.body2.copyWith(
                                      color: Colors.grey,
                                    ),
                                    floatingLabelStyle: TStyle.body2.copyWith(
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: userEmail,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TStyle.body2.copyWith(
                                  color: Colors.grey,
                                ),
                                floatingLabelStyle: TStyle.body2.copyWith(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildRoleDropdown(controller),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Tombol Keluar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: controller.signOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            "Keluar",
                            style: TStyle.body1.copyWith(
                              color: kColorPureWhite,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.1),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() => controller.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink()),
        ],
      );
    });
  }

  // Widget terpisah untuk dropdown role
  Widget buildRoleDropdown(ProfileController controller) {
    return Obx(() => Column(
          children: [
            DropdownButtonFormField<String>(
              value: controller.selectedRole.value,
              decoration: InputDecoration(
                labelText: "Role",
                labelStyle: TStyle.body2.copyWith(
                  color: Colors.grey,
                ),
                floatingLabelStyle: TStyle.body2.copyWith(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              items: controller.roleOptions.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: controller.isEditing.value
                  ? (String? newValue) {
                      controller.selectedRole.value = newValue;
                      controller.showRoleManualField.value =
                          newValue == 'Lainnya';
                      if (!controller.showRoleManualField.value) {
                        controller.roleManualController.clear();
                      }
                      controller.updateCurrentRole();
                      controller.calculateAndUpdateCompletion();
                    }
                  : null,
            ),
            if (controller.showRoleManualField.value &&
                controller.isEditing.value) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.roleManualController,
                onChanged: (value) {
                  controller.updateCurrentRole();
                  controller.calculateAndUpdateCompletion();
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      ProfileController.maxRoleLength),
                ],
                decoration: InputDecoration(
                  labelText: "Masukkan Role",
                  labelStyle: TStyle.body2.copyWith(
                    color: Colors.grey,
                  ),
                  floatingLabelStyle: TStyle.body2.copyWith(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ],
        ));
  }
}
