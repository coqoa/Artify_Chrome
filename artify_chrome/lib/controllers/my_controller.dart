import 'package:get/get.dart';

class MyController extends GetxController {
  var isPickedImage = false.obs;

  void isPickImageBtnClicked() {
    isPickedImage.value = !isPickedImage.value;
  }
}
