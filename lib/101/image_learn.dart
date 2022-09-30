import 'package:flutter/material.dart';

class ImageLearn extends StatelessWidget {
  const ImageLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: const [
          SizedBox(height: 400, width: 300, child: PngImage(name: "apple")),
        ],  
      ),
    );
  }
}

class PngImage extends StatelessWidget {
  const PngImage({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/png/$name.png",
      fit: BoxFit.cover,
    );
  }
}

class ImageItems {
  final String appleWithBook = "assets/apple_png_olmayan.png";
  final String appleBook = "assets/png/apple.png";
}
