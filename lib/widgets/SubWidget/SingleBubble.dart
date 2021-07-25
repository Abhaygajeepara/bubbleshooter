import 'package:flutter/material.dart';

class SingleBubble extends StatefulWidget {
  Color buubleColor ;
  SingleBubble({required this.buubleColor});
  @override
  _SingleBubbleState createState() => _SingleBubbleState();
}

class _SingleBubbleState extends State<SingleBubble> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 0.1),
      child: Container(
        decoration: BoxDecoration(
            color: widget.buubleColor,
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
        // child: Center(child:
        //
        // Text('${index},${subIndex}',style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
