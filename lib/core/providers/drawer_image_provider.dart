import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:provider/provider.dart';

class DrawerImageProvider extends ChangeNotifier {
  String? downloadUrl;

  Future<void> baglantiAl(BuildContext context) async {
    var reference = FirebaseStorage.instance
        .ref()
        .child('profilresimleri')
        .child(context.read<PomotodoUser>().userId);

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
