import 'dart:async';
import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/Bubble.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BubbleService extends ChangeNotifier {
  List<Color> bubbleColors = [BubbleColor1, BubbleColor2, BubbleColor3];

  BubbleService(){
  setLevelTarget();
  }



  //bubble colors
  // List bubbleColors = [BubbleColor1, BubbleColor2, BubbleColor3, BubbleColor0];

  // for gameScreen
  int displayBubbleColumn = 10;

  //int currentTopColumn=10;

  // calculation
  List<List<Bubble>> allBubble = [];
  List<Color> firedBubbleColor = [];

  // moves
  int moves = 15;

  // level info
  int bubbleColorInLevel = 2;
  int bubbleColumns = 40;
  int numberSurroundingNodes = 6;
  int maximumNodeInOneRow = 11;
  int fakeTop = 0;

  // target node
  int targetY = -1;
  int targetX = -1;

// lazy loading
  int startAdding = 0;
  int endAdding = 40;

  //remove fall nodes
  Set<Offset> removeCoordinatedMain = Set();
  Set<Offset> fallingNodesMain = Set();
// level

  int currentLevel = 1;
  // score
  int oldScorer=0;
  int currentScorer=0 ;
  double currentScorerPercentage=0.0;
  double oldScorerPercentage=0.0;
  int fixScorer =10000;
  int levelTargetScorer=0;

  int fixNextTarget =1000;// add 1000 in fixTargetScorer
  int fixedIncreasement=10;

  // gameOver
  bool gameOver= false;

  setMoves(int val){
    this.moves =val;
    gameOver=false;
    notifyListeners();
  }

  setStartAndEnd(int start, int end) {
    this.startAdding = start;
    this.endAdding = end;
  }

  setTarget(int y, int x) {
    this.targetY = y;
    this.targetX = x;
    notifyListeners();
  }

  setFakeTop() {
    int number = bubbleColumns - 15;
    if (number <= 0) {
      fakeTop = 0;
    } else {
      fakeTop = number;
    }
    print('faketop${fakeTop}');
  }

  setDisplayBubbleColumn(int val) {
    displayBubbleColumn = val;
  }

  //int fixColumn =10; // remove after testing
  resetAllBubble() {
    allBubble.clear();
  }
setLevelTarget(){
  levelTargetScorer=  (fixScorer*currentLevel)+fixNextTarget;
  print('levelTargetScorer='+levelTargetScorer.toString());
  notifyListeners();
}

  // set newScorer
  setScorer(int _scorer){
    this.currentScorer=this.currentScorer+_scorer;
      if(currentScorerPercentage<=100.0){
        currentScorerPercentage=currentScorer/levelTargetScorer;
        currentScorerPercentage=currentScorerPercentage*100;
        if(currentScorerPercentage>100.0){
          currentScorerPercentage =100.0;
          print(currentScorerPercentage);
        }
      }
    notifyListeners();
  }

  setOldScorer(){
    this.oldScorer=currentScorer;
    this.oldScorerPercentage=currentScorerPercentage;
    notifyListeners();
  }



  setDefaultData() {
    allBubble = [];
   // for (int i = startAdding; i < endAdding; i++)
    for (int i = startAdding; i < bubbleColumns; i++) {
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

  List<Bubble> setSingleRow(int i) {
    List<Bubble> listOfBubbleColumn = [];
    Color bubbleColor = BubbleColor0;
    int numberofNodesInRow;
    if (i % 2 == 0) {
      numberofNodesInRow = 11;
    } else {
      numberofNodesInRow = 10;
    }
    for (int j = 0; j < numberofNodesInRow; j++) {
      bubbleColor = BubbleColor0;
      var rng = new Random();
      int rand = rng.nextInt(bubbleColorInLevel);
      bubbleColor = bubbleColors[rand];

      Bubble single = singleBubble(i, j, bubbleColor);
      listOfBubbleColumn.add(single);
    }
    return listOfBubbleColumn;
  }

  List<Bubble> emptyRow(int i) {
    List<Bubble> listOfBubbleColumn = [];
    Color bubbleColor = BubbleColor0;
    int numberofNodesInRow;
    if (i % 2 == 0) {
      numberofNodesInRow = 11;
    } else {
      numberofNodesInRow = 10;
    }
    for (int j = 0; j < numberofNodesInRow; j++) {
      Bubble single = singleBubble(i, j, bubbleColor);
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
  Bubble singleBubble(int i, int j, Color newColor) {
    int top = i - 1;
    int bottom = i + 1;
    int k = j;

    int left = k - 1;
    int right = k + 1;
    int topAndBottomRight = k + 1;

    if (i != 0) {
      top = i - 1;
    }
    if (k != 0) {
      left = k - 1;
    }
    if (i == bubbleColumns - 1) {
      bottom = -1;
    }
    if (i % 2 == 0) {
      if (k == 10) {
        right = -1;
        topAndBottomRight = -1;
      }
    } else {
      if (k == 9) {
        right = -1;
      }
    }

    if (bottom % 2 != 0) {
      if (k == 10) {
        right = -1;
        topAndBottomRight = -1;
        k = -1;
      }
    }
    if (top % 2 != 0) {
      if (k == 10) {
        right = -1;
        topAndBottomRight = -1;
        k = -1;
      }
    }
    Set<Offset> tops = Set();
    Set<Offset> bottoms = Set();
    if (i % 2 != 0) {
tops={
  Offset(k.toDouble(), top.toDouble()),
  Offset(topAndBottomRight.toDouble(), top.toDouble())
};
      // tops = [
      //   // BubblesCoordinate(y: top, x: k),
      //   // BubblesCoordinate(y: top, x: topAndBottomRight),
      //
      //
      // ];
      bottoms = {
        // BubblesCoordinate(y: bottom, x: k),
        // BubblesCoordinate(y: bottom, x: topAndBottomRight),
        Offset(k.toDouble(),bottom.toDouble()),
        Offset(topAndBottomRight.toDouble(),bottom.toDouble()),
      };
    } else {
      tops = {
        // BubblesCoordinate(y: top, x: left),
        // BubblesCoordinate(y: top, x: k),
        Offset(left.toDouble(),top.toDouble()),
        Offset(k.toDouble(),top.toDouble()),
      };
      bottoms = {
        // BubblesCoordinate(y: bottom, x: left),
        // BubblesCoordinate(y: bottom, x: k),
        Offset(left.toDouble(),bottom.toDouble()),
        Offset(k.toDouble(),bottom.toDouble()),
      };
    }
    //   List<List> coordinate =[[top,left],[top,j],[top,right],[i,left],[i,right],[bottom,left],[bottom,j],[bottom,right]];

    Set<Offset> surroundingCoordinate = {
      tops.elementAt(0),
      tops.elementAt(1),
      // BubblesCoordinate(y: i, x: left),
      // BubblesCoordinate(y: i, x: right),
      Offset(left.toDouble(),i.toDouble()),
      Offset(right.toDouble(),i.toDouble()),
      bottoms.elementAt(0),
      bottoms.elementAt(1),


    };

   // BubblesCoordinate bubbleCoordinate = BubblesCoordinate(y: i, x: j);
  Offset bubbleCoordinate=Offset(j.toDouble(), i.toDouble());
    Bubble _bu = Bubble(
        // bubbleColor: bubbleColor,
        bubbleColor: newColor,
        bubbleCoordinate: bubbleCoordinate,
        surroundingCoordinate: surroundingCoordinate,
        isVisible: true);

    return _bu;
  }

  assignColorToFiredBubbleColor() {
    firedBubbleColor = [];
    for (int i = 0; i < moves; i++) {
      var rng = new Random();
      int rand = rng.nextInt(bubbleColorInLevel);

      firedBubbleColor.add(bubbleColors[rand]);
    }
    // notifyListeners();
  }

  Future removeFiredColorFromQueue(int index) async{
    firedBubbleColor.removeAt(index);
    moves = moves - 1;
    if(moves==0){
      gameOver=true;
    }
    notifyListeners();
  }

   Future firedFunction() async {
    int y = this.targetY;
    int x = this.targetX;

    int newScore =0;
    int defaultScorerForSingleBubble =10;
    Color newBubble = firedBubbleColor[0];
    removeCoordinatedMain.clear();
    fallingNodesMain = Set();
    setOldScorer();



    if (y != -1 && x != -1) {
      assignNewValueToBubbleClass(
          y, x, newBubble, true); // set new Color to define node

      Set<Offset> removeNode = Set();
   //   List<BubblesCoordinate> actualRemoveNode = [];

      final Set<Offset> actualRemoveNode = Set();

      Bubble check = allBubble[y][x];
      for (int i = 0; i < numberSurroundingNodes; i++) {
        // find surrounding node of define node
        int checkY = check.surroundingCoordinate.elementAt(i).dy.toInt();
        int checkX = check.surroundingCoordinate.elementAt(i).dx.toInt();
        if (checkY != -1 && checkX != -1 && checkY >= fakeTop) {
          Bubble surroundCheck = allBubble[checkY][checkX];
          if (check.bubbleColor == surroundCheck.bubbleColor) {
            Offset remove = Offset( checkX.toDouble(),  checkY.toDouble());
            removeNode.add(remove);
            actualRemoveNode.add(remove);

          }
        }
      }
    Set<Offset> checkedNodesOffset =Set();
      // compare define node Color with Surrounding Nodes until nodes has different color
      do {
        for (int j = 0; j < removeNode.length; j++) {
          if(checkedNodesOffset.contains(removeNode.elementAt(j))==false){
            int removeY = removeNode.elementAt(j).dy.toInt();
            int removeX = removeNode.elementAt(j).dx.toInt();
            for (int k = 0; k < numberSurroundingNodes; k++) {
              int removeSurroundY =
              allBubble[removeY][removeX].surroundingCoordinate.elementAt(k).dy.toInt();
              int removeSurroundX =
              allBubble[removeY][removeX].surroundingCoordinate.elementAt(k).dx.toInt();
              if (removeSurroundY != -1 && removeSurroundX != -1 && removeSurroundY >= fakeTop) {
                if (allBubble[removeSurroundY][removeSurroundX].bubbleColor ==
                    check.bubbleColor) {
                  Offset newRemoveNodes =
                  Offset(removeSurroundX.toDouble(), removeSurroundY.toDouble());
                  removeNode.add(newRemoveNodes);

                }
              }
            }
            defaultScorerForSingleBubble=defaultScorerForSingleBubble + fixedIncreasement;
            newScore=newScore + defaultScorerForSingleBubble;
            assignNewValueToBubbleClass(removeY, removeX, Colors.orange, false);
            Timer(Duration(milliseconds: 100), () {

              assignNewValueToBubbleClass(removeY, removeX, Colors.transparent, true);

            });
          }
          // removeCoordinatedMain.add( removeNode[j]);
          checkedNodesOffset.add(removeNode.elementAt(j));
          removeNode.remove(removeNode.elementAt(j));
        }
      } while (removeNode.length != 0);
      if (removeNode.length != 0) {
        notifyListeners();
      }

      notifyListeners();
      calculateFalling();
      setScorer(newScore);
    }
    //Bubble newbubble = Bubble(bubbleColor: newBubble,bubbleCoordinate: allBubble[y][x].bubbleCoordinate,surroundingCoordinate:allBubble[y][x].surroundingCoordinate );
  }

  calculateFalling() {
    final Set<Offset> checkedNode = Set();
    final Set<Offset> mustCheckedList = Set();
    fallingNodesMain = Set();

    for (int j = 0; j < allBubble[fakeTop].length; j++) {
      if (bubbleColors.contains(allBubble[fakeTop][j].bubbleColor)) {
        int rowY = allBubble[fakeTop][j].bubbleCoordinate.dy.toInt();
        int rowX = allBubble[fakeTop][j].bubbleCoordinate.dx.toInt();
        Offset addCheckOffset = Offset(rowX.toDouble(), rowY.toDouble());
        checkedNode.add(addCheckOffset);
        for (int k = 0;
            k < allBubble[fakeTop][j].surroundingCoordinate.length;
            k++) {
          int surroundingY = allBubble[fakeTop][j].surroundingCoordinate.elementAt(k).dy.toInt();
          int surroundingX = allBubble[fakeTop][j].surroundingCoordinate.elementAt(k).dx.toInt();
          if (surroundingY != -1 &&
              surroundingX != -1 &&
              surroundingY >= fakeTop) {
            Offset addNode = Offset(
              surroundingX.toDouble(),
              surroundingY.toDouble(),
            );
            mustCheckedList.add(addNode);
          }
        }
      }
    }

    do {
      int mustLength = mustCheckedList.length;
      for (int i = 0; i < mustLength; i++) {
        if (checkedNode.contains(mustCheckedList.elementAt(0)) == false) {
          int mustY = mustCheckedList.elementAt(0).dy.toInt();
          int mustX = mustCheckedList.elementAt(0).dx.toInt();

          bool isTopRowBubble = mustY == 0 ? true : false;
          if (mustY != -1 && mustX != -1 && mustY >= fakeTop) {
            if (bubbleColors.contains(allBubble[mustY][mustX].bubbleColor)) {
              if (isTopRowBubble) {
                // then check node color if node's bubble color is  transparent then ignore the node
                for (int a = 2;
                    a < allBubble[mustY][mustX].surroundingCoordinate.length;
                    a++) {
                  int addY = allBubble[mustY][mustX].surroundingCoordinate.elementAt(a).dy.toInt();
                  int addX = allBubble[mustY][mustX].surroundingCoordinate.elementAt(a).dx.toInt();
                  Offset addOffest = Offset(addX.toDouble(), addY.toDouble());

                  mustCheckedList.add(addOffest);
                }
                // outside for
                checkedNode.add(mustCheckedList.elementAt(0));
              } else {
                List<bool> supportedAboveNodes =
                    []; // true // node has support from above nodes false //vice versa
                for (int b = 0; b < 2; b++) {
                  int aboveY =
                      allBubble[mustY][mustX].surroundingCoordinate.elementAt(b).dy.toInt();
                  int aboveX =
                      allBubble[mustY][mustX].surroundingCoordinate.elementAt(b).dx.toInt();
                  if (aboveY != -1 && aboveX != -1 && aboveY >= fakeTop) {
                    if (allBubble[aboveY][aboveX].bubbleColor == BubbleColor0) {
                      // means node is empty bubbleColor0 = transparent
                      supportedAboveNodes.add(false);
                    } else {
                      supportedAboveNodes.add(true);
                    }
                  }
                }

                // out b for loop
                if (supportedAboveNodes.contains(true)) {
                  for (int a = 0;
                      a < allBubble[mustY][mustX].surroundingCoordinate.length;
                      a++) {
                    int addY =
                        allBubble[mustY][mustX].surroundingCoordinate.elementAt(a).dy.toInt();
                    int addX =
                        allBubble[mustY][mustX].surroundingCoordinate.elementAt(a).dx.toInt();
                    Offset addOffest = Offset(addX.toDouble(), addY.toDouble());
                    if (checkedNode.contains(addOffest) == false) {
                      mustCheckedList.add(addOffest);
                    }
                  }
                  checkedNode.add(mustCheckedList.elementAt(0));
                }
              }
            }
          }
        } else {
          // nothing
        }

        mustCheckedList.remove(mustCheckedList.elementAt(0));
        mustLength = mustCheckedList.length;
      }
    } while (mustCheckedList.length != 0);

    bool checkingContinue = true;
    int checkNodeLength = checkedNode.length;

    do {
      bool valueChanged = false;

      for (int i = 0; i < allBubble.length; i++) {
        for (int j = 0; j < allBubble[i].length; j++) {
          if (bubbleColors.contains(allBubble[i][j].bubbleColor)) {
            int offsetY = allBubble[i][j].bubbleCoordinate.dy.toInt();
            int offsetX = allBubble[i][j].bubbleCoordinate.dx.toInt();
            Offset guessOffset = Offset(offsetX.toDouble(), offsetY.toDouble());

            if (checkedNode.contains(guessOffset) == false) {
              for (int q = 0;
                  q < allBubble[offsetY][offsetX].surroundingCoordinate.length;
                  q++) {
                int surroundingY =
                    allBubble[offsetY][offsetX].surroundingCoordinate.elementAt(q).dy.toInt();
                int surroundingX =
                    allBubble[offsetY][offsetX].surroundingCoordinate.elementAt(q).dx.toInt();
                Offset surrondingOffset =
                    Offset(surroundingX.toDouble(), surroundingY.toDouble());
                if (checkedNode.contains(surrondingOffset)) {
                  valueChanged = true;
                  checkedNode.add(guessOffset);
                  //   print( "chhedd="+ surrondingOffset.toString());

                }
              }
            }
          }
        }
      }

      if (valueChanged == true) {
        checkingContinue = true;
      } else {
        checkingContinue = false;
      }
    } while (checkingContinue != false);
// check is node check or not
    for (int i = 0; i < allBubble.length; i++) {
      for (int j = 0; j < allBubble[i].length; j++) {
        if (bubbleColors.contains(allBubble[i][j].bubbleColor)) {
          int offsetY = allBubble[i][j].bubbleCoordinate.dy.toInt();
          int offsetX = allBubble[i][j].bubbleCoordinate.dx.toInt();
          Offset guessOffset = Offset(offsetX.toDouble(), offsetY.toDouble());

          if (checkedNode.contains(guessOffset) == false) {
            allBubble[i][j].bubbleColor = Colors.white;
            //fallingNodesMain.add(guessOffset);
          }
        }
      }
    }

    setTarget(-1, -1);

     // fallAndRemoveMethod();
    //function over
  }

  fallAndRemoveMethod() async {
    bool fallingFinish = false;

    //falling
    for (int i = 0; i < fallingNodesMain.length; i++) {
      int y = fallingNodesMain.elementAt(i).dy.toInt();
      int x = fallingNodesMain.elementAt(i).dx.toInt();
      // change
      updateBubbleColor(
        y,
        x,
        Colors.transparent,
      );
      if (i == fallingNodesMain.length -1) {
        fallingFinish = true;
      }
    }
    // if(fallingFinish==true){
 //   removeRow();
    // }

    notifyListeners();
  }

  Bubble assignNewValueToBubbleClass(
      int y, int x, Color newColor, bool visible) {
    Bubble newbubble = Bubble(
        bubbleColor: newColor,
        bubbleCoordinate: allBubble[y][x].bubbleCoordinate,
        surroundingCoordinate: allBubble[y][x].surroundingCoordinate,
        isVisible: visible);
    allBubble[y][x] = newbubble;
    return newbubble;
  }

  Future updateBubbleColor(int y, int x, Color newColor) async {
    allBubble[y][x].bubbleColor = newColor;
  }

  Offset assignCoordinates(int y, int x) {
    Offset value = Offset(x.toDouble(), y.toDouble());
    return value;
  }

  removeRow()async{
    int _st = allBubble.length - 1;
    int _en = allBubble.length - displayBubbleColumn;
    int numberOfEmptyRow = 0;

    for (int i = _st; i > _en; i--) {
      List<bool> addBool = [];
      for (int j = 0; j < allBubble[i].length; j++) {
        if (bubbleColors.contains(allBubble[i][j].bubbleColor)) {
          addBool.add(false);
        } else {
          addBool.add(true);
        }
      }

      if (addBool.contains(false)) {
      } else {
        numberOfEmptyRow = numberOfEmptyRow + 1;

        if (numberOfEmptyRow > 1) {

          allBubble.removeAt(i);
          _st = allBubble.length - 1;
          _en = allBubble.length - displayBubbleColumn;
          bubbleColumns = allBubble.length;

          setFakeTop();


        }

        //  displayBubbleColumn=displayBubbleColumn-1;

      }
    }

    setFakeTop();
  }
}
