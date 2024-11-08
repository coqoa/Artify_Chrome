import 'package:artify_chrome/controllers/my_controller.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import '../widgets/main_search_bar.dart';
import '../widgets/image_display.dart';
import '../widgets/weather_info.dart';
import '../widgets/social_buttons.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<MyController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: ImageDisplay()),
          // 상단 날씨 정보
          Positioned(
            top: 40.0,
            left: 20.0,
            right: 20.0,
            child: WeatherInfo(), // 날씨 및 시간 정보 위젯
          ),
          MainSearchBar()
          // 하단 소셜 버튼들
          // Positioned(
          //   bottom: 20.0,
          //   left: 0.0,
          //   right: 0.0,
          //   // child: urlData != null
          //   //     ? SocialButtons(urlData: urlData!)
          //   //     : CircularProgressIndicator(), // URL 데이터를 통해 버튼을 표시
          // ),
        ],
      ),
    );
  }
}
