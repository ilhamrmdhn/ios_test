import 'package:get/get.dart';
import 'package:kertasinapp/pages/barang/BarangPage.dart';
import 'package:kertasinapp/pages/invoice/invoice_pembelian/InvoicePembelianPage.dart';
import 'package:kertasinapp/pages/invoice/invoice_penjualan/InvoicePenjualanPage.dart';
import 'package:kertasinapp/pages/invoice/invoice_pembelian/TambahInvoicePembelianPage.dart';
import 'package:kertasinapp/pages/invoice/invoice_penjualan/TambahInvoicePenjualanPage.dart';
import 'package:kertasinapp/pages/invoice/invoice_pembelian/history_pembelian_page.dart';
import 'package:kertasinapp/pages/invoice/invoice_penjualan/history_penjualan_page.dart';
import 'package:kertasinapp/pages/login/LoginPage.dart';
import 'package:kertasinapp/pages/main/main_page.dart';
import 'package:kertasinapp/pages/pencatatanBiaya/pencatatanBiayaPage.dart';
import 'package:kertasinapp/pages/profile/ProfilePage.dart';
import 'package:kertasinapp/routes/route_name.dart';
import 'package:kertasinapp/pages/home/HomeScreen.dart';

class PagesRoute {
  static final pages = [
    GetPage(name: RoutesName.homeScreen, page: () => Homescreen()),
    GetPage(name: RoutesName.loginPage, page: () => LoginPage()),
    GetPage(
        name: RoutesName.invoicePembelianPage,
        page: () => InvoicePembelianPage()),
    GetPage(
        name: RoutesName.invoicePenjualanPage,
        page: () => InvoicePenjualanPage()),
    GetPage(name: RoutesName.mainPage, page: () => MainPage()),
    GetPage(name: RoutesName.barangPage, page: () => BarangPage()),
    GetPage(name: RoutesName.profilePage, page: () => ProfilPage()),
    GetPage(
        name: RoutesName.historyPembelianPage,
        page: () => HistoryPembelianPage()),
    GetPage(
        name: RoutesName.historyPenjualanPage,
        page: () => HistoryPenjualanPage()),
    GetPage(
        name: RoutesName.addInvoicePembelianPage,
        page: () => TambahInvoicePembelianPage()),
    GetPage(
        name: RoutesName.addInvoicePenjualanPage,
        page: () => TambahInvoicePenjualanPage()),
    GetPage(
        name: RoutesName.pencatatanBiayaPage,
        page: () => PencatatanBiayaPage()),
  ];
}
