import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/main.dart';
import 'package:flutter/cupertino.dart';
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
   // print(bubbleData.bubbles.length);

    return Scaffold(
      //backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            painter: HomeCanvas(),
            size: size,

          )
        ],
      )
    );
  }
}
 class HomeCanvas extends CustomPainter{


   @override
  void paint(Canvas canvas, Size size) {
     Paint paint = Paint()
       ..color = Colors.black
       ..strokeWidth = 4.0
       ..style = PaintingStyle.stroke
       ..strokeJoin = StrokeJoin.round;
     var path = Path();
     var path2=Path();
     path.moveTo(size.width/2, size.height / 2);
     path.lineTo(size.width/2, size.height / 1.8);
   //  path.lineTo(size.width/1.6, size.height / 1.8);
     Offset arcOffset =Offset(size.width/1.6, size.height/1.8);
     path.arcToPoint(arcOffset,clockwise: false,radius: Radius.circular(20));
     path.lineTo(size.width/1.6, size.height / 2);
     Offset arcOffset1 =Offset(size.width/2, size.height/2);
     Offset arcOffset2 =Offset(size.width/2, size.height/2);
   //  path.arcToPoint(arcOffset1,clockwise: true,radius: Radius.circular(20));
     path.arcToPoint(arcOffset1,clockwise: false,radius: Radius.circular(20));
  //   path.arcToPoint(arcOffset1,clockwise: false ,radius: Radius.circular(20));
    // path.arcToPoint(arcOffset2,clockwise: false,radius: Radius.circular(20));
     canvas.drawPath(path, paint);
     canvas.drawPath(path2, paint);


  }

   @override
  bool shouldRepaint(CustomPainter oldDelegate) =>false;
}