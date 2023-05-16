import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAds {
  InterstitialAd? _interstitialAd;
  static BannerAd? _bannerAd;

  void loadInterstitialAd({bool showAfterLoad = false}) {
    InterstitialAd.load(
      adUnitId: dotenv.env["interstitialAdUnitId"].toString(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          if (showAfterLoad) showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  static Future<Widget> buildBannerWidget({
    required BuildContext context,
  }) async {
    final mediaQuery = MediaQuery.of(context);

    await _instantiateBanner(
      mediaQuery.orientation,
      mediaQuery.size.width.toInt(),
    );
    _bannerAd = null;
    return SizedBox(
      // ignore: use_build_context_synchronously
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: AdWidget(ad: _bannerAd!),
    );
  }

  static Future<BannerAd> _instantiateBanner(orientation, width) async {
    _bannerAd = BannerAd(
      adUnitId: dotenv.env["bannerAdUnitId"].toString(),
      size: (await AdSize.getAnchoredAdaptiveBannerAdSize(orientation, width))!,
      request: _getBannerAdRequest(),
      listener: _buildListener(),
    );
    await _bannerAd?.load();
    return _bannerAd!;
  }

  static AdRequest _getBannerAdRequest() {
    return const AdRequest();
  }

  static BannerAdListener _buildListener() {
    return BannerAdListener(
      onAdOpened: (Ad ad) {
        print('Ad opened.');
      },
      onAdClosed: (Ad ad) {
        print('Ad closed.');
      },
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
      },
      onAdFailedToLoad: (ad, error) {
        print('Ad failed to load.');
      },
    );
  }

  static void disposeBanner() {
    _bannerAd?.dispose();
  }
}
