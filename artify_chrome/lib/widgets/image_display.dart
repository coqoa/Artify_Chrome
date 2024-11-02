import 'package:flutter/material.dart';
import 'dart:math';

class ImageDisplay extends StatelessWidget {
  final List<String> imageUrls;

  // 생성자에서 이미지 URL 리스트를 받아옴
  ImageDisplay({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    // 랜덤으로 이미지 URL을 선택
    final random = Random();
    final String selectedImageUrl = imageUrls[random.nextInt(imageUrls.length)];

    return SizedBox();
    // return Container(
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //       image: NetworkImage(selectedImageUrl),
    //       fit: BoxFit.cover, // 이미지를 화면에 꽉 채우기
    //     ),
    //   ),
    // );
  }
}
