import 'package:bubble/main.dart';
import 'firedBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotomSection extends StatefulWidget {
  @override
  _BotomSectionState createState() => _BotomSectionState();
}

class _BotomSectionState extends State<BotomSection> {
  double x = 0,y =0;
  double bx =0,by =0;
  double dy = 0;
  double dx = 0;
  @override
  Widget build(BuildContext context) {
   final bubbleData= context.read(buubleProvider);
    final size = MediaQuery.of(context).size;
    bx = size.width /2;
    by = size.height  * .15;
    return GestureDetector(
      onPanDown: (val){
        x = val.localPosition.dx;
        y = val.localPosition.dy;
       // print(x.toString()+"//"+y.toString());
      },
      onPanUpdate: (val){
        x = val.localPosition.dx;
        y = val.localPosition.dy;
        // if(x == bx){
        //   x = x-1;
        // }
        double m =(y - by)/(x- bx);
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

        setState(() {

        });
        // print("on upfdate" + x.toString()+"///"+y.toString());
      },
      child: Container(
          height: size.height * 0.3,
          width: size.width,
          color: Colors.black,
          child: CustomPaint(
            painter: customPaintrt(bx,by,dx,dy),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                //firedBubbleQueue(bubbleData),
                Text( "y="+bubbleData.targetY.toString()+"   "+"x="+bubbleData.targetY.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                bubbleData.firedBubbleColor.length <= 0
                    ? Container()
                    : FiredBubble(bubbleColor:bubbleData.firedBubbleColor[0]),
                ElevatedButton(onPressed: (){
                  bubbleData.firedFunction();
                  bubbleData.removeFiredColorFromQueue(0);
                }, child: Text('Fire'))
              ],
            ),
          )),
    );
  }
}
class customPaintrt extends CustomPainter{
  double x1,y1,x2,y2;
  customPaintrt(this.x1,this.y1,this.x2,this.y2);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint();
    p..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(Offset(x1,y1), Offset(x2,y2), p);
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}