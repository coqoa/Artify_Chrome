import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: Icon(Icons.video_library), onPressed: () {}),
        IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
        IconButton(icon: Icon(Icons.web), onPressed: () {}),
        IconButton(icon: Icon(Icons.email), onPressed: () {}),
      ],
    );
  }
}
