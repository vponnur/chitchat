import 'package:ChitChat/services/addMobService.dart';
import 'package:ChitChat/widgets/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

//const String testDevice = "Mobile_Id";

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  AddMobService _amc = AddMobService();

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(
      appId: _amc.getAddMobAppId(),
    );
    _bannerAd = _amc.createBannerAd()
      ..load()
      ..show();
    _interstitialAd = _amc.createInterstitialAd()
      ..load()
      ..show();
  }

  final String msg =
      "\n\n Welcome to ChitChat App \n Hope you will enjoy this app  \n Please provide your valuble feedback to us.";

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, signOut: false),
      body: Container(
        child: Column(children: [
          Text(
            msg,
            style: simpleTextStyle(),
          ),
          SizedBox(),
          RaisedButton(
            child: Text("Click on Adds"),
            onPressed: () {
              _amc.createInterstitialAd()
                ..load()
                ..show();
            },
          ),
        ]),
      ),
    );
  }
}
