import 'package:artify_chrome/services/storage_service.dart';
import 'package:get/get.dart';

class MyController extends GetxController {
  // 로컬스토리지 상테 관리
  final StorageService storageService = StorageService();

  var isPickedImage = false.obs;

  void isPickImageBtnClicked() {
    isPickedImage.value = !isPickedImage.value;
  }
}
