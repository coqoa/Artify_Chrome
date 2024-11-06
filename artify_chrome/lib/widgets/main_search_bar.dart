import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class MainSearchBar extends StatefulWidget {
  @override
  _MainSearchBarState createState() => _MainSearchBarState();
}

class _MainSearchBarState extends State<MainSearchBar> {
  String selectedEngine = 'Google'; // 기본 검색 엔진
  final List<String> searchEngines = ['Google', 'Naver', 'Perplexity'];
  Map<String, dynamic> urlData = {}; // JSON 데이터 저장

  @override
  void initState() {
    super.initState();
    _loadUrlData(); // 초기 데이터 로드
  }

  Future<void> _loadUrlData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/search_engine_list.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        urlData = jsonData;
      });
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  void _showEngineSelectionModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 20,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...searchEngines.map((engine) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedEngine = engine;
                      });
                      Navigator.pop(context); // 모달 닫기
                    },
                    splashColor: Colors.transparent, // 클릭 효과 제거
                    highlightColor: Colors.transparent, // 하이라이트 효과 제거
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        engine,
                        style: TextStyle(
                          color: selectedEngine == engine
                              ? Colors.black87
                              : Colors.grey[500],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double searchBarWidth = screenWidth * 0.85; // 화면 너비의 85% 차지
    double maxSearchBarWidth = 1200; // 최대 너비 설정
    double searchBarHeight;
    double fontSize;
    double iconSize;

    // 반응형 - 검색 창 세로
    if (screenWidth >= 1200) {
      // 컴퓨터
      searchBarHeight = 44.0;
    } else if (screenWidth >= 600) {
      // 태블릿
      searchBarHeight = 40.0;
    } else {
      // 모바일
      searchBarHeight = 36.0;
    }
    // 반응형 - 폰트 사이즈
    if (screenWidth >= 1200) {
      fontSize = 15.0; // 데스크탑
    } else if (screenWidth >= 600) {
      fontSize = 14.0; // 태블릿
    } else {
      fontSize = 13.0; // 모바일
    }
    // 반응형 - 아이콘 사이즈
    if (screenWidth >= 1200) {
      iconSize = 22.0; // 데스크톱
    } else if (screenWidth >= 600) {
      iconSize = 21.0; // 태블릿
    } else {
      iconSize = 20.0; // 모바일
    }

    return Center(
      child: Container(
        width: searchBarWidth > maxSearchBarWidth
            ? maxSearchBarWidth
            : searchBarWidth,
        height: searchBarHeight,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _showEngineSelectionModal,
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.public,
                  color: Colors.grey[600],
                  size: iconSize,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(fontSize: fontSize),
                cursorHeight: fontSize,
                decoration: InputDecoration(
                  hintText: "Type here to search...",
                  hintStyle:
                      TextStyle(color: Colors.grey[600], fontSize: fontSize),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15), // 패딩 조절
                ),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    String searchUrl = urlData[selectedEngine] ??
                        urlData['searchEngines'][selectedEngine];
                    String fullUrl = '$searchUrl$value';
                    _launchURL(fullUrl);
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.grey[600],
                size: iconSize,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus(); // 키보드 내리기
              },
            ),
          ],
        ),
      ),
    );
  }
}
