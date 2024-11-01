import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.black.withOpacity(0.5), // 임시 배경색
      child: Center(
        child: Text(
          "Weather Info",
          style: TextStyle(color: Colors.white), // 임시 텍스트 스타일
        ),
      ),
    );
  }
}
