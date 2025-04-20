import 'package:get/get.dart';

class ButtonController extends GetxController {
  var scale = 1.0.obs;

  void pressDown() => scale.value = 0.95;
  void pressUp() => scale.value = 1.0;
}
