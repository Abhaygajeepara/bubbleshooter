import 'dart:math';

import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Service/BubbleService.dart';
import 'package:bubble/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int totalBubbleInRow =10;
  //List<List<Bubble>> numberofBubble = [];
  @override
  void initState() {
    // TODO: implement initState
   // getData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Consumer(

          builder: (context, watch,child) {
            final bubbleData = watch(buubleProvider);
            return Container(
              child: Stack(
                children: [
                  Container(
                    height: size.height,
                    width: size.width,
                    child: Image.asset('assets/backgroud.jpg', fit: BoxFit.fill),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                                height: size.height * 0.8,
                                child: Center(child: bubbleDisplay(bubbleData)))),
                        bottomSection(bubbleData),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ));
  }

  Widget bubbleDisplay(BubbleService bubbleData) {


    final size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: bubbleData.allBubble.length,
        itemBuilder: (context, index) {
          return Container(
            height: size.height*0.9/20,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bubbleData.allBubble[index].length,
                itemBuilder: (context, subIndex) {

                  return singleBubble(bubbleData.allBubble[index][subIndex].bubbleColor);

                }),
          );
        });
  }

  Widget singleBubble(Color bubbleColor){
    final size = MediaQuery.of(context).size;
    return   Container(
      decoration: BoxDecoration(
          color: bubbleColor,
          boxShadow: [
            bubbleColor!=Colors.transparent?
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0),
            ):BoxShadow(
              color: bubbleColor,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
          shape: BoxShape.circle),
      width: size.width / totalBubbleInRow,
      // child: Center(child:
      //
      // Text('${index},${subIndex}',style: TextStyle(color: Colors.white),)),
    );
  }

  Widget bottomSection(BubbleService bubbleData){
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.1,
      width: size.width,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          firedBubbleQueue(bubbleData),
          bubbleData.firedBubbleColor.length<=0?
          Container():  GestureDetector(onTap: ()
          {
            bubbleData.firedFunction(10,9,bubbleData.firedBubbleColor[0]);
            bubbleData.removeFiredColorFromQueue(0);

            setState(() {

            });
          }
          , child: singleBubble(bubbleData.firedBubbleColor[0])),
          firedBubbleQueue(bubbleData)
        ],
      )
    );
  }


Widget firedBubbleQueue(BubbleService bubbleData){
    List colorList = bubbleData.firedBubbleColor;
  int fireBubbleLength =bubbleData.firedBubbleColor.length-1;
  final size = MediaQuery.of(context).size;
    return Container(
   //   height: size.height * 0.8,
      width: size.width*0.4,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: fireBubbleLength>0?
          fireBubbleLength>2?2:fireBubbleLength
              :0,
          itemBuilder: (context ,index){
         //   int ColorIndex =bubbleData.firedBubbleColor.length==0?0:index+1;
            //print('remoce =${bubbleData.firedBubbleColor.length-1}');
          return Container(
              height: size.height * 0.8,
            //  width: size.width*0.4/2,
              child: singleBubble(bubbleData.firedBubbleColor[index+1]));

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