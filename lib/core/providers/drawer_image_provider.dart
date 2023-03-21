import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/leaderboard_model.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:provider/provider.dart';

class DrawerImageProvider extends ChangeNotifier {
  String? downloadUrl;

  Future<void> getURL(BuildContext context, LeaderboardModel? user) async {
    var reference = FirebaseStorage.instance
        .ref()
        .child('profilresimleri')
        .child(user?.uid ?? context.read<PomotodoUser>().userId);

    if (await reference.list().then((value) => value.items.isNotEmpty)) {
      await reference.child("profilResmi.png").getDownloadURL().then((url) {
        downloadUrl = url;
        notifyListeners();
      });
    } else {
      if (user == null) {
        downloadUrl = context.read<PomotodoUser>().userPhotoUrl;
      } else if (user.uid == context.read<PomotodoUser>().userId) {
        downloadUrl = context.read<PomotodoUser>().userPhotoUrl;
      } else {
        downloadUrl = user.userPhotoUrl;
      }
      notifyListeners();
    }
  }
}
