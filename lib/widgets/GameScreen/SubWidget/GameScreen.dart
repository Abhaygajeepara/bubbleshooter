import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Service/BubbleService.dart';
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
  int totalBubbleInRow = 10;
  double x = 0,y =0;
  double bx =0,by =0;
  //List<List<Bubble>> numberofBubble = [];
  @override
  void initState() {
    // TODO: implement initState
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider= context.read(bubbleProvider);
    final size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    bx = size.width /2;
    by = size.height  * .15;
    final singleBubbleHeight=size.height*0.9/21;
    double calculateDisplayRatio = singleBubbleHeight*provider.displayBubbleColumn;
    final bubbleDisplayRatio = calculateDisplayRatio>=size.height*0.7?size.height*0.7:calculateDisplayRatio; // remove +singleBubbleHeight if not look right

    return Scaffold(

        backgroundColor: gameBoardColor,
        body: Container(
          child: Column(
            children: [
              ScorerBar(),

              Container(

                // height: bubbleDisplayRatio,
                  height: size.height*0.65,
                  child: Center(child: BubblePanel())),
              BotomSection(),
            ],
          )
        )

    );
  }







  Widget firedBubbleQueue(BubbleService bubbleData) {
    List colorList = bubbleData.firedBubbleColor;
    int fireBubbleLength = bubbleData.firedBubbleColor.length - 1;
    final size = MediaQuery.of(context).size;
    return Container(
      //   height: size.height * 0.8,
      width: size.width * 0.4,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: fireBubbleLength > 0
              ? fireBubbleLength > 2
                  ? 2
                  : fireBubbleLength
              : 0,
          itemBuilder: (context, index) {
            //   int ColorIndex =bubbleData.firedBubbleColor.length==0?0:index+1;
            //print('remoce =${bubbleData.firedBubbleColor.length-1}');
            return Container(
                height: size.height * 0.8,
                //  width: size.width*0.4/2,
                child: SingleBubble(buubleColor:bubbleData.firedBubbleColor[index + 1],y: 0,x: 0,isVisible: true,));
          }),
    );
  }
}

// waste

// single bubble code
// return Container(
// decoration: BoxDecoration(
// color: bubbleData.allBubble[index][subIndex].bubbleColor,
// boxShadow: [
// bubbleData.allBubble[index][subIndex].bubbleColor!=Colors.transparent?
// BoxShadow(
// color: Colors.black,
// blurRadius: 2.0,
// spreadRadius: 0.0,
// offset: Offset(2.0, 2.0),
// ):BoxShadow(
// color: bubbleData.allBubble[index][subIndex].bubbleColor,
// blurRadius: 2.0,
// spreadRadius: 0.0,
// offset: Offset(2.0, 2.0),
// ),
// ],
// shape: BoxShape.circle),
// width: size.width / bubbleData.allBubble[index].length,
// // child: Center(child:
// //
// // Text('${index},${subIndex}',style: TextStyle(color: Colors.white),)),
// );
// single bubble code
class customPaintrt extends CustomPainter{
  double x1,y1,x2,y2;
  customPaintrt(this.x1,this.y1,this.x2,this.y2);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint();
    p..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
    canvas.drawLine(Offset(x1,y1), Offset(x2,y2), p);
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}