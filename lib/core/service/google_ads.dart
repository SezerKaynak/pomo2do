import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAds {
  InterstitialAd? _interstitialAd;

  void loadInterstitialAd({bool showAfterLoad = false}) {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
          if (showAfterLoad) showInterstitialAd();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    }
  }
}
