import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class WeatherService {
  String? _apiKey;
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // API 키를 json 파일에서 불러오는 함수
  Future<void> _loadApiKey() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/api_keys.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _apiKey = jsonData['weather_api_key'];
      print('API Key loaded: $_apiKey'); // 디버깅용 로그
    } catch (e) {
      print('Error loading API key: $e');
      throw Exception('Failed to load API key');
    }
  }

  // 위치 권한을 확인하는 함수
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // 위치 서비스가 비활성화된 경우
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false; // 권한이 거부된 경우
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false; // 권한이 영구적으로 거부된 경우
    }

    return true; // 권한이 허용된 경우
  }

  // 위치 권한을 요청하고 현재 위치를 가져옵니다.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 현재 위치 가져오기
    return await Geolocator.getCurrentPosition();
  }

  // 날씨 정보 가져오기
  Future<Map<String, dynamic>> getWeather() async {
    try {
      // API 키가 로드되지 않았다면 로드
      if (_apiKey == null) await _loadApiKey();

      if (_apiKey == null) {
        throw Exception("API key is not loaded");
      }

      // 위치 정보 요청 시작 시간 기록
      final positionStart = DateTime.now();
      Position position = await _determinePosition();
      final positionEnd = DateTime.now();
      print(
          'Position retrieval took: ${positionEnd.difference(positionStart).inMilliseconds} ms');

      // 날씨 API 요청 시작 시간 기록
      final apiStart = DateTime.now();
      final url = Uri.parse(
          '$_baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric');
      final response = await http.get(url);
      final apiEnd = DateTime.now();
      print('API call took: ${apiEnd.difference(apiStart).inMilliseconds} ms');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print('Weather data: $data');
        return {
          "temperature": data['main']['temp'],
          "description": data['weather'][0]['description'],
          "city": data['name'],
          "country": data['sys']['country']
        };
      } else {
        print(
            'Failed to load weather data. Status code: ${response.statusCode}');
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  // 현재 시간과 날짜 가져오기
  Map<String, String> getCurrentDateTime() {
    final now = DateTime.now();
    return {
      "date": "${now.year}-${now.month}-${now.day}",
      "time": "${now.hour}:${now.minute.toString().padLeft(2, '0')}"
    };
  }
}
