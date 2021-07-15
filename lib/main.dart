import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Service/BubbleService.dart';
import 'package:bubble/widgets/GameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}
final buubleProvider = ChangeNotifierProvider((ref)=>BubbleService());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
context.read(buubleProvider).setDefaultData();
context.read(buubleProvider).assignColorToFiredBubbleColor();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}
