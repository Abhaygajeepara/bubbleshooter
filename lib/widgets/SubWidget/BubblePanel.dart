import 'dart:async';

import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/main.dart';
import 'package:bubble/widgets/SubWidget/SingleBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class BubblePanel extends StatefulWidget {
  @override
  _BubblePanelState createState() => _BubblePanelState();
}

class _BubblePanelState extends State<BubblePanel> {
  ScrollController _scrollController = ScrollController();
  bool stopScroll=false;
  // List<List<Bubble>> screenBubble = [];
 late Timer _timer;
 late double maxPosition;
 int start=0;
 int end=25;
 int addNode=10;
 bool stopAdd =false;
  bool _needsScroll = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }
  @override
  reassemble() {
    super.reassemble();
    _timer.cancel();
    _startTimer();
  }
 @override
  void initState() {
    // TODO: implement initState
   _startTimer();
   resetAll();

    super.initState();

  }
  resetAll(){
    final bubbleData= context.read(buubleProvider);
    bubbleData.resetAllBubble();
    bubbleData.setDefaultData();
 //   print(bubbleData.allBubble.length);
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds:1500 ), (_) {
      setState(() {
        _addBubble();
        _needsScroll = true;
      });
    });
  }
  _addBubble() async{
    final bubbleData= context.read(buubleProvider);
    if(bubbleData.startAdding ==bubbleData.bubbleColumns){

  _timer.cancel();
    }
    else{
      await  setStartAndEnd();
      await bubbleData.setDefaultData();

    }
  //  print(bubbleData.allBubble .length);


  }

  setStartAndEnd()async{
    final bubbleData= context.read(buubleProvider);
    int numberOfColumn = bubbleData.bubbleColumns;
    int newEnd = end+addNode;
    if(newEnd<numberOfColumn){
      start=end;
      end=newEnd;
      setState(() {

      });
    }else{
      int newadd= numberOfColumn-end;
      start=end;
      end =end+newadd;
      stopAdd=true;


      setState(() {

      });

    }
    bubbleData.setStartAndEnd(start, end);

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

    final bubbleData= context.read(buubleProvider);
   WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToEnd());
    final size = MediaQuery.of(context).size;

    return ListView.builder(
       // physics: NeverScrollableScrollPhysics(),
      controller: _scrollController,
        itemCount: bubbleData.allBubble.length,
        itemBuilder: (context, index) {
          double rowPadding =0;
          int rowBubble =bubbleData.allBubble[index].length;
          if(rowBubble%2==00){
            rowPadding=(size.width / bubbleData.maximumNodeInOneRow)/2;
          }else{
            rowPadding =0;
          }
          return Container(
            height: size.height * 0.9 /21,

            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:rowPadding ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:bubbleData.allBubble[index].length,
                  itemBuilder: (context, subIndex) {

                    return SingleBubble(
                        buubleColor: bubbleData.allBubble[index][subIndex].bubbleColor,y: index,x: subIndex,isVisible:bubbleData.allBubble[index][subIndex].isVisible ,);
                  }),
            ),
          );
        });
  }
}
// addData() async{
//   final bubbleData= context.read(buubleProvider);
//   // print(start);
//   // print(end);
//   // print('asdasd');
//   for(int i=start;i<end;i++){
//     screenBubble.add(bubbleData.allBubble[i]);
//
//   }
//   setState(() {
//
//   });
// }
// checkScroll()async{
//   final bubbleData= context.read(buubleProvider);
//   maxPosition= _controller.position.maxScrollExtent;
//
//   double newJumpPosition =_controller.offset+150;
//     if(newJumpPosition<_controller.position.maxScrollExtent){
//       _controller
//           .jumpTo(newJumpPosition);
//       if(stopAdd ==false){
//
//   //setStartAndEnd();
//       //  stopAdd==false?  await addData():null;
//       }
//     }else{
//       _controller
//           .jumpTo(_controller.position.maxScrollExtent);
//       stopScroll=true;
//       setState(() {
//
//       });
//
// }
//
//
// }