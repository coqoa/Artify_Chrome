import 'package:artify_chrome/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeatherInfo extends StatefulWidget {
  @override
  _WeatherInfoState createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  final WeatherService weatherService = WeatherService();
  Map<String, dynamic> weatherData = {};
  String date = '';
  String time = '';
  String dayOfWeek = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _updateDateTime();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await weatherService.getWeather();
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      date = DateFormat('yyyy, M, dd').format(now);
      dayOfWeek = DateFormat('EEEE').format(now);
      time = DateFormat('HH : mm').format(now);
    });
  }

  String getWeatherIcon(String description) {
    description = description.toLowerCase(); // 대소문자 구분을 없애기 위해 소문자로 변환

    if (description.contains('clear')) {
      return '☀️'; // 맑음
    } else if (description.contains('clouds')) {
      return '☁️'; // 구름 많음
    } else if (description.contains('rain')) {
      return '🌧️'; // 비
    } else if (description.contains('thunderstorm')) {
      return '⛈️'; // 천둥 번개
    } else if (description.contains('snow')) {
      return '❄️'; // 눈
    } else if (description.contains('mist') || description.contains('fog')) {
      return '🌫️'; // 안개
    } else {
      return '🌥️'; // 기타 (흐림 등)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          weatherData.isNotEmpty
              ? Text(
                  '${weatherData['city'] ?? ''}, ${weatherData['description'] ?? ''} ${getWeatherIcon(weatherData['description'] ?? '')}, ${weatherData['temperature'] ?? ''}°C',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 15,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(1), // 검정색 그림자
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
              : SizedBox(
                  height: 30,
                ), // 데이터가 없을 때는 빈 Container 표시
          SizedBox(height: 8),
          Text(
            '$date | $dayOfWeek',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 15,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0,
                  color: Colors.black.withOpacity(1), // 검정색 그림자
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            '$time',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 15,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0,
                  color: Colors.black.withOpacity(1), // 검정색 그림자
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
