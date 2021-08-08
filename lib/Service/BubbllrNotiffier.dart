

import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
int maxRaw = 10;
final jBubbleProvider = ChangeNotifierProvider<BubbleNotifier>((_ref)=>BubbleNotifier());
class BubbleNotifier extends ChangeNotifier{
  List<List<BubbleModel>> bubbles = [];
  bool isInitialized = false;
  List<Color> bubbleColors = [BubbleColor1, BubbleColor2, BubbleColor3];
  BubbleNotifier();
  void init(Size size){
    if(!isInitialized){
      bubbles.clear();
      for(int i =0;i<maxRaw;i++){
        int a = i % 2 == 0 ? 11 : 10;
        List<BubbleModel> raw = [];
        for(int j =0;j<a;j++){
          Color bubbleColor = BubbleColor0;
          var rng = new Random();
          int random = rng.nextInt(3);
          bubbleColor = bubbleColors[random];
          raw.add(BubbleModel(size: size, i: i, j: j, bubbleColor: bubbleColor, isVisible: true));
        }
        bubbles.add(raw);
      }
      // notifyListeners();
    }
  }
}
class BubbleModel{
  Color bubbleColor;
  late double left,top;
  int  i,j;
  late Offset bubbleCoordinate;
  late Set<Offset> surroundingCoordinate;
  bool isVisible;
  Size size;
  BubbleModel({
    required this.size,
    required this.i,
    required this.j,

    required this.bubbleColor,
    required this.isVisible
  }){
   setSurroundings();
   setPosition();
  }
  void setPosition(){
    double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
    double initialTop = 0;
    top = initialTop  + (ballWidth -2) * i;
    left = 1 +(ballWidth+1)*j;
    if(i % 2 != 0){
      left = left + ballWidth /2;
    }
  }
  void setSurroundings(){
    bubbleCoordinate = Offset(i.toDouble(), j.toDouble());
    Set<List<int>> surroundinCords = {};
    Set<Offset> finalCords = {};
    surroundinCords.add([i,j-1]);
    surroundinCords.add([i,j+1]);
    bool is11 = i & 2 ==0;
    if(is11){
      surroundinCords.add([i-1,j-1]);
      surroundinCords.add([i-1,j]);
      surroundinCords.add([i+1,j-1]);
      surroundinCords.add([i+1,j]);
    }
    else{
      surroundinCords.add([i-1,j]);
      surroundinCords.add([i-1,j+1]);
      surroundinCords.add([i+1,j]);
      surroundinCords.add([i+1,j+1]);
    }
    for(int a =0;a<surroundinCords.length;a++){
      final current = surroundinCords.elementAt(a);
      if(current.first >= 0 && current.first < 40){
        bool is11 = current.first % 2 ==0;
        if(is11 && current.last >= 0 && current.last < 11){
          finalCords.add(Offset(current.first.toDouble(),current.last.toDouble()));
        }
        else if(current.last >= 0 && current.last < 10){
          finalCords.add(Offset(current.first.toDouble(),current.last.toDouble()));
        }
      }
    }
    surroundingCoordinate = finalCords;
  }

}