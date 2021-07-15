import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/Bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BubbleService extends ChangeNotifier {
  List colors = [BubbleColor1, BubbleColor2, BubbleColor3, BubbleColor0];
  List<List<Bubble>> allBubble = [];
  List<Color> firedBubbleColor = [];
  int moves = 10;
 int bubbleColumns =21;
  setDefaultData() {
    allBubble = [];
    Color bubbleColor = BubbleColor0;


    for (int i = 0; i < bubbleColumns; i++) {
      List<Bubble> listOfBubbleColumn = [];
      Color localColor;

      for (int j = 0; j < 10; j++) {
        // bubbleColor = BubbleColor0;
        // if (i < 10) {
        //   var rng = new Random();
        //   int rand = rng.nextInt(3);
        //   bubbleColor = colors[rand];
        // }
        if(i<=3){
          localColor = BubbleColor1;
        }
        else if(i>3&& i<6){
          localColor = BubbleColor2;
        }
        else if(i>=6&& i<7){
          localColor = BubbleColor3;
        }
        else{
          localColor = BubbleColor0;
        }
        if(j==9 ){
          localColor = BubbleColor2;
        }if(j==0 ){
          localColor = BubbleColor2;
        }
        Bubble  single = singleBubble(i, j,localColor);
        listOfBubbleColumn.add(single);


      }
      allBubble.add(listOfBubbleColumn);
    }

  }

  Bubble singleBubble(int i, int j,Color newColor) {
    int top = i - 1;
    int bottom = i + 1;


    int left = j - 1;
    int right = j + 1;

    if (i != 0) {
      top = i - 1;
    }
    if (j != 0) {
      left = j - 1;
    }
    if (i == bubbleColumns-1) {
      bottom = -1;
    }
    if (j == 9) {
      right = -1;
    }

    //   List<List> coordinate =[[top,left],[top,j],[top,right],[i,left],[i,right],[bottom,left],[bottom,j],[bottom,right]];

    List<BubblesCoordinate> surroundingCoordinate = [
      BubblesCoordinate(y: top, x: left),
      BubblesCoordinate(y: top, x: j),
      BubblesCoordinate(y: top, x: right),
      BubblesCoordinate(y: i, x: left),
      BubblesCoordinate(y: i, x: right),
      BubblesCoordinate(y: bottom, x: left),
      BubblesCoordinate(y: bottom, x: j),
      BubblesCoordinate(y: bottom, x: right),
    ];
    // print('i=${i}');
    // print('j=${j}');
    // print('cordi=${coordinate}');
    BubblesCoordinate bubbleCoordinate = BubblesCoordinate(y: i, x: j);

    Bubble _bu = Bubble(
        // bubbleColor: bubbleColor,
          bubbleColor: newColor,
        bubbleCoordinate: bubbleCoordinate,
        surroundingCoordinate: surroundingCoordinate);
    return _bu;
  }

  assignColorToFiredBubbleColor() {
    firedBubbleColor = [];
    for (int i = 0; i < 3; i++) {
      var rng = new Random();
      int rand = rng.nextInt(3);
      List colors = [
        BubbleColor1,
        BubbleColor2,
        BubbleColor3,
      ];
      firedBubbleColor.add(colors[rand]);

    }

  }

  removeFiredColorFromQueue(int index){
    firedBubbleColor.removeAt(index);
    moves=moves-1;

    notifyListeners();
  }

  firedFunction(int y,int x,Color newBubble )async{
    List colors = [BubbleColor1, BubbleColor2, BubbleColor3,];
    //Bubble newbubble = Bubble(bubbleColor: newBubble,bubbleCoordinate: allBubble[y][x].bubbleCoordinate,surroundingCoordinate:allBubble[y][x].surroundingCoordinate );
    Bubble newbubble =  assignNewValueToBubbleClass(y, x, newBubble);

    List<BubblesCoordinate> removeNode =[];
    List<BubblesCoordinate> actualRemoveNode =[];
    List<BubblesCoordinate> fallNode =[];
    Bubble check = allBubble[y][x];
    for(int i=0;i<8;i++){
      int checkY=check.surroundingCoordinate[i].y;
      int checkX=check.surroundingCoordinate[i].x;
      if(checkY!=-1&&checkX!=-1){
        Bubble surroundCheck = allBubble[checkY][checkX];
        if(check.bubbleColor==surroundCheck.bubbleColor){
          BubblesCoordinate remove = BubblesCoordinate(y: checkY,x: checkX);
          removeNode.add(remove);
          actualRemoveNode.add(remove);
        }
      }

    }


    do{
      for(int j=0;j<removeNode.length;j++){
        int removeY=removeNode[j].y;
        int removeX=removeNode[j].x;
        for(int k=0;k<8;k++){
          int removeSurroundY= allBubble[removeY][removeX].surroundingCoordinate[k].y;
          int removeSurroundX= allBubble[removeY][removeX].surroundingCoordinate[k].x;
          if(removeSurroundY!=-1 && removeSurroundX!= -1){

            if(allBubble[removeSurroundY][removeSurroundX].bubbleColor==check.bubbleColor){
              BubblesCoordinate remove = BubblesCoordinate(y: removeSurroundY,x: removeSurroundX);
              removeNode.add(remove);
              actualRemoveNode.add(remove);
            }
          }
        }
       Bubble removeBubble=assignNewValueToBubbleClass(removeY, removeX, Colors.transparent);
       // Bubble newbubble = Bubble(bubbleColor: Colors.transparent,bubbleCoordinate: allBubble[removeY][removeX].bubbleCoordinate,surroundingCoordinate:allBubble[removeY][removeX].surroundingCoordinate );
      //  allBubble[removeY][removeX] =removeBubble;
        removeNode.removeAt(j);
       // print(removeNode);
      }
    }while(removeNode.length !=0);

    for(int m=0;m<actualRemoveNode.length;m++){
      int checkY=actualRemoveNode[m].y;
      int checkX=actualRemoveNode[m].x;

        if(checkY!=-1&&checkX!=-1){
          for(int n=0;n<8;n++)
          {
            int inspectY=allBubble[checkY][checkX].surroundingCoordinate[n].y;
            int inspectX =allBubble[checkY][checkX].surroundingCoordinate[n].x;
            List<bool> anyTransparent=[];// to  check there is any surrounding node is transparent
           if(inspectY!=-1&& inspectX!=-1){
             for(int o=0;o<8;o++){
               int fallY = allBubble[inspectY][inspectX].surroundingCoordinate[o].y;
               int fallX = allBubble[inspectY][inspectX].surroundingCoordinate[o].x;
               if(fallY!=-1&& fallX!=-1){
                 if(allBubble[fallY][fallX].bubbleColor==BubbleColor0){
                   anyTransparent.add(true);// yes node color is  transparent
                 }else{
                   anyTransparent.add(false);//  node color is not transparent
                 }
               }
             }
             if(anyTransparent.contains(false)){

             }else{
               if(allBubble[inspectY][inspectX].bubbleColor!=BubbleColor0){
                 BubblesCoordinate fall = assignCoordinates(inspectY , inspectX);
                 fallNode.add(fall);
                 // Bubble newbubble = Bubble(bubbleColor: Colors.black,bubbleCoordinate: allBubble[inspectY][inspectX].bubbleCoordinate,surroundingCoordinate:allBubble[inspectY][inspectX].surroundingCoordinate );
                 // allBubble[inspectY][inspectX] =newbubble;
               }
             }

           }

          }
      }

     //    // checkY entire row whether entire row is remove or not
      List<BubblesCoordinate> rowFallList = calculateRemoveRow(fallNode);
      fallNode.addAll(rowFallList);
      fallMethod(fallNode);

    }
    notifyListeners();
  }
  List<BubblesCoordinate> calculateRemoveRow(List<BubblesCoordinate> fallNodeList){
    List<BubblesCoordinate> removeRows =[];
    for(int a=0;a<bubbleColumns;a++){
      int removeY=a;
      List<bool> removeBelowRow=[];
      for(int b=0;b<allBubble[a].length;b++){
        int removeX =b;
        if(allBubble[removeY][removeX].bubbleColor==BubbleColor0){
          removeBelowRow.add(true);
        }else{
          removeBelowRow.add(false);
        }

      }
      if(removeBelowRow.contains(!false)){
        for(int c=0;c<allBubble[a].length;c++){
          int rowX =c;
          // Bubble assignValueToBubble = assignNewValueToBubbleColor(removeY, removeX, Colors.black);
          BubblesCoordinate coordinate =assignCoordinates(removeY,rowX);
          if(fallNodeList.contains(coordinate)){

          }else{
            removeRows.add(coordinate);
          }

        }

      }
    }
    return removeRows;
  }
  fallMethod(List<BubblesCoordinate> fallNodeList){
    for(int i=0;i<fallNodeList.length;i++){
      int y = fallNodeList[i].y;
      int x = fallNodeList[i].x;
      Bubble bubble= assignNewValueToBubbleClass(y, x, Colors.black);

    }
  }

  Bubble assignNewValueToBubbleClass(int y,int x,Color newColor){

    Bubble newbubble = Bubble(bubbleColor: newColor,bubbleCoordinate: allBubble[y][x].bubbleCoordinate,surroundingCoordinate:allBubble[y][x].surroundingCoordinate );
    allBubble[y][x] =newbubble;
    return newbubble;
  }
  BubblesCoordinate assignCoordinates(int y,int x){
    BubblesCoordinate value = BubblesCoordinate(y: y,x: x);
    return value;
  }

}
