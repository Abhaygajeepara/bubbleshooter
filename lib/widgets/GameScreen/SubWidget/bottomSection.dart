import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firedBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotomSection extends StatefulHookWidget {
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
   final bubbleData= useProvider(bubbleProvider);
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
        // print("bx"+bx.toString()+"by"+by.toString()+"dx"+dx.toString()+"dy"+dy.toString());
      },
      child: Container(
          height: size.height * 0.3,
          width: size.width,
          color: bottomBarBgColor,
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
                ElevatedButton(onPressed: ()async{
                  if(bubbleData.firedBubbleColor.length!=0){
                  await  bubbleData.firedFunction();
                await    bubbleData.removeFiredColorFromQueue(0);
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
                              bubbleData.setDefaultData();
                              bubbleData.assignColorToFiredBubbleColor();
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