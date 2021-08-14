import 'dart:async';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Common/commmonTitle.dart';
import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/main.dart';
import 'package:bubble/widgets/GameScreen/SubWidget/SingleBubble.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
class BubblePanel extends StatefulHookWidget {
  @override
  _BubblePanelState createState() => _BubblePanelState();
}

class _BubblePanelState extends State<BubblePanel>  with TickerProviderStateMixin{
  ScrollController _scrollController = ScrollController();
 late AnimationController popController ;
 late Animation popAnimation;
  bool stopScroll=false;
  // List<List<Bubble>> screenBubble = [];
 // late Timer _timer;
 // late double maxPosition;
 int start=0;
 int end=25;
 int addNode=10;
 bool stopAdd =false;
  bool _needsScroll = false;
  bool reAnimate=true;
  final popSizeWidth=0.5;
  final popSizeHeight =0.3;
  @override
  void dispose() {
    // TODO: implement dispose
   // _timer.cancel();
    super.dispose();
  }
  @override
  reassemble() {
    super.reassemble();
    //_timer.cancel();
   // _startTimer();
  }
 @override
  void initState() {
    // TODO: implement initState
   // _startTimer();
   // resetAll();
  popController =AnimationController(duration: Duration(seconds: 2),vsync: this);
  popAnimation=Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(parent: popController, curve: Curves.fastOutSlowIn))..addListener(() {setState(() {
  reAnimate=false;
  });});
    super.initState();

  }



  _scrollToEnd() async {
    // if (_needsScroll) {
    //   _needsScroll = false;
    //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //       duration: Duration(milliseconds: 2000), curve: Curves.easeInOut);
    // }
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 2000), curve: Curves.easeInOut);
  }
 @override

  Widget build(BuildContext context) {
   //stopScroll!=true?jumpedFunction():null;

    final provider= useProvider(bubbleProvider);

   // WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToEnd());
    final size = MediaQuery.of(context).size;
    print(popAnimation.value);
    if(provider.moves==0  && reAnimate==true){

      popController.forward();

    }
  return Stack(
    children: [
      ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: provider.allBubble.length,
          itemBuilder: (context, index) {
            double rowPadding =0;
            int rowBubble =provider.allBubble[index].length;
            if(rowBubble%2==00){
              rowPadding=(size.width / provider.maximumNodeInOneRow)/2;
            }else{
              rowPadding =0;
            }
            return SizedBox(
              height:  size.width*0.99 / 11,
       // color: Colors.transparent,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal:rowPadding ),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:provider.allBubble[index].length,
                    itemBuilder: (context, subIndex) {

                      return SingleBubble(
                        buubleColor: provider.allBubble[index][subIndex].bubbleColor,y: index,x: subIndex,isVisible:provider.allBubble[index][subIndex].isVisible ,);
                    }),
              ),
            );
          }),
      provider.gameOver? Transform(
        transform: Matrix4.translationValues(
            popAnimation.value*size.width, 0.0, 0.0),
        child: Center(
          child: Container(
            color: Colors.red,
            width: 200,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: ()async{
                  await provider.setMoves(1);
                  popController.reset();
                  setState(() {
                    reAnimate=true;
                  });

                  //await  provider.firedFunction();
                }, child: Text(gameOver)),
                ElevatedButton(onPressed: (){}, child: Text(restart)),

              ],
            ),
          ),
        ),
      )

      :
      Container()
    ],
  );

  }
}


class JaydipWidget extends StatefulHookWidget {
  const JaydipWidget();
  @override
  _JaydipWidgetState createState() => _JaydipWidgetState();
}

class _JaydipWidgetState extends State<JaydipWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bubbleData = useProvider(jBubbleProvider);

    double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
    return Container(
      height: size.height * 0.65,
      child: Stack(
        children: [
          for (List<BubbleModel> i in bubbleData.bubbles)
            for (BubbleModel j in i)
              Positioned(
                left: j.left,
                top: j.top,
                child: Container(
                  height: ballWidth,
                  width: ballWidth,
                  decoration: BoxDecoration(
                      color: j.bubbleColor,
                      border: Border.all(
                          color: j.bubbleColor,width: 10
                      ),
                      boxShadow: [
                        j.bubbleColor != Colors.transparent
                            ? BoxShadow(
                          color: Colors.black,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0),
                        )
                            : BoxShadow(
                          color: j.bubbleColor,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ], shape: BoxShape.circle
                  ),
                  child: Text(i.first.i.toString()+j.j.toString()),
                ),
              )
        ],
      ),
    );
  }
}


//  resetAll(){
//    final bubbleData= context.read(bubbleProvider);
//    bubbleData.resetAllBubble();
//    bubbleData.setDefaultData();
// //   print(bubbleData.allBubble.length);
//  }
//
//  _startTimer() {
//    _timer = Timer.periodic(Duration(milliseconds:1500 ), (_) {
//      setState(() {
//        _addBubble();
//        _needsScroll = true;
//      });
//    });
//  }
//  _addBubble() async{
//    final bubbleData= context.read(bubbleProvider);
//    if(bubbleData.startAdding ==bubbleData.bubbleColumns){
//
//  _timer.cancel();
//    }
//    else{
//      await  setStartAndEnd();
//      await bubbleData.setDefaultData();
//
//    }
//  //  print(bubbleData.allBubble .length);
//
//
//  }
//
//  setStartAndEnd()async{
//    final bubbleData= context.read(bubbleProvider);
//    int numberOfColumn = bubbleData.bubbleColumns;
//    int newEnd = end+addNode;
//    if(newEnd<numberOfColumn){
//      start=end;
//      end=newEnd;
//      setState(() {
//
//      });
//    }else{
//      int newadd= numberOfColumn-end;
//      start=end;
//      end =end+newadd;
//      stopAdd=true;
//
//
//      setState(() {
//
//      });
//
//    }
//    bubbleData.setStartAndEnd(start, end);
//
//  }