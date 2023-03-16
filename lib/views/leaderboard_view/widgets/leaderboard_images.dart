import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/drawer_image_provider.dart';

class LeaderboardImages extends StatefulWidget {
  const LeaderboardImages({
    Key? key,
    required this.uid,
  }) : super(key: key);
  final String uid;
  @override
  State<LeaderboardImages> createState() => _LeaderboardImagesState();
}

class _LeaderboardImagesState extends State<LeaderboardImages> {
  late DrawerImageProvider newProvider;

  @override
  void initState() {
    newProvider = DrawerImageProvider();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => newProvider.getURL(context, widget.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: newProvider.getURL(context, widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CircleAvatar(
            radius: 30,
            child: newProvider.downloadUrl != null
                ? CachedNetworkImage(
                    imageUrl: newProvider.downloadUrl!,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) {
                      return ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(30),
                          child: Image(image: imageProvider, fit: BoxFit.cover),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(10),
                          child: const CircularProgressIndicator(
                              color: Colors.white),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const Icon(Icons.error);
                    },
                  )
                : ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(30),
                      child: Image.asset('assets/images/person.png',
                          fit: BoxFit.cover),
                    ),
                  ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
