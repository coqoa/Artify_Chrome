import 'package:artify_chrome/controllers/my_controller.dart';
import 'package:artify_chrome/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';

class ImageDisplay extends StatelessWidget {
  final List<String> imageUrls;
  final MyController controller = Get.put(MyController());
  final StorageService storageService = StorageService();
  final random = Random();
  RxString selectedImageUrl = ''.obs; // RxString으로 선언하여 상태를 반응형으로 관리

  // 생성자에서 이미지 URL 리스트를 받아옴
  ImageDisplay({required this.imageUrls});

  Future<void> checkPickedImg() async {
    final data = await storageService.loadData('pickImage');
    if (data == null || data.isEmpty) {
      // 데이터가 없는 경우
      controller.isPickedImage.value = false;
      selectedImageUrl.value = imageUrls[random.nextInt(imageUrls.length)];
      print('로컬스토리지 데이터 없음');
    } else {
      // 데이터가 있는 경우
      controller.isPickedImage.value = true;
      selectedImageUrl.value = await storageService.loadData('pickImage') ?? '';
      print('로컬스토리지 데이터 있음');
    }
  }

  Future<void> pickImage(String imageUrl) async {
    storageService.saveData('pickImage', imageUrl);
    controller.isPickedImage.value = true;
    final data = await storageService.loadData('pickImage');
    print(data);
    print('-=-=-=--=-=-=--=');
  }

  @override
  Widget build(BuildContext context) {
    // 상태 변화를 감지하여 UI가 자동 업데이트되도록 `Obx`로 감쌈
    checkPickedImg();

    return Stack(
      children: [
        // 배경 이미지
        Obx(() => Container(
              decoration: BoxDecoration(
                image: selectedImageUrl.value.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(selectedImageUrl.value),
                        fit: BoxFit.cover, // 이미지를 화면에 꽉 채우기
                        onError: (error, stackTrace) {
                          print(
                              'Image load error 11021456 : $error'); // 에러 로그 출력
                        },
                      )
                    : null, // 초기화되지 않았을 때는 이미지를 표시하지 않음
              ),
              child: selectedImageUrl.value.isEmpty
                  ? Center(
                      child: CircularProgressIndicator()) // 초기화 전 로딩 인디케이터 표시
                  : null, // 초기화되면 이미지만 표시
            )),
        // 우측 상단에 커스터마이징 가능한 컨테이너 추가
        Positioned(
          top: 80.0, // 상단에서의 위치 조정
          right: 20.0, // 우측에서의 위치 조정
          child: GestureDetector(
            onTap: () {
              pickImage(selectedImageUrl.value);
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // 배경색 (원하는 대로 변경 가능)
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child:
                  Icon(Icons.check, color: Colors.black), // 아이콘 (원하는 대로 변경 가능)
            ),
          ),
        ),
      ],
    );
  }
}

// 데이터 있을 때 없을 때 체크버튼 디자인 변경하기
// 데이터 있을 때 체크버튼 누르면 데이터 비우기 기능 구현
