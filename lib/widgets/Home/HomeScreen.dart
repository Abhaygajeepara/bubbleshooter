import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;
class HomeScreen extends StatefulHookWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bubbleData = useProvider(jBubbleProvider);
    final size =MediaQuery.of(context).size;
    print(bubbleData.bubbles.length);
    return Scaffold(
      body: CustomPaint(
        foregroundPainter: levelPainter(bubbleModel:bubbleData.bubbles),
        size: size,

      )
    );
  }
}
class levelPainter extends CustomPainter{
  List<List<BubbleModel>> bubbleModel;
  levelPainter({required this.bubbleModel});
  @override
  void paint(Canvas canvas, Size size) {
    double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
    for(List<BubbleModel> i in bubbleModel ){
      for(BubbleModel j in i){
        double x =size.width*(j.j)/i.length;
        double y =size.height*(j.i)/bubbleModel.length;

        Offset o =Offset(j.left,j.top);
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

        canvas.drawCircle(o, size.width/21, paint);
      }
    }


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>false;
}