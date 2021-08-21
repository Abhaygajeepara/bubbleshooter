

import 'dart:async';
import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final jBubbleProvider = ChangeNotifierProvider<BubbleNotifier>((_ref)=>BubbleNotifier());
class BubbleNotifier extends ChangeNotifier{
//temporary Variable
Color temporaryFalingColor =Colors.white;


  ///level
  int currentLevel =1;
  int maxRaw = 5;
  List<List<BubbleModel>> bubbles = [];
  bool isInitialized = false;
  List<Color> bubbleColors = [BubbleColor1, BubbleColor2, BubbleColor3];
 int bubbleColorInLevel=2;
  // fire

  List<Color> firedBubbleColor = [];
  int fakeTop = 0;

  int targetY = -1;
  int targetX = -1;
  //remove fall nodes
  Set<Offset> removeCoordinatedMain = Set();
  Set<Offset> fallingNodesMain = Set();
//moves
  int moves = 10;
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
  BubbleNotifier(){
    setLevelTarget(){
      levelTargetScorer=  (fixScorer*currentLevel)+fixNextTarget;
   //   print('levelTargetScorer='+levelTargetScorer.toString());
      notifyListeners();
    }
  }
  //BubbleNotifier();
  void init(Size size){
    if(!isInitialized){
      bubbles.clear();
      for(int i =0;i<maxRaw;i++){
        int a = i % 2 == 0 ? 11 : 10;
        List<BubbleModel> raw = [];
        for(int j =0;j<a;j++){
          Color bubbleColor = BubbleColor0;
          var rng = new Random();
          int random = rng.nextInt(bubbleColorInLevel);
          bubbleColor = bubbleColors[random];
          raw.add(BubbleModel(size: size, i: i, j: j, bubbleColor: bubbleColor, isVisible: true,maxRaw: maxRaw,isRender: false));
        }
        bubbles.add(raw);
      }
      // notifyListeners();
    }
  }
  Future removeFiredColorFromQueue(int index) async{
    firedBubbleColor.removeAt(index);
    moves = moves - 1;
    if(moves==0){
      gameOver=true;
    }
    notifyListeners();
  }
  setTarget(int y, int x) {
    this.targetY = y;
    this.targetX = x;
    notifyListeners();
  }
  setScorer(int _scorer){
    this.currentScorer=this.currentScorer+_scorer;
    if(currentScorerPercentage<=100.0){
      currentScorerPercentage=currentScorer/levelTargetScorer;
      currentScorerPercentage=currentScorerPercentage*100;
      if(currentScorerPercentage>100.0){
        currentScorerPercentage =100.0;
       // print(currentScorerPercentage);
      }
    }
    notifyListeners();
  }

  setOldScorer(){
    this.oldScorer=currentScorer;
    this.oldScorerPercentage=currentScorerPercentage;
    notifyListeners();
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
  Future firedFunction() async {

      int y = targetY;
      int x = targetX;

      int newScore =0;
      int defaultScorerForSingleBubble =10;
      Color newBubbleColor = firedBubbleColor[0];
      removeCoordinatedMain.clear();
      fallingNodesMain = Set();
      setOldScorer();



      if (y>=fakeTop) {
        assignNewValueToBubbleClass(
            y, x, newBubbleColor, true); // set new Color to define node
        Set<Offset> removedOffsetList =Set();
        Set<Offset> alreadyCheckedRemoved =Set();
        removedOffsetList.clear();
        removedOffsetList.add(Offset(x.toDouble(),y.toDouble()));
        alreadyCheckedRemoved.add(Offset(x.toDouble(),y.toDouble()));

        for(Offset a in bubbles[y][x].surroundingCoordinate ){
          int newY =a.dy.toInt();
          int newX =a.dx.toInt();
          if(a.dy>=fakeTop  && bubbles[newY][newX].bubbleColor==newBubbleColor){
            removedOffsetList.add(a);

          }
        }

        do {
          for (int b = 0; b < removedOffsetList.length; b++) {
            int Y1 = removedOffsetList.elementAt(b).dy.toInt();
            int X1 = removedOffsetList.elementAt(b).dx.toInt();
            Offset currrentOffset = bubbles[Y1][X1].bubbleCoordinate;
            if(alreadyCheckedRemoved.contains(currrentOffset) == false  &&Y1 >= fakeTop){


              for (int c = 0; c < bubbles[Y1][X1].surroundingCoordinate.length;c++) {
                Offset addNew =
                bubbles[Y1][X1].surroundingCoordinate.elementAt(c);
                int checkY1 = addNew.dy.toInt();
                int checkX1 = addNew.dx.toInt();
                if (bubbles[checkY1][checkX1].bubbleColor == newBubbleColor && checkY1>=fakeTop) {
                  removedOffsetList.add(addNew);
                }

              }
              defaultScorerForSingleBubble = defaultScorerForSingleBubble + fixedIncreasement;
              newScore = newScore + defaultScorerForSingleBubble;
            }
            alreadyCheckedRemoved.add(removedOffsetList.elementAt(b));
            assignNewValueToBubbleClass(Y1, X1, Colors.transparent, false);

            // Timer(Duration(milliseconds: 100), () {
            //   assignNewValueToBubbleClass(Y1, X1, Colors.transparent, true);
            // });
            removedOffsetList.remove(removedOffsetList.elementAt(b));
          }
        } while (removedOffsetList.length != 0);


        if(removedOffsetList.length==0){
          calculateFalling();
        }

       setScorer(newScore);
        notifyListeners();

      }

  }

  calculateFalling() {
    final Set<Offset> checkedNode = Set();
    final Set<Offset> mustCheckedList = Set();
    fallingNodesMain = Set();

    for (int j = 0; j < bubbles[fakeTop].length; j++) {
      if (bubbleColors.contains(bubbles[fakeTop][j].bubbleColor)) {
        int rowY = bubbles[fakeTop][j].i.toInt();
        int rowX = bubbles[fakeTop][j].j.toInt();
        Offset addCheckOffset =bubbles[rowY][rowX].bubbleCoordinate;
        checkedNode.add(addCheckOffset);

 for (Offset k in bubbles[fakeTop][j].surroundingCoordinate) {
          int surroundingY = k.dy.toInt();
          int surroundingX = k.dx.toInt();
       //   print(surroundingY);
          if (surroundingY >= fakeTop &&checkedNode.contains(k)==false) {
            //Offset(surroundingX.toDouble(), surroundingY.toDouble()

mustCheckedList.add(k);
          }
        }
      }
    }





    do {
      int mustLength = mustCheckedList.length;
      for (int i = 0; i < mustLength; i++) {
     //   print(checkedNode.contains(mustCheckedList.elementAt(0)) );
        int _y1=mustCheckedList.elementAt(0).dy.toInt();
        if (checkedNode.contains(mustCheckedList.elementAt(0)) == false && _y1>= fakeTop) {

          int mustY = mustCheckedList.elementAt(0).dy.toInt();
          int mustX = mustCheckedList.elementAt(0).dx.toInt();



            if ( mustY >= fakeTop&& bubbleColors.contains(bubbles[mustY][mustX].bubbleColor)) {

                List<bool> supportedAboveNodes =
                []; // true // node has support from above nodes false //vice versa
                for (int b = 0; b <bubbles[mustY][mustX].surroundingCoordinate.length ; b++) {
                  int aboveY =
                  bubbles[mustY][mustX].surroundingCoordinate.elementAt(b).dy.toInt();
                  int aboveX =
                  bubbles[mustY][mustX].surroundingCoordinate.elementAt(b).dx.toInt();
                  if ( aboveY >= fakeTop) {
                    if (bubbles[aboveY][aboveX].bubbleColor == BubbleColor0) {
                      // means node is empty bubbleColor0 = transparent
                      supportedAboveNodes.add(false);
                    } else {
                      supportedAboveNodes.add(true);
                    }
                  }
                }

                // out b for loop
                if (supportedAboveNodes.contains(true)) {
                  for (int a = 0; a < bubbles[mustY][mustX].surroundingCoordinate.length; a++) {
                    int addY =
                    bubbles[mustY][mustX].surroundingCoordinate.elementAt(a).dy.toInt();
                    int addX =
                    bubbles[mustY][mustX].surroundingCoordinate.elementAt(a).dx.toInt();
                    Offset addOffest = Offset(addX.toDouble(), addY.toDouble());
                    if (checkedNode.contains(addOffest) == false) {
                      mustCheckedList.add(addOffest);
                    }
                  }
                  checkedNode.add(mustCheckedList.elementAt(0));
               }
             // }
            }

        }



        mustCheckedList.remove(mustCheckedList.elementAt(0));
        mustLength = mustCheckedList.length;
      }
    } while (mustCheckedList.length != 0);


// check is node check or not
    for (int a = fakeTop; a < bubbles.length; a++) {
      for (int b = 0; b < bubbles[a].length; b++) {
        Color currentColor =bubbles[a][b].bubbleColor;
        if (bubbleColors.contains(currentColor)) {
          int offsetY = bubbles[a][b].i.toInt();
          int offsetX = bubbles[a][b].j.toInt();
          Offset guessOffset = Offset(offsetX.toDouble(), offsetY.toDouble());

          if (checkedNode.contains(guessOffset) == false) {
            bubbles[a][b].bubbleColor = temporaryFalingColor;
            bubbles[a][b].isRender = true;

            //fallingNodesMain.add(guessOffset);
          }
        }
      }
    }

   // setTarget(-1, -1);
   removeEmptyRow();
    // fallAndRemoveMethod();
    //function over
  }

  removeEmptyRow()async{
    List<List<BubbleModel>> removeRow =[];
    for(int a=fakeTop;a<bubbles.length;a++){
      List<bool> isBubbleEmpty =[];
      for(int n=0;n<bubbles[a].length;n++){
        BubbleModel b = bubbles[a][n];
        if(bubbleColors.contains(b.bubbleColor) && b.bubbleColor!=temporaryFalingColor){
          isBubbleEmpty.add(false);
        }else{
          isBubbleEmpty.add(true);
        }
      }
      if(!isBubbleEmpty.contains(false)){
        if(fakeTop>1){
          fakeTop =fakeTop-1;
          min(fakeTop, 0);

        }else{
          fakeTop=0;
        }
        removeRow.add(bubbles[a]);
      }
    }
 //   print(fakeTop);
    if(removeRow.length>0){
      removeRow.remove(removeRow.first);
      bubbles.removeWhere( (e) => removeRow.contains(e));
      notifyListeners();
    }


  }
   assignNewValueToBubbleClass(int y, int x, Color newColor, bool visible)
   {
     bubbles[y][x].bubbleColor =newColor;
     bubbles[y][x].isVisible =visible;
     notifyListeners();
  }


}

