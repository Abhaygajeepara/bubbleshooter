import 'package:bubble/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class FiredBubble extends StatefulWidget {
  Color bubbleColor;
  FiredBubble({required this.bubbleColor});
  @override
  _FiredBubbleState createState() => _FiredBubbleState();
}

class _FiredBubbleState extends State<FiredBubble> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bubbleData= context.read(bubbleProvider);
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 0.1),
      child: Container(
        decoration: BoxDecoration(
            color: widget.bubbleColor,
            boxShadow: [
              widget.bubbleColor != Colors.transparent
                  ? BoxShadow(
                color: Colors.black,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0),
              )
                  : BoxShadow(
                color:widget.bubbleColor,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0),
              ),
            ],
            shape: BoxShape.circle),
        width: size.width*0.99 / 11,
        // child: Center(child:
        //
        // Text('${index},${subIndex}',style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
