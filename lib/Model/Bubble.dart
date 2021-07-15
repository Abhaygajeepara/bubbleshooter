import 'package:flutter/cupertino.dart';

class Bubble {
  Color bubbleColor;
  BubblesCoordinate bubbleCoordinate;
  List<BubblesCoordinate> surroundingCoordinate;
  Bubble({
    required this.bubbleColor,
    required this.bubbleCoordinate,
    required this.surroundingCoordinate,
  });
}

class BubblesCoordinate {
  int y;
  int x;

  BubblesCoordinate({
    required this.y,
    required this.x,
  });
}