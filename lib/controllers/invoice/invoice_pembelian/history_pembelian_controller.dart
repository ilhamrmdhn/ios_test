import 'package:get/get.dart';

import '../../../model/invoice/history_pembelian/history_pembelian_model.dart';

class HistoryPembelianController extends GetxController {
  var filters = <HistoryPembelianModel>[
    HistoryPembelianModel(label: 'All'),
    HistoryPembelianModel(label: 'January', month: 1),
    HistoryPembelianModel(label: 'February', month: 2),
    HistoryPembelianModel(label: 'March', month: 3),
    HistoryPembelianModel(label: 'April', month: 4),
    HistoryPembelianModel(label: 'Mei', month: 5),
    HistoryPembelianModel(label: 'Juni', month: 6),
  ].obs;

  var selectedIndex = 0.obs;

  void selectFilter(int index) {
    selectedIndex.value = index;
  }
}
