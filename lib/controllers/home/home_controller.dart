import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kertasinapp/model/home/item_navbar_model.dart';
import 'package:kertasinapp/pages/home/HomeScreen.dart';
import 'package:kertasinapp/pages/pencatatanBiaya/pencatatanBiayaPage.dart';
import 'package:kertasinapp/pages/profile/ProfilePage.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  List<ItemNavbarModel> items = [
    ItemNavbarModel(
        widget: Homescreen(),
        icon: const Icon(Icons.home_outlined),
        title: "Home"),
    ItemNavbarModel(
        widget: PencatatanBiayaPage(),
        icon: const Icon(Icons.receipt_long),
        title: "Pencatatan"),
    ItemNavbarModel(
        widget: ProfilPage(), icon: const Icon(Icons.person), title: "Profile"),
  ];
}
