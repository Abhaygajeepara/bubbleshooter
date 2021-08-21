import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class SingleBubble extends StatefulWidget {

  final BubbleModel bubbleModel;
   const SingleBubble({ required this.bubbleModel}) ;
 // const SingleBubble({required this.bubbleModel});
  @override
  _SingleBubbleState createState() => _SingleBubbleState();
}

class _SingleBubbleState extends State<SingleBubble> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bubbleData = context.read(jBubbleProvider);

    double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
    return Positioned(
      left: widget.bubbleModel.left,
      top: widget.bubbleModel.top,
      child: GestureDetector(
        onTap: (){
          bubbleData.setTarget(widget.bubbleModel.i, widget.bubbleModel.j);
        },
        child: Container(
          height: ballWidth,
          width: ballWidth,
          decoration: BoxDecoration(
              color: widget.bubbleModel.bubbleColor,
              border: Border.all(
                  color:
                  bubbleData.targetY==widget.bubbleModel.i && bubbleData.targetX==widget.bubbleModel.j?
                  Colors.white: widget.bubbleModel.bubbleColor,width: 10
              ),
              boxShadow: [
                widget.bubbleModel.bubbleColor != Colors.transparent
                    ? BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0),
                )
                    : BoxShadow(
                  color: widget.bubbleModel.bubbleColor,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0),
                ),
              ], shape: BoxShape.circle
          ),
         // child: Text(i.first.i.toString()+j.j.toString()),
        ),
      ),
    );
  }
}



// old widger
// class SingleBubble extends StatefulWidget {
//   Color buubleColor ;
//   //todo remove x and y
//   int x;
//   int y;
//   bool isVisible;
//   SingleBubble({required this.buubleColor,required this.y,required this.x,required this.isVisible});
//
//   @override
//   _SingleBubbleState createState() => _SingleBubbleState();
// }
//
// class _SingleBubbleState extends State<SingleBubble> with TickerProviderStateMixin {
//     late AnimationController _animationController;
// late  Animation _animation;
//     Offset offset = Offset.zero;
// GlobalKey key= GlobalKey();
// @override
//   void initState() {
//     // TODO: implement initState
//   _animationController= AnimationController(duration: Duration(seconds: 2),vsync: this);
//   _animation = Tween(begin: 0,end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInSine));
//
//     super.initState();
//   }
//     bool _visible = true;
//   @override
//   Widget build(BuildContext context) {
//
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final bubbleData= context.read(bubbleProvider);
//     final con=bubbleData.targetY==38 && bubbleData.targetX==3;
//
//
//     Color borderColor =bubbleData.targetY==widget.y&&bubbleData.targetX==widget.x?Colors.brown:Colors.transparent;
//
//
//     return GestureDetector(
//       onTap: (){
//         bubbleData.setTarget(widget.y, widget.x);
//
//         setState(() {
//
//         });
//       },
//       child: Padding(
//
//         padding:  EdgeInsets.symmetric(horizontal: 1),
//         child:  AnimatedOpacity(
//
//           opacity: widget.isVisible ? 1.0 : 0.0,
//           duration: const Duration(milliseconds: 200),
//           child: Transform.translate(
//             offset:con?Offset(0.0, 1): Offset(0.0, 0.0),
//             child: Container(
//               key: key,
//               decoration: BoxDecoration(
//                   color: widget.buubleColor,
//                   border: Border.all(
//                     color: borderColor,width: 10
//                   ),
//                   boxShadow: [
//                     widget.buubleColor != Colors.transparent
//                         ? BoxShadow(
//                       color: Colors.black,
//                       blurRadius: 2.0,
//                       spreadRadius: 0.0,
//                       offset: Offset(2.0, 2.0),
//                     )
//                         : BoxShadow(
//                       color: widget.buubleColor.withOpacity(_animationController.value),
//                       blurRadius: 2.0,
//                       spreadRadius: 0.0,
//                       offset: Offset(2.0, 2.0),
//                     ),
//                   ], shape: BoxShape.circle
//               ),
//               width: width*0.99 / 11,
//               child: Center(child:
//
//               Text('${widget.y},${widget.x}',style: TextStyle(color: Colors.yellow,fontSize: 10),)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// extension GlobalKeyExtension on GlobalKey {
//   Rect? get globalPaintBounds {
//     final renderObject = currentContext?.findRenderObject();
//     var translation = renderObject?.getTransformTo(null).getTranslation();
//     if (translation != null && renderObject!.paintBounds != null) {
//       return renderObject.paintBounds
//           .shift(Offset(translation.x, translation.y));
//     } else {
//       return null;
//     }
//   }
//}