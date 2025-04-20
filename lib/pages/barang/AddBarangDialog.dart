import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kertasinapp/controllers/barang/barang_controller.dart';
import 'package:kertasinapp/model/barang/barang_model.dart';
import 'package:kertasinapp/utilities/colors.dart';
import 'package:kertasinapp/utilities/typhography.dart';
import 'package:flutter/services.dart';

class AddBarangDialog extends StatelessWidget {
  final BarangController controller = Get.find<BarangController>();
  final BarangModel? barang;

  AddBarangDialog({super.key, this.barang}) {
    if (barang != null) {
      controller.fillForm(barang!);
    } else {
      controller.clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = barang != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: kColorPureWhite,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? "Edit Barang" : "Tambah Barang",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                  floatingLabelStyle: TStyle.body2.copyWith(color: Colors.grey),
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
                validator: (value) => value == null || value.isEmpty ? 'Nama harus diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.hargaJualController,
                decoration: InputDecoration(
                  labelText: 'Harga Jual Barang',
                  floatingLabelStyle: TStyle.body2.copyWith(color: Colors.grey),
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
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga jual harus diisi';
                  final cleanValue = value.replaceAll('.', '');
                  if (int.tryParse(cleanValue) == null) return 'Harga jual harus berupa angka';
                  if (int.parse(cleanValue) <= 0) return 'Harga jual harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.stokController,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  floatingLabelStyle: TStyle.body2.copyWith(color: Colors.grey),
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
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Stok harus diisi';
                  if (int.tryParse(value) == null) return 'Stok harus berupa angka';
                  if (int.parse(value)! < 0) return 'Stok tidak boleh negatif';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Obx(() {
                return GestureDetector(
                  onTap: controller.isLoading.value
                      ? null
                      : () async {
                          if (controller.formKey.currentState!.validate()) {
                            if (isEdit) {
                              await controller.updateBarang(barang!.id);
                            } else {
                              await controller.addBarang();
                            }
                          }
                        },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: controller.isLoading.value ? Colors.grey : kColorFirst,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEdit ? 'Update' : 'Tambah',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits
    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format with thousand separators
    final number = int.parse(cleanText);
    final formatter = NumberFormat('#,##0', 'id_ID');
    final formatted = formatter.format(number);

    // Calculate cursor position
    final selectionIndex = newValue.selection.baseOffset;
    final newLength = formatted.length;
    final oldLength = oldValue.text.length;
    final offset = newLength - oldLength;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: selectionIndex + offset > 0 ? selectionIndex + offset : 0,
      ),
    );
  }
}