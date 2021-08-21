import 'package:bubble/Common/Commonvalue.dart';
import 'package:flutter/material.dart';

class BubbleModel{
  Color bubbleColor;
  late double left,top;
  int  i,j;
  late Offset bubbleCoordinate;
  late Set<Offset> surroundingCoordinate;
  bool isVisible;
  Size size;
  int  maxRaw;
  bool isRender =false;
  BubbleModel({
    required this.size,
    required this.i,
    required this.j,
    required this.bubbleColor,
    required this.isVisible,
    required this.maxRaw,
    required this.isRender,
  }){
    setSurroundings();
    setPosition();
  }
  void setPosition(){
    double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
    //double initialTop = 0;
    double initialTop = size.width/21;
    top = initialTop  + (ballWidth -2) * i;
    //left = 1 +(ballWidth+1)*j;
    double half =(size.width/11)/2;
    left = half+1 +(ballWidth+1)*j;
    if(i % 2 != 0){
      left = left + ballWidth /2;
    }
  }
  void setSurroundings(){
    bubbleCoordinate = Offset(j.toDouble(), i.toDouble());
    Set<List<int>> surroundinCords = {};
    Set<Offset> finalCords = {};

    bool is11 = i % 2 ==0 ;
    if(is11){

      surroundinCords.add([i-1,j-1]);
      surroundinCords.add([i-1,j]);
      surroundinCords.add([i,j-1]);
      surroundinCords.add([i,j+1]);
      surroundinCords.add([i+1,j-1]);
      surroundinCords.add([i+1,j]);
    }
    else{

      surroundinCords.add([i-1,j]);
      surroundinCords.add([i-1,j+1]);
      surroundinCords.add([i,j-1]);
      surroundinCords.add([i,j+1]);
      surroundinCords.add([i+1,j]);
      surroundinCords.add([i+1,j+1]);
    }
    for(int a =0;a<surroundinCords.length;a++){
      final current = surroundinCords.elementAt(a);

      if(current.first >= 0 && current.first < maxRaw){

        bool is11 = current.first % 2 ==0;
        if(is11 && current.last >= 0 && current.last < 11){
          finalCords.add(Offset(current.last.toDouble(),current.first.toDouble()));
        }
        else if(current.last >= 0 && current.last < 10){
          finalCords.add(Offset(current.last.toDouble(),current.first.toDouble()));
        }
      }
    }
    surroundingCoordinate = finalCords;
    // print("i=${i.toString()}, j=${j.toString()}");
    // print(surroundinCords);
    // print(surroundingCoordinate);

  }

}