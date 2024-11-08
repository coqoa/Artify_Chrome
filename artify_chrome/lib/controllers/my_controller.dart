import 'package:artify_chrome/services/storage_service.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class MyController extends GetxController {
  // 로컬스토리지 상태 관리
  final StorageService storageService = StorageService();
  final random = Random();

  RxBool isPickedImage = false.obs;
  RxString selectedImageUrl = ''.obs;
  RxMap<String, dynamic> jsonData = RxMap<String, dynamic>();
  RxList<String> imageUrls = RxList<String>();
  RxBool showCategoryList = false.obs;
  RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCategoryAndLoadData();
    checkPickedImg();
  }

  Future<void> _initializeCategoryAndLoadData() async {
    final storedCategory = await storageService.loadData('pickImageCategory');
    selectedCategory.value = storedCategory ?? 'All';
    storageService.saveData('pickImageCategory', selectedCategory.value);
    await _loadUrlData();
  }

  Future<void> _loadUrlData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/image_links.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      jsonData.assignAll(data);
      selectCategory(selectedCategory.value);
    } catch (e) {
      print('Error loading URL data: $e');
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    storageService.saveData('pickImageCategory', category);

    if (jsonData.isNotEmpty) {
      if (category == 'All') {
        final allImages =
            jsonData.values.expand((urls) => List<String>.from(urls)).toList();
        imageUrls.assignAll(allImages);
      } else {
        imageUrls.assignAll(List<String>.from(jsonData[category] ?? []));
      }
      if (imageUrls.isNotEmpty && !isPickedImage.value) {
        selectedImageUrl.value = imageUrls[random.nextInt(imageUrls.length)];
      }
    }
    showCategoryList.value = false;
  }

  Future<void> checkPickedImg() async {
    final data = await storageService.loadData('pickImage');
    isPickedImage.value = data != null && data.isNotEmpty;
    selectedImageUrl.value = isPickedImage.value && data != null
        ? data
        : (imageUrls.isNotEmpty
            ? imageUrls[random.nextInt(imageUrls.length)]
            : '');
  }

  Future<void> pickImage(String imageUrl) async {
    isPickedImage.value = !isPickedImage.value;
    final value = isPickedImage.value ? imageUrl : '';
    storageService.saveData('pickImage', value);
    selectedImageUrl.value =
        value.isNotEmpty ? value : imageUrls[random.nextInt(imageUrls.length)];
  }
}
