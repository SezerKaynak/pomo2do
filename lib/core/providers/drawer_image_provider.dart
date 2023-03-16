import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:provider/provider.dart';

class DrawerImageProvider extends ChangeNotifier {
  String? downloadUrl;
  List<String> leaderboardImages = [];
   
  Future<void> getURL(BuildContext context, String? uid) async {
    var reference = FirebaseStorage.instance
        .ref()
        .child('profilresimleri')
        .child(uid ?? context.read<PomotodoUser>().userId);

    if (await reference.list().then((value) => value.items.isNotEmpty)) {
      await reference.child("profilResmi.png").getDownloadURL().then((url) {
        downloadUrl = url;
        notifyListeners();
      });
    } else {
      downloadUrl = context.read<PomotodoUser>().userPhotoUrl;
      notifyListeners();
    }
  }
}
