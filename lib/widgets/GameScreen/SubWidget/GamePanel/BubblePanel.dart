import 'dart:async';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Common/commmonTitle.dart';
import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


double animationStart =0.0;
double animationEnd=32.0;
class JaydipWidget extends StatefulHookWidget {
  const JaydipWidget();
  @override
  _JaydipWidgetState createState() => _JaydipWidgetState();
}

class _JaydipWidgetState extends State<JaydipWidget> with TickerProviderStateMixin {
 late AnimationController animationController;
 late Animation animation;
 @override
  void initState() {
   initialAnimation();
    // TODO: implement initState
    super.initState();
  }
  initialAnimation(){
   animationController =AnimationController(vsync: this,duration: Duration(seconds: 3));
   animation =Tween(begin: animationStart,end: animationEnd).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn));

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bubbleData = useProvider(jBubbleProvider);
  animationController.reset();
    animationController.forward();

    double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
    return Container(
      height: size.height * 0.65,
      child: Stack(
        children: [

               AnimatedBuilder(
                 animation: animationController,
                 builder: (context, snapshot) {

                   return RepaintBoundary(
                    child: CustomPaint(
                      painter: levelPainter(bubbleNotifier:bubbleData,context: context,animationValue: animation.value),
                      size: size,

                    ),
              );
                 }
               ),

         bubbleData.isGameOver? Center(
            child: Container(
              height: 500,
              width: 200,
              color: Colors.white,
              child: Text('GameOver'),
            ),
          ):Container(),
          

        ],
      ),
    );
  }
}


class levelPainter extends CustomPainter{
  BubbleNotifier bubbleNotifier;
  BuildContext context;
  double animationValue;

  levelPainter({required this.bubbleNotifier,required this.context,required this.animationValue});
  @override
  void paint(Canvas canvas, Size size) {

  //  double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
    int iteration =0;
    for(int i=bubbleNotifier.fakeTop;i<bubbleNotifier.bubbles.length;i++){

      for(int k=0;k<bubbleNotifier.bubbles[i].length;k++){
        BubbleModel j =bubbleNotifier.bubbles[i][k];
        if(j.bubbleColor!= BubbleColor0){
          double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
          double initialTop = size.width/21;
          final paint =Paint();
         late Offset o;
          if(bubbleNotifier.mainFallingNode.contains(j.bubbleCoordinate)==false){
            double   top = initialTop  + (ballWidth -2) * iteration;
            o =Offset(j.left,top);


              paint..color=j.bubbleColor
              ..shader=RadialGradient(
                colors: [
                  j.bubbleColor,
                  Colors.black,

                ],
              ).createShader(Rect.fromCircle(
                center: o,
                radius: ballWidth,
              ))
            ;


          }else{
            double newTop = iteration+animationValue*2;
            if(newTop>16){
              newTop=16;
            }
            double   top = initialTop  + (ballWidth -2) * newTop;
            o =Offset(j.left,top);
             paint..color=j.bubbleColor
              ..shader=RadialGradient(
                colors: [
                  j.bubbleColor,
                  Colors.black,

                ],
              ).createShader(Rect.fromCircle(
                center: o,
                radius: ballWidth,
              ))
            ;



          }
          canvas.drawCircle(o, size.width/numberOfBubbleInColumn, paint);
        }


      }
      if(animationValue==animationEnd){
        WidgetsBinding.instance!.addPostFrameCallback((_) {
         bubbleNotifier.clearFalling();

        });
      }
     if(iteration<17){
       iteration=iteration+1;
       if(iteration>=15){
         WidgetsBinding.instance!.addPostFrameCallback((_) {
        if(  bubbleNotifier.isGameOver==false){
          bubbleNotifier.gameOver();
        }

         });

       }
     }



    }


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>true;
}

