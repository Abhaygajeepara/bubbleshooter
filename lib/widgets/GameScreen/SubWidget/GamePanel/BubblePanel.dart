import 'dart:async';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Common/commmonTitle.dart';
import 'package:bubble/Common/customTextStyle.dart';
import 'package:bubble/Model/Bubble.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/Service/LinesServices.dart';
import 'package:bubble/main.dart';
import 'package:bubble/widgets/GameScreen/SubWidget/Bottom/bottomSection.dart';
import 'package:bubble/widgets/GameScreen/SubWidget/PopupMenu/GameOverPopUp.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


double animationStart =0.0;
double animationEnd=32.0;
double opacityStart =1.0;
double opacityEnd =0.0;
class JaydipWidget extends StatefulHookWidget {
  const JaydipWidget();
  @override
  _JaydipWidgetState createState() => _JaydipWidgetState();
}

class _JaydipWidgetState extends State<JaydipWidget> with TickerProviderStateMixin {
 late AnimationController fallingController;
 late AnimationController opacityController;
 late Animation animation;

 late Animation opacityAnimation;
 @override
  void initState() {
   initialAnimation();
    // TODO: implement initState
    super.initState();
  }
  initialAnimation(){
   fallingController =AnimationController(vsync: this,duration: Duration(milliseconds: 1500 ));
   opacityController =AnimationController(vsync: this,duration: Duration(milliseconds: 500));
   animation =Tween(begin: animationStart,end: animationEnd).animate(CurvedAnimation(parent: fallingController, curve: Curves.easeIn));

   opacityAnimation =Tween(begin: opacityStart,end: opacityEnd).animate(CurvedAnimation(parent: opacityController, curve: Curves.easeIn));

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bubbleData = useProvider(jBubbleProvider);
    final lineData = context.read(lineProvider);
  print('build');
  print(bubbleData.isGameOver);
  if(bubbleData.isDisappearAnimation){

    opacityController.reset();
    opacityController.forward().whenComplete(()async {
      await bubbleData.clearRemoveNode();
      //await    bubbleData.screenBubble(size,opacityAnimation.value,animation.value);

    });
  }
  if(bubbleData.isFallingAnimation){
    fallingController.reset();
    fallingController.forward().whenComplete(()async {
      await bubbleData.setNewFake();
      await  bubbleData.removeEmptyRow();
   // await  bubbleData.screenBubble(size,opacityAnimation.value,animation.value);
      await   bubbleData.turnOffAnimation();


    });
  }


    return Container(
    //  height: size.height * 0.65,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [

              AnimatedBuilder(
                 animation: opacityController,
                 builder: (context, snapshot) {
                   return AnimatedBuilder(
                     animation: fallingController,
                     builder: (context, snapshot) {
                       bubbleData.screenBubble(size,opacityAnimation.value,animation.value);
                       return RepaintBoundary(
                        child: CustomPaint(
                          painter: levelPainter(bubbleNotifier:bubbleData,context: context,


                          ),
                          size: size,

                        ),
              );
                     }
                   );
                 }
               ),

         bubbleData.isGameOver? GameOverPopUp():Container(),
          

        ],
      ),
    );
  }
}


class levelPainter extends CustomPainter{
  BubbleNotifier bubbleNotifier;
  BuildContext context;




  levelPainter({required this.bubbleNotifier,required this.context,}):super(repaint:bubbleNotifier );
  @override
  void paint(Canvas canvas, Size size) {

  //  double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;

    for(int i=bubbleNotifier.fakeTop;i<bubbleNotifier.bubbles.length;i++){
      for(int k=0;k<bubbleNotifier.bubbles[i].length;k++){
        BubbleModel j =bubbleNotifier.bubbles[i][k];
        if(j.bubbleColor!= BubbleColor0){
          double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;

          final paint =Paint();
         late Offset o =Offset(j.left,j.top);
         Color bubbleColor =j.bubbleColor;
         Color shadow =Colors.black;
          paint..color=j.bubbleColor
            ..shader=RadialGradient(
              colors: [
                bubbleColor,
                shadow
              ],
            ).createShader(Rect.fromCircle(
              center: o,
              radius: ballWidth,
            ));
          canvas.drawCircle(o, size.width/numberOfBubbleInColumn, paint);

        }
      }



    }


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>true;
}

/*
* class levelPainter extends CustomPainter{
  BubbleNotifier bubbleNotifier;
  BuildContext context;
  double animationValue;
  double opacityDisappear;


  levelPainter({required this.bubbleNotifier,required this.context,required this.animationValue,required this.opacityDisappear});
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
         Color bubbleColor =j.bubbleColor;
         Color shadow =Colors.black;

          if(bubbleNotifier.mainFallingNode.contains(j.bubbleCoordinate)==false){
            if(bubbleNotifier.mainRemoveNodes.contains(j.bubbleCoordinate)){
              bubbleColor =j.bubbleColor.withOpacity(opacityDisappear);
              shadow=shadow.withOpacity(opacityDisappear);
            }
            double   top = initialTop  + (ballWidth -2) * iteration;
            o =Offset(j.left,top);
              paint..color=j.bubbleColor
              ..shader=RadialGradient(
                colors: [
                  bubbleColor,
                  shadow
                ],
              ).createShader(Rect.fromCircle(
                center: o,
                radius: ballWidth,
              ));
          }else{
            double newTop = iteration+animationValue*2;
            double localOpacity =1.0;
            if(newTop>16){
              newTop=16;
              localOpacity =0.0;
            }

            double   top = initialTop  + (ballWidth -2) * newTop;
            o =Offset(j.left,top);
             paint..color=bubbleColor
              ..shader=RadialGradient(
                colors: [
                  bubbleColor.withOpacity(localOpacity),
                  shadow.withOpacity(localOpacity),

                ],
              ).createShader(Rect.fromCircle(
                center: o,
                radius: ballWidth,
              ));
          }
          canvas.drawCircle(o, size.width/numberOfBubbleInColumn, paint);
        }

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


* */