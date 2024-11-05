import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:artify_chrome/controllers/my_controller.dart';
import 'package:artify_chrome/services/storage_service.dart';

class ImageDisplay extends StatelessWidget {
  final MyController controller = Get.put(MyController());
  final StorageService storageService = Get.find<StorageService>();
  final random = Random();
  RxString selectedImageUrl = ''.obs;
  RxMap<String, dynamic> jsonData = <String, dynamic>{}.obs;
  RxList<String> imageUrls = <String>[].obs;
  RxBool showCategoryList = false.obs;
  RxString selectedCategory = 'All'.obs;

  ImageDisplay({Key? key}) : super(key: key) {
    _initializeCategoryAndLoadData();
  }

  Future<void> _initializeCategoryAndLoadData() async {
    final storedCategory = await storageService.loadData('pickImageCategory');
    if (storedCategory == null || storedCategory.isEmpty) {
      selectedCategory.value = 'All';
      storageService.saveData('pickImageCategory', 'All');
    } else {
      selectedCategory.value = storedCategory;
    }
    _loadUrlData();
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
        List<String> allImages = [];
        jsonData.forEach((_, urls) {
          allImages.addAll(List<String>.from(urls));
        });
        imageUrls.assignAll(allImages);
      } else if (jsonData.containsKey(category)) {
        imageUrls.assignAll(List<String>.from(jsonData[category]));
      }
      if (imageUrls.isNotEmpty) {
        selectedImageUrl.value = imageUrls[random.nextInt(imageUrls.length)];
      }
    } else {
      print("Data not loaded yet.");
    }
    showCategoryList.value = false;
  }

  Future<void> checkPickedImg() async {
    final data = await storageService.loadData('pickImage');
    if (data == null || data.isEmpty) {
      controller.isPickedImage.value = false;
      selectedImageUrl.value = imageUrls.isNotEmpty
          ? imageUrls[random.nextInt(imageUrls.length)]
          : '';
    } else {
      controller.isPickedImage.value = true;
      selectedImageUrl.value = data;
    }
  }

  Future<void> pickImage(String imageUrl) async {
    if (!controller.isPickedImage.value) {
      storageService.saveData('pickImage', imageUrl);
      controller.isPickedImage.value = true;
    } else {
      storageService.saveData('pickImage', '');
      controller.isPickedImage.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkPickedImg();

    return Stack(
      children: [
        // 배경 이미지
        Obx(() => Container(
              decoration: BoxDecoration(
                image: selectedImageUrl.value.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(selectedImageUrl.value),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) {
                          print('Image load error: $error');
                        },
                      )
                    : null,
              ),
              child: selectedImageUrl.value.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : null,
            )),

        // 우측 상단 체크 아이콘
        Positioned(
          top: 30.0,
          right: 30.0,
          child: InkWell(
              onTap: () {
                pickImage(selectedImageUrl.value);
              },
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: controller.isPickedImage.value
                        ? Colors.black.withOpacity(0.7)
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              )),
        ),

        // 좌측 상단 카테고리 선택 버튼
        Positioned(
          top: 30.0,
          left: 30.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  showCategoryList.value = !showCategoryList.value;
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.category,
                    color: Colors.black,
                  ),
                ),
              ),

              // 카테고리 목록 표시
              Obx(() => showCategoryList.value
                  ? Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => selectCategory('All'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8.0),
                              child: Text(
                                'All',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: selectedCategory.value == 'All'
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          for (String category in jsonData.keys)
                            InkWell(
                              onTap: () {
                                selectCategory(category);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedCategory.value == category
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Container()),
            ],
          ),
        ),
      ],
    );
  }
}
