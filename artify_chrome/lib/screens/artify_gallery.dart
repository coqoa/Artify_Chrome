import 'package:flutter/material.dart';

class ArtifyGallery extends StatelessWidget {
  final List<String> imageUrls = [
    // 이미지 URL 목록을 여기에 추가하세요
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbtD05K%2FbtsKtHI3yIu%2FQEqKL8C3WSyPBrkbsWmX3k%2Fimg.webp",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fwikzt%2FbtsKvaCT4vb%2F5lrmpLCBboDSL7XM2gsUtk%2Fimg.webp",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FdkhsrZ%2FbtsKvbV7iLp%2FLQZZzF0BpS6PkLB3czcjD1%2Fimg.webp",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FZU4ZO%2FbtsKtMjaJw0%2F7iFCdpHuPFtQ2kJryUaXLK%2Fimg.webp",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fcns9aR%2FbtsKtopDorf%2FQ4xo0euoDZZdQmzg1OtjjK%2Fimg.webp",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FdCWVqm%2FbtsKuTaf7WO%2FcbTSONxMONQsS8ldveM8dk%2Fimg.webp",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FpHb5k%2FbtsKuUmHMbE%2F1lDklClAKioeGSW3oOTPm0%2Fimg.webp",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FTFWrS%2FbtsKuUmHMcl%2F9u5enCMhLNSz7DoZytD6b1%2Fimg.webp",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbnWK9f%2FbtsKHd8emZ5%2Fm2sqUGMw0seWY03yeN5Jm0%2Fimg.png",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FdMwtrF%2FbtsKHVskoTR%2F4D3VpCp1KlPF1scetofTS1%2Fimg.png",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FM2UPw%2FbtsKHINw64C%2FD939kpeLZeBNEXY7hJwkk1%2Fimg.png",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbQWB97%2FbtsKGkAwgkR%2Fk2NzewoBMgHPtC0PXTIuSk%2Fimg.png",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FuHhtX%2FbtsKHeF4Ruk%2FDAzacE4l4fspqWTBKoYnMk%2Fimg.png",
    "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbKVHy4%2FbtsKub3N8wX%2FvadpOwlUMJppYpUSIkzgU1%2Fimg.webp"
    // 추가 이미지들...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artwork Gallery'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 한 행에 표시할 이미지 개수
            crossAxisSpacing: 8.0, // 각 이미지 사이의 수평 간격
            mainAxisSpacing: 8.0, // 각 이미지 사이의 수직 간격
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GridTile(
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
