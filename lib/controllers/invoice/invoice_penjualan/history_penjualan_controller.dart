import 'package:get/get.dart';

import '../../../model/invoice/history_pembelian/history_penjualan_model.dart';

class HistoryPenjualanController extends GetxController {
  var filters = <HistoryPenjualanModel>[
    HistoryPenjualanModel(label: 'All'),
    HistoryPenjualanModel(label: 'January', month: 1),
    HistoryPenjualanModel(label: 'February', month: 2),
    HistoryPenjualanModel(label: 'March', month: 3),
    HistoryPenjualanModel(label: 'April', month: 4),
    HistoryPenjualanModel(label: 'Mei', month: 5),
    HistoryPenjualanModel(label: 'Juni', month: 6),
  ].obs;

  var selectedIndex = 0.obs;

  void selectFilter(int index) {
    selectedIndex.value = index;
  }
}
