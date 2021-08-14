import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/Service/LinesServices.dart';
import 'package:bubble/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firedBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class BottomSection extends StatefulHookWidget {
  const BottomSection();
  @override
  _BotomSectionState createState() => _BotomSectionState();
}

class _BotomSectionState extends State<BottomSection> {
  double x = 0,y =0;
  double bx =0,by =0;
  double dy = 0;
  double  m = 0;
  double dx = 0;
  @override
  Widget build(BuildContext context) {
   //final bubbleData= useProvider(bubbleProvider);
   final bubbleData= useProvider(jBubbleProvider);
   final lineData = context.read(lineProvider);
    final size = MediaQuery.of(context).size;
    bx = size.width /2;
    by = size.height  * .15;

    return GestureDetector(
      onPanEnd: (val){
        print("pan end");
      },
      onPanDown: (val){
        x = val.localPosition.dx;
        y = val.localPosition.dy;
        // print('x='+x.toString()+"//"+"y=" +y.toString());
      },
      onPanUpdate: (val){
        x = val.localPosition.dx;
        y = val.localPosition.dy;
        // if(x == bx){
        //   x = x-1;
        // }
        // m =(y - by)/(x- bx);
        m = (y - by)/(x-bx);
        lineData.calculate(bx, by, x, y, size);
        if(x < bx){
          dx = 0;
        }
        else{
          dx = size.width;
        }
       // print(m);
        // if(x < size.width){
        //   m = m * -1;
        // }
         dy = m * (dx-bx) + by;
        double ang = math.atan(m ) * 180/3.14 ;
        // print(ang.toString() +"andle");
        setState(() {

        });
        // print("on upfdate" + x.toString()+"///"+y.toString());
        // print("bx"+bx.toString()+"by"+by.toString()+"dx"+dx.toString()+"dy"+dy.toString());
      },
      child: Container(
          height: size.height * 0.3,
          width: size.width,
          // color: bottomBarBgColor,
          color: Colors.black,
          child: Stack(

            children: [
              LineWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  //firedBubbleQueue(bubbleData),
                  // Text( "y="+bubbleData.targetY.toString()+"   "+"x="+bubbleData.targetY.toString(),
                  //   style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white
                  //   ),
                  // ),
                  bubbleData.firedBubbleColor.length <= 0
                      ? Container()
                      : FiredBubble(bubbleColor:bubbleData.firedBubbleColor[0]),
                  ElevatedButton(onPressed: ()async{
                    if(bubbleData.firedBubbleColor.length!=0){
                     await  bubbleData.firedFunction(5,5);
                   // print(bubbleData.bubbles[5][5].surroundingCoordinate);
                     // await    bubbleData.removeFiredColorFromQueue(0);
                      //await bubbleData.fallAndRemoveMethod();
                      //  await bubbleData.removeRow();
                    }else{
                      showDialog(context: context,
                          builder: (context){
                            return AlertDialog(

                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('kal aa na'),

                                  ElevatedButton(onPressed: (){
                                    // bubbleData.setDefaultData();
                                    // bubbleData.assignColorToFiredBubbleColor();
                                    Navigator.pop(context);

                                  }, child: Text('restart'))
                                ],
                              ),
                            );
                          }

                      );
                    }
                  }, child: Text('Fire'))
                ],
              ),
            ],
          )),
    );
  }
}
class LineWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size  = MediaQuery.of(context).size;
    final lineData = useProvider(lineProvider);
    // print(lineData.lines[0].toString());
    return CustomPaint(
      child: Container(
        height: size.height * 0.3,
        width: size.width,
      ),
      painter: LineDrawer(lines: lineData.lines),
    );
  }
}
class LineDrawer extends CustomPainter{
  List<Line> lines;
  LineDrawer ({required this.lines});
  @override
  void paint(Canvas canvas, Size size) {
  if(lines.isNotEmpty){
    canvas.translate(lines[0].start.dx, lines[0].start.dy);
    // print((size.width/2).toString()+"width"+(size.height).toString()+"height");
    Paint p = Paint();
    p..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // canvas.drawLine(Offset.zero, lines[0].end, p);
    // canvas.translate(lines[0].end.dx,lines[0].end.dy);
    // canvas.drawLine(Offset.zero, Offset(100,100), p);
    for(int i =0;i<lines.length;i++) {
      canvas.drawLine(Offset.zero, lines[i].end, p);
      canvas.translate(lines[i].end.dx,lines[i].end.dy);
    }

  }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   return true;
  }

}
//
// class LineDrawer extends CustomPainter{
//   double bx,by,width,x,y;
//   List<Line> lines;
//   LineDrawer(this.bx,this.by,this.width,this.x,this.y);
//   @override
//   void paint(Canvas canvas, Size size) {
//     double m = (y - by)/(x-bx);
//     Paint p = Paint();
//     canvas.translate(bx, by);
//     double dx = width /2;
//     if(x < bx)
//       dx = -width/2;
//     double dy = m * (dx);
//     p..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//
//     canvas.drawLine(Offset.zero, Offset(dx,dy), p);
//
//
//     canvas.translate(dx, dy);
//     dx = 2*dx*(-1);
//     // canvas.drawLine( Offset.zero,Offset(100,100), p);
//     m = m*(-1);
//     dy = m * (dx);
//     canvas.drawLine(Offset.zero, Offset(dx,dy), p);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
//
// }
// class LineDrawer extends CustomPainter{
//   double x1,y1,x2,y2;
//   LineDrawer(this.x1,this.y1,this.x2,this.y2);
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint p = Paint();
//     p..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//     canvas.drawLine(Offset(x1,y1), Offset(x2,y2), p);
//     // TODO: implement paint
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
//
// }
