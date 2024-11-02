import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/main_search_bar.dart';
import '../widgets/image_display.dart';
import '../widgets/weather_info.dart';
import '../widgets/social_buttons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? urlData; // 타입 명확히 선언

  @override
  void initState() {
    super.initState();
    _loadUrlData();
  }

  Future<void> _loadUrlData() async {
    try {
      // assets/links.json 파일에서 URL 데이터 불러오기
      final String jsonString =
          // await rootBundle.loadString('assets/links.json');
          await rootBundle.loadString('links.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // imageUrls 데이터를 List<String>으로 변환
      List<String> imageUrls = List<String>.from(jsonData['imageUrls']);

      setState(() {
        urlData = jsonData;
        urlData!['imageUrls'] = imageUrls; // 변환된 List<String>을 urlData에 저장
      });
    } catch (e) {
      print('Error 11021440 : loading URL data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 배경 이미지
          // Positioned.fill(
          //   child: ImageDisplay(
          //       imageUrls: urlData!['imageUrls']), // 로컬 데이터에서 이미지 URL 리스트 전달
          // ),
          Positioned.fill(
            child: urlData != null && urlData!['imageUrls'] != null
                ? ImageDisplay(
                    imageUrls: urlData!['imageUrls']) // 이미지 URL 리스트 전달
                : Container(), // 데이터가 null인 경우 빈 화면 표시
          ),
          // 상단 날씨 정보
          Positioned(
            top: 40.0,
            left: 20.0,
            right: 20.0,
            child: WeatherInfo(), // 날씨 및 시간 정보 위젯
          ),
          // 중앙 검색창
          Center(
            child: MainSearchBar(), // 검색창 위젯
          ),
          // 하단 소셜 버튼들
          Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: urlData != null
                ? SocialButtons(urlData: urlData!)
                : CircularProgressIndicator(), // URL 데이터를 통해 버튼을 표시
          ),
        ],
      ),
    );
  }
}
