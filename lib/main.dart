import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Service/BubbleService.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/widgets/SplashScreen/splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/GameScreen/SubWidget/GameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));

}
final bubbleProvider = ChangeNotifierProvider((ref)=>BubbleService());
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

   context.read(bubbleProvider).setDefaultData();
    context.read(bubbleProvider).assignColorToFiredBubbleColor();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

