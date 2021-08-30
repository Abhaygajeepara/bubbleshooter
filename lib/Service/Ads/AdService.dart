import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class AdsService{
  String bannerId = 'ca-app-pub-3940256099942544/6300978111';
  String instantiateTestId = 'ca-app-pub-3940256099942544/5224354917';
 late AdWidget  bannerWidget ;
  AdsService(){
    createbannerAd();
  }
  bool isload =false;
  static initialize(){
    if(MobileAds.instance== null){
      MobileAds.instance.initialize();
    }
  }

  BannerAd createbannerAd(){
    BannerAd _ad = BannerAd(size: AdSize.banner, adUnitId: bannerId,
        listener: BannerAdListener(
          onAdClosed: (Ad ad)=>print('adclosed'),
          onAdLoaded: (Ad ad)=>print('adload'),
          onAdOpened: (Ad ad)=>print('ad open'),
          onAdFailedToLoad: (Ad ad ,LoadAdError error)=>print('error=${error}'),
        ), request: AdRequest());

    _ad.load();
    bannerWidget = AdWidget(ad: _ad);
    return _ad;
  }

  Future loadAd()async{
   return await InterstitialAd.load(
        adUnitId: instantiateTestId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad)async {
            print('load');
            return ad.show();
            // Keep a reference to the ad so you can show it later.
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }


}