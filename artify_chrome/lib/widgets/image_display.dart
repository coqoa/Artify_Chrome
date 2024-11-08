import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:artify_chrome/controllers/my_controller.dart';

class ImageDisplay extends StatelessWidget {
  final MyController controller = Get.find<MyController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 이미지
        Obx(() => Container(
              decoration: BoxDecoration(
                image: controller.selectedImageUrl.value.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(controller.selectedImageUrl.value),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) {
                          print('Image load error: $error');
                        },
                      )
                    : null,
              ),
              child: controller.selectedImageUrl.value.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : null,
            )),

        // 우측 상단 하트 아이콘
        Positioned(
          top: 10.0,
          right: 10.0,
          child: InkWell(
            onTap: () {
              controller.pickImage(controller.selectedImageUrl.value);
            },
            child: Obx(
              () => Icon(
                Icons.favorite,
                color: controller.isPickedImage.value
                    ? Color(0xFFFF6E6E)
                    : Colors.white.withOpacity(0.4),
                size: 25.0,
              ),
            ),
          ),
        ),

        // 우측 상단 카테고리 아이콘
        Positioned(
          top: 10.0,
          right: 50.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  controller.showCategoryList.value =
                      !controller.showCategoryList.value;
                },
                child: Icon(
                  Icons.filter_list,
                  color: Colors.white.withOpacity(0.4),
                  size: 25.0,
                ),
              ),
              // 카테고리 목록 모달
              Obx(() => controller.showCategoryList.value
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
                            onTap: () => controller.selectCategory('All'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8.0),
                              child: Text(
                                'All',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      controller.selectedCategory.value == 'All'
                                          ? Colors.black
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          for (String category in controller.jsonData.keys)
                            InkWell(
                              onTap: () => controller.selectCategory(category),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: controller.selectedCategory.value ==
                                            category
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ],
    );
  }
}
