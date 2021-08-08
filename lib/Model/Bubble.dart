import 'package:flutter/cupertino.dart';

class Bubble {
  GlobalKey key=GlobalKey();
  Color bubbleColor;
  Offset bubbleCoordinate;
  Set<Offset> surroundingCoordinate;
  bool isVisible;
  Bubble({
    required this.bubbleColor,
    required this.bubbleCoordinate,
    required this.surroundingCoordinate,
    required this.isVisible
  });
}

// class BubblesCoordinate {
//   int y;
//   int x;
//
//   BubblesCoordinate({
//     required this.y,
//     required this.x,
//   });
//
//
//   @override
//   int get hashCode {
//     return super.hashCode;
//   }
//
//   @override
//   bool operator == (Object other) {
//     if(other is BubblesCoordinate) {
//       return x == other.x && y == other.y;
//     }
//    return false;
//   }
// }