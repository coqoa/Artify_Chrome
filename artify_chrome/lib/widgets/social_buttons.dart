import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  final Map<String, dynamic> urlData;

  // urlData를 받아들이는 생성자 추가
  SocialButtons({required this.urlData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 예제 버튼 (블로그 URL)
        IconButton(
          icon: Icon(Icons.web),
          onPressed: () {
            final url = urlData['blog'];
            if (url != null) {
              // URL 열기 로직 추가 (예: url_launcher 패키지 사용)
            }
          },
        ),
        // 추가적인 소셜 버튼들...
      ],
    );
  }
}
