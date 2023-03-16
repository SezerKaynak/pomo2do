import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/drawer_image_provider.dart';
import 'package:provider/provider.dart';

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
  late DrawerImageProvider leaderboardImageProvider;

  @override
  void initState() {
    leaderboardImageProvider =
        Provider.of<DrawerImageProvider>(context, listen: false);

    // leaderboardImageProvider.uid = widget.uid;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => leaderboardImageProvider.getURL(context, widget.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //leaderboardImageProvider.uid = widget.uid;
    return CircleAvatar(
      radius: 25,
      child: leaderboardImageProvider.downloadUrl != null
          ? CachedNetworkImage(
              imageUrl: leaderboardImageProvider.downloadUrl!,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) {
                return ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(25),
                    child: Image(image: imageProvider, fit: BoxFit.cover),
                  ),
                );
              },
              placeholder: (context, url) {
                return ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(10),
                    child: const CircularProgressIndicator(color: Colors.white),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return const Icon(Icons.error);
              },
            )
          : ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(25),
                child:
                    Image.asset('assets/images/person.png', fit: BoxFit.cover),
              ),
            ),
    );
  }
}
