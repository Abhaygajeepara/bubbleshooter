import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Service/BubbleService.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/widgets/Home/HomeScreen.dart';
import 'package:bubble/widgets/SplashScreen/splash.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/GameScreen/SubWidget/GameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(ProviderScope(child: MyApp()));

}
final bubbleProvider = ChangeNotifierProvider((ref)=>BubbleService());
final jBubbleProvider = ChangeNotifierProvider<BubbleNotifier>((_ref)=>BubbleNotifier());
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

   // context.read(bubbleProvider).setDefaultData();
   //  context.read(bubbleProvider).assignColorToFiredBubbleColor();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // primaryColor: themeColor,
        // backgroundColor: themeColor,
         scaffoldBackgroundColor:themeColor ,
        // primarySwatch: Colors.blue,
      ),
      home: FakeSlpash(),
    );
  }
}
class FakeSlpash extends StatefulWidget {
  @override
  _FakeSlpashState createState() => _FakeSlpashState();
}

class _FakeSlpashState extends State<FakeSlpash> {
  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;

//   return GameScreen();
    return HomeScreen();
  }
}



