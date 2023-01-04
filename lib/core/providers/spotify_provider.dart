import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpotifyProvider extends ChangeNotifier {
  bool loading = false;
  bool connected = false;
  bool isPlaying = false;
  late ImageUri? currentTrackImageUri;

  Future<void> connectToSpotifyRemote() async {
    try {
      loading = true;
      notifyListeners();
      await SpotifySdk.connectToSpotifyRemote(
          clientId: dotenv.env["clientId"].toString(),
          redirectUrl: dotenv.env["redirectUrl"].toString());
      loading = false;
      connected = true;
      notifyListeners();
    } on PlatformException catch (_) {
      loading = false;
      notifyListeners();
      throw PlatformException(code: "Spotify uygulaması bulunamadı.");
    } on MissingPluginException {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> resume() async {
    await SpotifySdk.resume();
    isPlaying = true;
    notifyListeners();
  }

  Future<void> pause() async {
    await SpotifySdk.pause();
    isPlaying = false;
    notifyListeners();
  }

  Future<void> skipNext() async {
    await SpotifySdk.skipNext();
    isPlaying = true;
    notifyListeners();
  }

  Future<void> skipPrevious() async {
    await SpotifySdk.skipPrevious();
    isPlaying = true;
    notifyListeners();
  }
}
