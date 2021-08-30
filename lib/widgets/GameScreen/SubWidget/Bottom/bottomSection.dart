import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/Service/LinesServices.dart';
import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firedBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
double mainRadius =0.25;
class BottomSection extends StatefulHookWidget {
  const BottomSection();

  @override
  _BotomSectionState createState() => _BotomSectionState();
}

class _BotomSectionState extends State<BottomSection> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  double x = 0, y = 0;
  double bx = 0, by = 0;
  double dy = 0;
  double m = 0;
  double dx = 0;
  bool isValueSet =false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController  =AnimationController(vsync: this,duration: Duration(milliseconds: 100));
  }
  setAnimation(Size size){
    final radius =(size.height*0.3)*mainRadius;
    animation =Tween(begin: 0.0,end:radius ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInSine));
  }
  @override
  Widget build(BuildContext context) {
    //final bubbleData= useProvider(bubbleProvider);
    final size = MediaQuery.of(context).size;
    if(!isValueSet){
      setAnimation(size);
    }
    final bubbleData = useProvider(jBubbleProvider);
    final lineData = context.read(lineProvider);

    bx = size.width / 2;
    by = size.height * .15;
    //print('bottom');
    return GestureDetector(
      onPanEnd: (val) {
        //print("pan end");

      },
      onPanDown: (val) {
        x = val.localPosition.dx;
        y = val.localPosition.dy;
        // //print('x='+x.toString()+"//"+"y=" +y.toString());
      },
      onPanUpdate: (val) {
        x = val.localPosition.dx;
        y = val.localPosition.dy;
        // if(x == bx){
        //   x = x-1;
        // }
        // m =(y - by)/(x- bx);
        m = (y - by) / (x - bx);
        lineData.calculate(bx, by, x, y, size);
        if (x < bx) {
          dx = 0;
        } else {
          dx = size.width;
        }

        dy = m * (dx - bx) + by;
        double ang = math.atan(m) * 180 / 3.14;

        setState(() {});
      },
      child: Container(
          height: size.height * 0.3,
          width: size.width,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.red
              )
            )
          ),
          child: Stack(
            children: [
              LineWidget(),
             Center(
               child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, snapshot) {
                    //print(animation.value);
                    return Container(
                      width: size.height*0.15,
                      height: size.height*0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                      ),
                      child: GestureDetector(
                        onTap: (){
                          bubbleData.fireFunction();

                        },
                        onHorizontalDragEnd: (va){
                          animationController.reset();
                          animationController.forward().whenComplete(() {
                            bubbleData.swapFireBubble();
                          });


                        },
                        child:   CustomPaint(
                          size: size,
                          painter: FireTank(bubbleNotifier: bubbleData
                              ,animationValue: animation.value,fullScreenSize: size),
                        ),
                      ),
                    );
                  }
                ),
             ),



            ],
          )),
    );
  }
}

class LineWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final lineData = useProvider(lineProvider);
    // //print(lineData.lines[0].toString());
    return CustomPaint(
      child: Container(
        height: size.height * 0.3,
        width: size.width,
      ),
      painter: LineDrawer(lines: lineData.lines),
    );
  }
}

class LineDrawer extends CustomPainter {
  List<Line> lines;

  LineDrawer({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    if (lines.isNotEmpty) {
      canvas.translate(lines[0].start.dx, lines[0].start.dy);
      // //print((size.width/2).toString()+"width"+(size.height).toString()+"height");
      Paint p = Paint();
      p
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      for (int i = 0; i < lines.length; i++) {
        canvas.drawLine(Offset.zero, lines[i].end, p);
        canvas.translate(lines[i].end.dx, lines[i].end.dy);
      }


    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//
class FireTank extends CustomPainter{
  Size fullScreenSize;
  BubbleNotifier bubbleNotifier;
  double animationValue;
  FireTank({required  this.bubbleNotifier,required this.animationValue,required this.fullScreenSize});
  @override
  void paint(Canvas canvas, Size size) {

    Paint ringPaint=Paint()
      ..color=Colors.white
    ..style=PaintingStyle.stroke
    ;
    double bottomHeight = fullScreenSize.height*0.3;
    double bottomWidth = fullScreenSize.width;
    double bubbleRadius =size.width/numberOfBubbleInColumn;
    double ballWidth = (bottomWidth - totalPaddingInRow) / numberOfBubbleInRow;
    double mainCircleRadius =bottomHeight*mainRadius;

    canvas.drawCircle(Offset(size.width/2,size.height*0.5), mainCircleRadius, ringPaint);
    if(bubbleNotifier.fireBubble.length>1){
      if(bubbleNotifier.fireBubble.length>2){
          Offset bubbleOffset= Offset((size.width / 2)+mainCircleRadius-animationValue, (size.height * 0.5));
          Paint bubblePaint = Paint()
            ..shader = RadialGradient(
              colors: [
                bubbleNotifier.fireBubble[1],
                Colors.black,
              ],
            ).createShader(Rect.fromCircle(
              center: bubbleOffset,
              radius: ballWidth,
            )
            )
          ;
          canvas.drawCircle(bubbleOffset, (bottomWidth/numberOfBubbleInColumn), bubblePaint);

      }
      Offset centerBubble =Offset((size.width / 2)+animationValue, (size.height * 0.5));
      Paint bubblePaint = Paint()
        ..shader = RadialGradient(
          colors: [
            bubbleNotifier.fireBubble[1],
            Colors.black,
          ],
        ).createShader(Rect.fromCircle(
          center: centerBubble,
          radius: ballWidth,
        )
        )
      ;
      canvas.drawCircle(centerBubble, (bottomWidth/numberOfBubbleInColumn), bubblePaint);

    }


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}