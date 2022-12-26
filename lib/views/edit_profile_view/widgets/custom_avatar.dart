import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.downloadUrl,
    required this.image,
  }) : super(key: key);

  final String? downloadUrl;
  final File? image;

  @override
  Widget build(BuildContext context) {
    if (downloadUrl == null && image == null) {
      return const CircleAvatar(
          radius: 80.0,
          backgroundImage: AssetImage("assets/images/person.png"));
    } else if (downloadUrl != null && image == null) {
      return CircleAvatar(
        radius: 80.0,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: downloadUrl!,
          imageBuilder: (context, imageProvider) {
            return ClipOval(
                child: SizedBox.fromSize(
                    size: const Size.fromRadius(80),
                    child: Image(image: imageProvider, fit: BoxFit.cover)));
          },
          placeholder: (context, url) {
            return ClipOval(
                child: SizedBox.fromSize(
              size: const Size.fromRadius(20),
              child: const CircularProgressIndicator(color: Colors.white),
            ));
          },
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else if (downloadUrl == null && image != null) {
      return CircleAvatar(radius: 80.0, backgroundImage: FileImage(image!));
    }
    return CircleAvatar(radius: 80.0, backgroundImage: FileImage(image!));
  }
}
