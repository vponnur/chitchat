import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

class AddMobService {
  static const String _testDevice = "Mobile_Id";

  static const MobileAdTargetingInfo _targetingInfo = MobileAdTargetingInfo(
    testDevices: _testDevice != null ? <String>[_testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['chat', 'chat', 'chitchat'],
  );

  String getAddMobAppId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-2538937533858268~7690882718";
    }
    return null;
  }

  String getBannerAdId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-2538937533858268/1455156163";
    }
    return null;
  }

  String getInterstitialAd() {
    if (Platform.isAndroid) {
      return "ca-app-pub-2538937533858268/8098555758";
    }
    return null;
  }

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: getBannerAdId(),
        size: AdSize.banner,
        targetingInfo: _targetingInfo,
        listener: (MobileAdEvent event) {
          //print("BannerAdd : $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: getInterstitialAd(),
        targetingInfo: _targetingInfo,
        listener: (MobileAdEvent event) {
          //print("InterstitialAd : $event");
        });
  }
}
