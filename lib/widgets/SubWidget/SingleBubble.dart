import 'package:bubble/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleBubble extends StatefulWidget {
  Color buubleColor ;
  //todo remove x and y
  int x;
  int y;
  SingleBubble({required this.buubleColor,required this.y,required this.x});
  @override
  _SingleBubbleState createState() => _SingleBubbleState();
}

class _SingleBubbleState extends State<SingleBubble> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bubbleData= context.read(buubleProvider);
    Color borderColor =bubbleData.targetY==widget.y&&bubbleData.targetX==widget.x?Colors.brown:Colors.transparent;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 0.1),
      child: GestureDetector(
        onTap: (){
          bubbleData.setTarget(widget.y, widget.x);
          setState(() {

          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: widget.buubleColor,
              border: Border.all(
                color: borderColor,width: 10
              ),
              boxShadow: [
                widget.buubleColor != Colors.transparent
                    ? BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0),
                )
                    : BoxShadow(
                  color: widget.buubleColor,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
              shape: BoxShape.circle),
          width: size.width*0.99 / 11,
          child: Center(child:

          Text('${widget.y},${widget.x}',style: TextStyle(color: Colors.yellow,fontSize: 10),)),
        ),
      ),
    );
  }
}
