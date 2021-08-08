

import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:flutter/material.dart';
int maxRaw = 40;
class BubbleNotifier extends ChangeNotifier{
  List<List<BubbleModel>> bubbles = [];
  List<Color> bubbleColors = [BubbleColor1, BubbleColor2, BubbleColor3];
  BubbleNotifier();
  void init(Size size){

    for(int i =0;i<40;i++){
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
    double ballWidth = (size.width - 22) / 11;
    double initialTop = 0;
    top = initialTop  + (ballWidth + 1) * i;
    left = 1 +(ballWidth+1)*j;
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