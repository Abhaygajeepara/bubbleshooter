import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:bubble/Service/BubbleService.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/main.dart';
import 'package:bubble/widgets/GameScreen/SubWidget/BubblePanel.dart';
import 'package:bubble/widgets/GameScreen/SubWidget/ScorerBar.dart';
import 'package:bubble/widgets/GameScreen/SubWidget/SingleBubble.dart';
import 'package:bubble/widgets/GameScreen/SubWidget/bottomSection.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {



  @override
  void initState() {
    // TODO: implement initState
    // getData();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {







    return Scaffold(
        backgroundColor: gameBoardColor,
        body: Container(
            child: Column(
          children: [
           const ScorerBar(),

         const   JaydipWidget(),
       const     BottomSection(),
          ],
        )));
  }


}

