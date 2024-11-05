import 'dart:convert';
import 'package:artify_chrome/controllers/my_controller.dart';
import 'package:artify_chrome/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:get/get.dart';

class ImageDisplay extends StatelessWidget {
  final MyController controller = Get.put(MyController());
  final storageService = Get.find<StorageService>();
  final random = Random();
  RxString selectedImageUrl = ''.obs;
  RxList<String> imageUrls = <String>[].obs; // RxList로 선언

  Future<void> _loadUrlData() async {
    try {
      // assets/image_links.json 파일에서 URL 데이터 불러오기
      final String jsonString =
          await rootBundle.loadString('assets/image_links.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // imageUrls 데이터를 List<String>으로 변환 후 RxList에 추가
      imageUrls.assignAll(List<String>.from(jsonData['animal']));

      // 데이터 로드 후 체크 실행
      checkPickedImg();
    } catch (e) {
      print('Error 11021440 : loading URL data: $e');
    }
  }

  Future<void> checkPickedImg() async {
    final data = await storageService.loadData('pickImage');
    if (data == null || data.isEmpty) {
      // 데이터가 없는 경우
      controller.isPickedImage.value = false;
      if (imageUrls.isNotEmpty) {
        selectedImageUrl.value = imageUrls[random.nextInt(imageUrls.length)];
      }
      print('저장된 이미지 url 없음');
    } else {
      // 데이터가 있는 경우
      controller.isPickedImage.value = true;
      selectedImageUrl.value = data;
      print('저장된 이미지 url 있음');
    }
  }

  Future<void> pickImage(String imageUrl) async {
    if (controller.isPickedImage.value == false) {
      storageService.saveData('pickImage', imageUrl);
      controller.isPickedImage.value = true;
    } else {
      storageService.saveData('pickImage', '');
      controller.isPickedImage.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadUrlData();

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
                          print('Image load error 11021456 : $error');
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
                  color: controller.isPickedImage.value == false
                      ? Colors.white.withOpacity(0.4)
                      : Colors.black.withOpacity(0.7),
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
            ),
          ),
        ),
      ],
    );
  }
}
