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
          await rootBundle.loadString('assets/links.json');
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
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchEngines.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(searchEngines[index]),
                  onTap: () {
                    setState(() {
                      selectedEngine = searchEngines[index];
                      _loadUrlData(); // 검색 엔진 선택 시 JSON 데이터 로드
                    });
                    Navigator.pop(context); // 모달 닫기
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      // 현재창에서 이동하도록,
      await launchUrl(uri,
          mode: LaunchMode.externalApplication); // 브라우저에서 URL 열기
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double searchBarWidth = screenWidth * 0.85; // 화면 너비의 85% 차지
    double maxSearchBarWidth = 1200; // 최대 너비 설정

    return Center(
      child: Container(
        width: searchBarWidth > maxSearchBarWidth
            ? maxSearchBarWidth
            : searchBarWidth,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
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
            // 검색엔진 선택
            GestureDetector(
              onTap: _showEngineSelectionModal,
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                //! 선택한 검색엔진에 따라 아이콘 변경
                child: Icon(Icons.public, color: Colors.grey), // 검색 엔진 아이콘
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Type here to search...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    // 선택된 검색 엔진에 따라 다른 URL로 리다이렉션 로직 작성가능
                    String searchUrl = urlData[selectedEngine] ??
                        urlData['searchEngines'][selectedEngine];
                    String fullUrl = '$searchUrl$value';
                    print('Redirecting to: $fullUrl');
                    // 실제로 리다이렉트할 경우 웹뷰나 url_launcher 패키지 사용 가능
                    _launchURL(fullUrl);
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                //! 검색결과를 밖에 저장해서 검색버튼에도 동일한 이벤트 타도록
                FocusScope.of(context).unfocus(); // 키보드 내리기
              },
            ),
          ],
        ),
      ),
    );
  }
}
