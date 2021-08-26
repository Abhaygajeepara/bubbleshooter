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
    print('gamePanel');
    double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
    return Container(
      height: size.height * 0.65,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: levelPainter(bubbleNotifier:bubbleData),
                size: size,

              ),
            ),
          ),
          
          // for (List<BubbleModel> i in bubbleData.bubbles)
          //   for (   BubbleModel j in i)
          //
          //     if(!j.isRender)
          //     SingleBubble(bubbleModel: j,)
        ],
      ),
    );
  }
}


class levelPainter extends CustomPainter{
  BubbleNotifier bubbleNotifier;
  levelPainter({required this.bubbleNotifier});
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
       double   top = initialTop  + (ballWidth -2) * iteration;
          double x =size.width*(j.j)/bubbleNotifier.bubbles[i].length;
        //  double y =size.height*(j.i)/bubbleModel.length;
          double y =size.height*(j.i)/numberOfBubbleInColumn;
          Offset o =Offset(j.left,top);
          final paint =Paint()

            ..color=j.bubbleColor
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

          canvas.drawCircle(o, size.width/numberOfBubbleInColumn, paint);
        }


      }
      iteration=iteration+1;
    }


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>true;
}

