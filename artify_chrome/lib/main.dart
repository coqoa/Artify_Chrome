import 'package:artify_chrome/controllers/my_controller.dart';
import 'package:artify_chrome/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(StorageService());
  Get.put(MyController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Artify Chrome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // 메인 화면을 HomeScreen으로 설정
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
    );
  }
}
