import 'dart:async';
import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/Bubble.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BubbleService extends ChangeNotifier {
  List<Color> bubbleColors = [BubbleColor1, BubbleColor2, BubbleColor3];
 // List bubbleColors = [BubbleColor1, BubbleColor2, BubbleColor3, BubbleColor0];

  // for gameScreen
  int displayBubbleColumn=10;
  //int currentTopColumn=10;

  // calculation
  List<List<Bubble>> allBubble = [];
  List<Color> firedBubbleColor = [];
  int moves = 10;
  int bubbleColorInLevel = 2;
  int bubbleColumns = 40;
  int numberSurroundingNodes = 6;
  int maximumNodeInOneRow = 11;
  int fakeTop=0;


  // target node
  int targetY = -1;
  int targetX = -1;
// lazy loading
  int startAdding = 0;
  int endAdding = 25;
  //remove fall nodes
  List<BubblesCoordinate> removeCoordinatedMain=[];
  Set<Offset> fallingNodesMain=Set();

  setStartAndEnd(int start, int end) {
    this.startAdding = start;
    this.endAdding = end;
  }

  setTarget(int y, int x) {
    this.targetY = y;
    this.targetX = x;
    notifyListeners();
  }

  setFakeTop(){

    int number =bubbleColumns-10;
    if(number<=0){
      fakeTop=0;
    }
    else{
      fakeTop=number;
    }
    print('faketop${fakeTop}');
  }
  setDisplayBubbleColumn(int val ){
    displayBubbleColumn=val;
  }
  //int fixColumn =10; // remove after testing
  resetAllBubble() {
    allBubble.clear();
  }

  setDefaultData() {
    //allBubble = [];

    for (int i = startAdding; i < endAdding; i++) {
      List<Bubble> listOfBubbleColumn = [];
      if (i == bubbleColumns - 1) {
        listOfBubbleColumn = emptyRow(i);
      } else {
        listOfBubbleColumn = setSingleRow(i);
      }

      allBubble.add(listOfBubbleColumn);
    }
    setFakeTop();
  }

  List<Bubble>  setSingleRow(int i){
    List<Bubble> listOfBubbleColumn=[];
    Color bubbleColor = BubbleColor0;
    int numberofNodesInRow;
    if(i%2==0){
      numberofNodesInRow =11;
    }else{
      numberofNodesInRow =10;
    }
    for (int j = 0; j < numberofNodesInRow; j++) {
      bubbleColor = BubbleColor0;
      var rng = new Random();
      int rand = rng.nextInt(bubbleColorInLevel);
      bubbleColor = bubbleColors[rand];

      Bubble  single = singleBubble(i, j,bubbleColor);
      listOfBubbleColumn.add(single);


    }
    return listOfBubbleColumn;
  }

  List<Bubble>  emptyRow(int i){
    List<Bubble> listOfBubbleColumn=[];
    Color bubbleColor = BubbleColor0;
    int numberofNodesInRow;
    if(i%2==0){
      numberofNodesInRow =11;
    }else{
      numberofNodesInRow =10;
    }
    for (int j = 0; j < numberofNodesInRow; j++) {
      Bubble  single = singleBubble(i, j,bubbleColor);
      listOfBubbleColumn.add(single);
    }
    return listOfBubbleColumn;
  }
/*
*   setDefaultData() {
    allBubble = [];
    Color bubbleColor = BubbleColor0;


    for (int i = 0; i < bubbleColumns; i++) {
      List<Bubble> listOfBubbleColumn = [];
      Color localColor;
      int numberofNodesInRow;
      if(i%2==0){
        numberofNodesInRow =11;
      }else{
         numberofNodesInRow =10;
      }
      for (int j = 0; j < numberofNodesInRow; j++) {
        bubbleColor = BubbleColor0;
        var rng = new Random();
        int rand = rng.nextInt(bubbleColorInLevel);
        bubbleColor = bubbleColors[rand];

        Bubble  single = singleBubble(i, j,bubbleColor);
        listOfBubbleColumn.add(single);


      }
      allBubble.add(listOfBubbleColumn);

    }
    // for(int i =0;i<allBubble.length;i++){
    //   for(int j=0;j<allBubble[i].length;j++){
    //     //print("${allBubble[i][j].bubbleCoordinate.y},${allBubble[i][j].bubbleCoordinate.x}");
    //   }
    //   //print('new');
    // }

  }
* */
  Bubble singleBubble(int i, int j,Color newColor) {
    int top = i - 1;
    int bottom = i + 1;
  int k=j;

    int left = k - 1;
    int right = k + 1;
    int topAndBottomRight= k + 1;

    if (i != 0) {
      top = i - 1;
    }
    if (k != 0) {
      left = k - 1;
    }
    if (i == bubbleColumns-1) {
      bottom = -1;
    }
    if(i%2==0){
      if (k == 10) {
        right = -1;
        topAndBottomRight =-1;
      }

    }else{
      if (k ==9) {
        right = -1;

      }
    }

    if(bottom%2!=0){
      if (k ==10) {
        right = -1;
        topAndBottomRight=-1;
        k=-1;
      }
    }
    if(top%2!=0){
      if (k ==10) {
        right = -1;
        topAndBottomRight=-1;
        k=-1;
      }
    }
    List<BubblesCoordinate>tops=[];
    List<BubblesCoordinate>bottoms=[];
    if(i%2!=0){
      tops =[
      BubblesCoordinate(y: top, x: k),
    BubblesCoordinate(y: top, x: topAndBottomRight),
      ];
      bottoms =[
        BubblesCoordinate(y: bottom, x: k),
        BubblesCoordinate(y: bottom, x: topAndBottomRight),
      ];
    }else{
      tops =[
        BubblesCoordinate(y: top, x: left),
        BubblesCoordinate(y: top, x: k),

      ];
      bottoms =[
        BubblesCoordinate(y: bottom, x: left),
        BubblesCoordinate(y: bottom, x: k),
      ];
    }
    //   List<List> coordinate =[[top,left],[top,j],[top,right],[i,left],[i,right],[bottom,left],[bottom,j],[bottom,right]];

    List<BubblesCoordinate> surroundingCoordinate = [
     tops[0],
      tops[1],
      BubblesCoordinate(y: i, x: left),
      BubblesCoordinate(y: i, x: right),
      bottoms[0],
      bottoms[1]

    ];

    BubblesCoordinate bubbleCoordinate = BubblesCoordinate(y: i, x: j);

    Bubble _bu = Bubble(
        // bubbleColor: bubbleColor,
          bubbleColor: newColor,
        bubbleCoordinate: bubbleCoordinate,
        surroundingCoordinate: surroundingCoordinate,
        isVisible: true
    );

    return _bu;
  }

  assignColorToFiredBubbleColor() {
    firedBubbleColor = [];
    for (int i = 0; i < 3; i++) {
      var rng = new Random();
      int rand = rng.nextInt(bubbleColorInLevel);

      firedBubbleColor.add(bubbleColors[rand]);

    }
    // notifyListeners();
  }

  removeFiredColorFromQueue(int index){
    firedBubbleColor.removeAt(index);
    moves=moves-1;


  }

  firedFunction( )async{
  int y = this.targetY;
  int x = this.targetX;
  Color newBubble = firedBubbleColor[0];
  removeCoordinatedMain=[];
fallingNodesMain=Set();
  if( y !=-1&& x!=-1){
    assignNewValueToBubbleClass(y, x, newBubble,true); // set new Color to define node

    List<BubblesCoordinate> removeNode =[];
    List<BubblesCoordinate> actualRemoveNode =[];
    List<BubblesCoordinate> fallNode =[];
    final Set<Offset> inspectNodeList = Set();

    Bubble check = allBubble[y][x];
    for(int i=0;i<numberSurroundingNodes;i++){
      // find surrounding node of define node
      int checkY=check.surroundingCoordinate[i].y;
      int checkX=check.surroundingCoordinate[i].x;
      if(checkY!=-1&&checkX!=-1&&checkY>=fakeTop){
        Bubble surroundCheck = allBubble[checkY][checkX];
        if(check.bubbleColor==surroundCheck.bubbleColor){
          BubblesCoordinate remove = BubblesCoordinate(y: checkY,x: checkX);
          removeNode.add(remove);
          actualRemoveNode.add(remove);
        }
      }

    }

    // compare define node Color with Surrounding Nodes until nodes has different color
    do{
      for(int j=0;j<removeNode.length;j++){
        int removeY=removeNode[j].y;
        int removeX=removeNode[j].x;
        for(int k=0;k<numberSurroundingNodes;k++){
          int removeSurroundY= allBubble[removeY][removeX].surroundingCoordinate[k].y;
          int removeSurroundX= allBubble[removeY][removeX].surroundingCoordinate[k].x;
          if(removeSurroundY!=-1 && removeSurroundX!= -1&&removeSurroundY>=fakeTop){

            if(allBubble[removeSurroundY][removeSurroundX].bubbleColor==check.bubbleColor){
              BubblesCoordinate remove = assignCoordinates( removeSurroundY, removeSurroundX);
              removeNode.add(remove);
              if( actualRemoveNode.contains(remove)==false){
                actualRemoveNode.add(remove);
              }
            }
          }
        }
        assignNewValueToBubbleClass(removeY, removeX, Colors.orange,false);
        Timer(Duration(milliseconds: 500), () {
          assignNewValueToBubbleClass(removeY, removeX, Colors.transparent,true);
        });
       // removeCoordinatedMain.add( removeNode[j]);



        removeNode.removeAt(j);

      }
    }while(removeNode.length !=0);
if(removeNode.length !=0){

  notifyListeners();
}  notifyListeners();
    calculateFalling();


  }
    //Bubble newbubble = Bubble(bubbleColor: newBubble,bubbleCoordinate: allBubble[y][x].bubbleCoordinate,surroundingCoordinate:allBubble[y][x].surroundingCoordinate );

  }

  calculateFalling(){
 final Set<Offset> checkedNode =Set();
  final Set<Offset> mustCheckedList =Set();
 fallingNodesMain=Set();

 for(int j =0;j<allBubble[fakeTop].length;j++){

   if(bubbleColors.contains(allBubble[fakeTop][j].bubbleColor)){
     int rowY = allBubble[fakeTop][j].bubbleCoordinate.y;
     int rowX = allBubble[fakeTop][j].bubbleCoordinate.x;
     Offset addCheckOffset=Offset(rowX.toDouble(), rowY.toDouble());
     checkedNode.add(addCheckOffset);
     for(int k=0;k<allBubble[fakeTop][j].surroundingCoordinate.length;k++){
       int surroundingY=allBubble[fakeTop][j].surroundingCoordinate[k].y;
       int surroundingX=allBubble[fakeTop][j].surroundingCoordinate[k].x;
       if(surroundingY!=-1&&surroundingX!=-1&&surroundingY>=fakeTop){
         Offset addNode = Offset(surroundingX.toDouble(),surroundingY.toDouble(),);
         mustCheckedList.add(addNode);

       }
     }
   }

 }



 do{
   int mustLength = mustCheckedList.length;
   for(int i =0;i<mustLength;i++){

     if(checkedNode.contains(mustCheckedList.elementAt(0))==false){
         int mustY= mustCheckedList.elementAt(0).dy.toInt();
         int mustX= mustCheckedList.elementAt(0).dx.toInt();

          bool isTopRowBubble=mustY==0?true:false;
          if(mustY!=-1&&mustX!=-1&&mustY>=fakeTop){

            if(bubbleColors.contains(allBubble[mustY][mustX].bubbleColor)){

              if(isTopRowBubble){
                // then check node color if node's bubble color is  transparent then ignore the node
                  for(int a = 2;a<allBubble[mustY][mustX].surroundingCoordinate.length;a++){
                    int addY =  allBubble[mustY][mustX].surroundingCoordinate[a].y;
                    int addX =  allBubble[mustY][mustX].surroundingCoordinate[a].x;
                    Offset addOffest = Offset(addX.toDouble(),addY.toDouble());

                    mustCheckedList.add(addOffest);
                  }
                  // outside for
                checkedNode.add(mustCheckedList.elementAt(0));
              }else{
                List<bool> supportedAboveNodes =[]; // true // node has support from above nodes false //vice versa
                for(int b=0;b<2;b++){
                  int aboveY = allBubble[mustY][mustX].surroundingCoordinate[b].y;
                  int aboveX = allBubble[mustY][mustX].surroundingCoordinate[b].x;
                  if(aboveY!=-1&&aboveX!=-1 &&aboveY>=fakeTop){
                    if(allBubble[aboveY][aboveX].bubbleColor==BubbleColor0){
                      // means node is empty bubbleColor0 = transparent
                      supportedAboveNodes.add(false);
                    }else{
                      supportedAboveNodes.add(true);
                    }
                  }
                }

                // out b for loop
                  if(supportedAboveNodes.contains(true)){
                    for(int a = 0;a<allBubble[mustY][mustX].surroundingCoordinate.length;a++){
                      int addY =  allBubble[mustY][mustX].surroundingCoordinate[a].y;
                      int addX =  allBubble[mustY][mustX].surroundingCoordinate[a].x;
                      Offset addOffest = Offset(addX.toDouble(),addY.toDouble());
                      if(checkedNode.contains(addOffest)==false){
                        mustCheckedList.add(addOffest);
                      }

                    }
                    checkedNode.add(mustCheckedList.elementAt(0));
                  }

              }

            }


          }
     }else{
      // nothing
     }

     mustCheckedList.remove(mustCheckedList.elementAt(0));
     mustLength = mustCheckedList.length;

   }
 }while(mustCheckedList.length!=0);




// for(int i =0;i<allBubble.length;i++){
//   for(int j=0;j<allBubble[i].length;j++){
//     if(allBubble[i][j].bubbleColor!=BubbleColor0){
//       int offsetY =allBubble[i][j].bubbleCoordinate.y;
//       int offsetX =allBubble[i][j].bubbleCoordinate.x;
//       Offset guessOffset = Offset(offsetX.toDouble(),offsetY.toDouble());
//       if(checkedNode.contains(guessOffset)==false){
//         fallingNodes.add(guessOffset);
//       }
//
//       // bool isFound =false;
//       // for(int n=0;n<allBubble[i][j].surroundingCoordinate.length;n++){
//       //   int checkY= allBubble[i][j].surroundingCoordinate[n].y;
//       //   int checkX= allBubble[i][j].surroundingCoordinate[n].x;
//       //   Offset guessOffset = Offset(checkX.toDouble(),checkY.toDouble());
//       //   if(checkedNode.contains(guessOffset)){
//       //     checkedNode.add(guessOffset);
//       //     isFound =true;
//       //     break;
//       //   }
//       // }
//       //
//       // if(isFound==false){
//       //   Offset check =Offset(offsetX.toDouble(), offsetY.toDouble());
//       //   if(checkedNode.contains(check)==false){
//       //     fallingNodes.add(check);
//       //     // allBubble[i][j].bubbleColor =Colors.white;
//       //   }
//       // }
//
//     }
//   }
// }
bool checkingContinue = true;
int checkNodeLength=checkedNode.length;

do{
  bool valueChanged = false;

  for(int i =0;i<allBubble.length;i++){
    for(int j=0;j<allBubble[i].length;j++){
      if(bubbleColors.contains(allBubble[i][j].bubbleColor)){
        int offsetY =allBubble[i][j].bubbleCoordinate.y;
        int offsetX =allBubble[i][j].bubbleCoordinate.x;
        Offset guessOffset = Offset(offsetX.toDouble(),offsetY.toDouble());

        if(checkedNode.contains(guessOffset)==false){

          for(int q=0;q<allBubble[offsetY][offsetX].surroundingCoordinate.length;q++){
           int surroundingY= allBubble[offsetY][offsetX].surroundingCoordinate[q].y;
           int surroundingX= allBubble[offsetY][offsetX].surroundingCoordinate[q].x;
           Offset surrondingOffset =Offset(surroundingX.toDouble(),surroundingY.toDouble());
           if(checkedNode.contains(surrondingOffset)){
             valueChanged =true;
             checkedNode.add(guessOffset);
          //   print( "chhedd="+ surrondingOffset.toString());

           }
          }
        }

      }
    }

  }

  if(valueChanged==true){
    checkingContinue= true;
  }else{
    checkingContinue=false;
  }


}while(checkingContinue!=false);
// check is node check or not
    for(int i =0;i<allBubble.length;i++){
      for(int j=0;j<allBubble[i].length;j++){
        if(bubbleColors.contains(allBubble[i][j].bubbleColor)){
          int offsetY =allBubble[i][j].bubbleCoordinate.y;
          int offsetX =allBubble[i][j].bubbleCoordinate.x;
          Offset guessOffset = Offset(offsetX.toDouble(),offsetY.toDouble());

          if(checkedNode.contains(guessOffset)==false){
            // allBubble[i][j].bubbleColor=Colors.white;
            fallingNodesMain.add(guessOffset);
          }

        }
      }

    }

    setTarget(-1, -1);
  //  removeRow();
  //  fallAndRemoveMethod();
    //function over
  }



  fallAndRemoveMethod(){
    //falling
    for(int i=0;i<fallingNodesMain.length;i++){
      int y = fallingNodesMain.elementAt(i).dy.toInt();
      int x = fallingNodesMain.elementAt(i).dx.toInt();
      // change
    assignNewValueToBubbleClass(y, x, Colors.white,true);
    }
    for(int i=0;i<removeCoordinatedMain.length;i++){
      int _y = removeCoordinatedMain[i].y;
      int _x = removeCoordinatedMain[i].x;
      // change
     assignNewValueToBubbleClass(_y, _x, Colors.transparent,true);
    }
notifyListeners();

  }

  Bubble assignNewValueToBubbleClass(int y,int x,Color newColor,bool visible){

    Bubble newbubble = Bubble(bubbleColor: newColor,bubbleCoordinate: allBubble[y][x].bubbleCoordinate,surroundingCoordinate:allBubble[y][x].surroundingCoordinate,  isVisible: visible   );
    allBubble[y][x] =newbubble;
    return newbubble;
  }
  BubblesCoordinate assignCoordinates(int y,int x){
    BubblesCoordinate value = BubblesCoordinate(y: y,x: x);
    return value;
  }
  removeRow(){
    int _st=allBubble.length-1;
    int _en=allBubble.length-displayBubbleColumn;
    int numberOfEmptyRow =0;
    for(int i= _st;i>_en;i--){
    List<bool> addBool =[];
      for(int j=0;j<allBubble[i].length;j++){

        if(bubbleColors.contains(allBubble[i][j].bubbleColor)){
          addBool.add(false);
        }
        else{
          addBool.add(true);
        }
      }

      if(addBool.contains(false)){


      }else{
        numberOfEmptyRow=numberOfEmptyRow+1;
        if(numberOfEmptyRow>1){
          allBubble.removeAt(i);
          _st=allBubble.length-1;
          _en=allBubble.length-displayBubbleColumn;
          bubbleColumns=allBubble.length;
        }

      //  displayBubbleColumn=displayBubbleColumn-1;

      }

    }

setFakeTop();


  }
}




// remove later

// List<BubblesCoordinate> calculateRemoveRow(List<BubblesCoordinate> fallNodeList){
//   List<BubblesCoordinate> removeRows =[];
//   int emptyRow =-1;
//   // check all bubble nodes Column
//   for(int a=0;a<bubbleColumns;a++){
//     int removeY=a;
//     List<bool> removeBelowRow=[];
//     for(int b=0;b<currentScreenBubble[a].length;b++){
//       int removeX =b;
//       if(currentScreenBubble[removeY][removeX].bubbleColor==BubbleColor0){
//         removeBelowRow.add(true);
//       }else{
//         removeBelowRow.add(false);
//       }
//
//     }
//     if(removeBelowRow.contains(false)){}else{
//       emptyRow=a;
//       break;
//       // loop stop at when it find empty row(every node of this row does have transparent color)
//     }
//   }
//   // add nodes which needs to be fall
//   if(emptyRow>-1){
//     for(int j=emptyRow+1;j<bubbleColumns;j++){
//       int removeRowIndexY = j;
//       for(int c=0;c<currentScreenBubble[removeRowIndexY].length;c++){
//         int rowX =c;
//
//         if(currentScreenBubble[removeRowIndexY][rowX].bubbleColor!=BubbleColor0){
//
//           BubblesCoordinate coordinate =assignCoordinates(removeRowIndexY,rowX);
//           if(fallNodeList.contains(coordinate)){
//
//           }else{
//             removeRows.add(coordinate);
//           }
//         }
//
//       }
//     }
//   }
//
//   return removeRows;
// }

// fall functionality

// fall node which does not have any surrounding node with same color
// for(int m=0;m<actualRemoveNode.length;m++){
//
//
//   int checkY=actualRemoveNode[m].y;
//   int checkX=actualRemoveNode[m].x;
//
//     if(checkY!=-1&&checkX!=-1){
//       for(int n=0;n<numberSurroundingNodes;n++)
//       {
//         if(n==4||n==5){
//           int inspectY=allBubble[checkY][checkX].surroundingCoordinate[n].y;
//           int inspectX=allBubble[checkY][checkX].surroundingCoordinate[n].x;
//          if(inspectY!=-1&&inspectX!=-1){
//
//            if(allBubble[inspectY][inspectX].bubbleColor!=BubbleColor0){
//             // BubblesCoordinate checkCorrdinates =BubblesCoordinate(y: allBubble[checkY][checkX].surroundingCoordinate[n].y, x: allBubble[checkY][checkX].surroundingCoordinate[n].x);
//              BubblesCoordinate checkCoordinate =assignCoordinates(allBubble[checkY][checkX].surroundingCoordinate[n].y, allBubble[checkY][checkX].surroundingCoordinate[n].x);
//
//            // List<int> corrdinate =[allBubble[checkY][checkX].surroundingCoordinate[n].y,allBubble[checkY][checkX].surroundingCoordinate[n].x];
//
//              if(inspectNodeList.contains(checkCoordinate)){
//                //print('true');
//                //print("${checkCoordinate.y},${checkCoordinate.x}");
//              }
//              else{
//                //print('false');
//                //print("${checkCoordinate.y}${checkCoordinate.x}");
//
//              }
//              double dy=checkCoordinate.y.toDouble();
//              double dx=checkCoordinate.x.toDouble();
//              inspectNodeList.add(Offset(dy,dx));
//
//            }
//          }
//         }
//         int inspectY=allBubble[checkY][checkX].surroundingCoordinate[n].y;
//         int inspectX =allBubble[checkY][checkX].surroundingCoordinate[n].x;
//         List<bool> anyTransparent=[];// to  check there is any surrounding node is transparent
//        if(inspectY!=-1&& inspectX!=-1){
//          for(int o=0;o<numberSurroundingNodes;o++){
//            int fallY = allBubble[inspectY][inspectX].surroundingCoordinate[o].y;
//            int fallX = allBubble[inspectY][inspectX].surroundingCoordinate[o].x;
//            if(fallY!=-1&& fallX!=-1){
//              if(allBubble[fallY][fallX].bubbleColor==BubbleColor0){
//                anyTransparent.add(true);// yes node color is  transparent
//              }else{
//                anyTransparent.add(false);//  node color is not transparent
//              }
//            }
//          }
//          if(anyTransparent.contains(false)){
//
//          }else{
//            if(allBubble[inspectY][inspectX].bubbleColor!=BubbleColor0){
//              BubblesCoordinate fall = assignCoordinates(inspectY , inspectX);
//              fallNode.add(fall);
//
//            }
//          }
//
//        }
//
//       }
//   }
//
//  // check if any row is empty
//   List<BubblesCoordinate> rowFallList = calculateRemoveRow(fallNode);
//   fallNode.addAll(rowFallList);
//
//   // remove lonely nodes
//   fallMethod(fallNode);
//
// }
//


// remove


// do{
//   for(int c=0;c<inspectNodeList.length;c++){
//
//     int inspectY=inspectNodeList.elementAt(c).dy.toInt();
//     int inspectX=inspectNodeList.elementAt(c).dx.toInt();
//
//     for(int d=0;d<4;d++){
//
//       int secondInspectY=allBubble[inspectY][inspectX].surroundingCoordinate[d].y;
//       int secondInspectX=allBubble[inspectY][inspectX].surroundingCoordinate[d].x;
//
//       if(secondInspectY!=-1&&secondInspectX!=-1){
//         if(allBubble[secondInspectY][secondInspectX].bubbleColor!=BubbleColor0){
//         print("${secondInspectY},${secondInspectX}");
//           BubblesCoordinate newCoordinate=assignCoordinates(secondInspectY,secondInspectX);
//           if(inspectNodeList.contains(newCoordinate)==false){
//             double dy=secondInspectY.toDouble();
//             double dx=secondInspectX.toDouble();
//             inspectNodeList.add(Offset(dy,dx));
//           // inspectNodeList.add(newCoordinate);
//           }
//
//         }
//       }
//     }
//     inspectNodeList.remove(inspectNodeList.elementAt(c));
//   }
//
// }
// while(inspectNodeList.length!=0);
// //print(inspectNodeList.length);