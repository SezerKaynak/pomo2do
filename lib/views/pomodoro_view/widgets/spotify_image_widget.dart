import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

Widget spotifyImageWidget(ImageUri image) {
  return FutureBuilder(
      future: SpotifySdk.getImage(
        imageUri: image,
        dimension: ImageDimension.small,
      ),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            child: Align(
                heightFactor: 0.225,
                widthFactor: 1,
                child: Image.memory(snapshot.data!,
                    color: Colors.white.withOpacity(0.6),
                    colorBlendMode: BlendMode.modulate)),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
            child: const Center(child: Text('Fotoğraf alınırken hata oluştu...')),
          );
        } else {
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
            child: const Center(child: Text('Fotoğraf alınıyor...')),
          );
        }
      });
}
