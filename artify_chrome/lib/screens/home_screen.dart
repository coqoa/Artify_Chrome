import 'package:flutter/material.dart';
import '../widgets/image_display.dart';
import '../widgets/weather_info.dart';
import '../widgets/main_search_bar.dart';
import '../widgets/social_buttons.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 기본 배경색 설정 (반응형으로 수정 가능)
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: ImageDisplay(), // Firebase에서 이미지를 랜덤으로 불러오는 위젯
          ),
          // 상단 날씨 정보
          Positioned(
            top: 40.0, // 화면 상단에서 간격
            left: 20.0,
            right: 20.0,
            child: WeatherInfo(), // 날씨, 온도, 시간 표시
          ),
          // 중앙 검색창
          Center(
            child: MainSearchBar(), // 검색창 위젯
          ),
          // 하단 소셜 버튼들
          Positioned(
            bottom: 20.0, // 화면 하단에서 간격
            left: 0.0,
            right: 0.0,
            child: Center(
              child: SocialButtons(), // 유튜브, 인스타, 블로그, 메일 버튼
            ),
          ),
        ],
      ),
    );
  }
}
