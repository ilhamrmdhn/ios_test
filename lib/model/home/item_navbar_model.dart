import 'package:flutter/material.dart';

class ItemNavbarModel {
  Icon icon;
  String title;
  Widget widget;

  ItemNavbarModel(
      {required this.widget, required this.icon, required this.title});
}
