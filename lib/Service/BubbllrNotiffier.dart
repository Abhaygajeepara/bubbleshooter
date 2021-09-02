

import 'dart:async';
import 'dart:math';

import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Model/BubbleModel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class BubbleNotifier extends ChangeNotifier{
//temporary Variable
Color temporaryFalingColor =Colors.white;


  ///level
  int currentLevel =1;
  int maxRaw = 25;
  List<List<BubbleModel>> bubbles = [];
  bool isInitialized = false;
  List<Color> bubbleColors = [BubbleColor1, BubbleColor2, BubbleColor3];
 int bubbleColorInLevel=3;
  // fire

  List<Color> fireBubble = [];
  int fakeTop = 20;

  int targetY = -1;
  int targetX = -1;
  //remove fall nodes
//  Set<Offset> removeCoordinatedMain = Set();
Set<Offset> mainRemoveNodes = Set();
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
  Set<Offset> mainFallingNode =Set();
  bool isDisappearAnimation =false;
  bool isFallingAnimation =false;

  // gameOver
  bool isGameOver= false;
  bool isFinish =true;
  BubbleNotifier(){
    setLevelTarget(){
      levelTargetScorer=  (fixScorer*currentLevel)+fixNextTarget;
   //   print('levelTargetScorer='+levelTargetScorer.toString());
    //  notifyListeners();
    }
  }

  turnOffAnimation()async{
    this.isDisappearAnimation =false;
    this.isFallingAnimation =false;
   await removeEmptyRow();
    notifyListeners();
  }
  //BubbleNotifier();
  void init(Size size)async{
    if(!isInitialized){
      bubbles.clear();
      for(int i =0;i<maxRaw;i++){
        int a = i % 2 == 0 ? 11 : 10;
        List<BubbleModel> raw = [];
        for(int j =0;j<a;j++){
          Color bubbleColor = BubbleColor0;
          var rng = new Random(i*j*currentLevel);

          int random = rng.nextInt(bubbleColorInLevel);

          bubbleColor = bubbleColors[random];
          raw.add(BubbleModel(size: size, i: i, j: j, bubbleColor: bubbleColor, isVisible: true,maxRaw: maxRaw));
        }
        bubbles.add(raw);
      }

    }
    // else{
    //   screenBubble(size);
    // }
   await screenBubble(size,0.0,0.0);
  }
  Future removeFiredColorFromQueue() async{
//   print(fireBubble);
// print(fireBubble.length);

   if(fireBubble.length>0){
     fireBubble.remove(fireBubble.first);
     moves = moves - 1;
     if(moves==0){
       isGameOver=true;
       isFinish =true;
     }
   }

  }
  Future swapFireBubble()async{
    if(fireBubble.length>=2){

      Color first =fireBubble.removeAt(0);

      fireBubble.removeAt(0);

      fireBubble.insert(1,first);

      notifyListeners();
    }
  }
  setTarget(int y, int x) {
    this.targetY = y;
    this.targetX = x;
     notifyListeners();
  }
  setScorer(int _scorer){

    this.currentScorer=this.currentScorer+_scorer;
    if(currentScorerPercentage<=100.0){
      currentScorerPercentage=currentScorer.toDouble();

      currentScorerPercentage=currentScorerPercentage*100;

      if(currentScorerPercentage ==double.nan){
        currentScorerPercentage =0.0;
      }

      if(currentScorerPercentage>100.0){
        currentScorerPercentage =100.0;
       // print(currentScorerPercentage);
      }
    }

  }

  setOldScorer(){
    this.oldScorer=currentScorer;
    this.oldScorerPercentage=currentScorerPercentage;

  }
  assignColorToFiredBubbleColor() {
    fireBubble = [Colors.white60];
    for (int i = 0; i < moves; i++) {
      var rng = new Random();
      int rand = rng.nextInt(bubbleColorInLevel);

      fireBubble.add(bubbleColors[rand]);
    }

  }
  gameOver(){
    isGameOver=!isGameOver;
    print('game Over');
    notifyListeners();

  }

  Future screenBubble(Size size,double opacityAnimation,double fallingAnimation)async{
   // print(fallingAnimation);
    int iteration =0;
    for(int i=fakeTop;i<bubbles.length;i++){
      for(int k=0;k<bubbles[i].length;k++){
        BubbleModel j =bubbles[i][k];
        if(j.bubbleColor!= BubbleColor0){
          double ballWidth = (size.width - totalPaddingInRow) / numberOfBubbleInRow;
          double initialTop = size.width/21;
          final paint =Paint();
          late double top;
          Color _bubbleColor =j.bubbleColor;
          Color shadow =Colors.black;
          top = initialTop  + (ballWidth -2) * iteration;

          if(mainFallingNode.contains(j.bubbleCoordinate)==false){
            if(mainRemoveNodes.contains(j.bubbleCoordinate)){
              _bubbleColor =j.bubbleColor.withOpacity(opacityAnimation);
              shadow=shadow.withOpacity(opacityAnimation);
            }
               top = initialTop  + (ballWidth -2) * iteration;

          }else{
            double newTop = iteration+fallingAnimation*2;
            double localOpacity =1.0;
            if(newTop>16){
              newTop=16;
              localOpacity =0.0;
            }
            _bubbleColor =_bubbleColor.withOpacity(localOpacity);
               top = initialTop  + (ballWidth -2) * newTop;
             //  top = initialTop  + (ballWidth -2) * iteration;

          }
          j.top =top;

          j.bubbleColor =_bubbleColor;
        }

      }
      if(iteration<17){
        iteration=iteration+1;
        if(iteration>=15){
          if(  isGameOver==false){
            gameOver();
          }

        }
      }



    }
   // notifyListeners();
  }
  Future clearRemoveNode()async{
    mainRemoveNodes.map((e)async {
      int y = e.dy.toInt();
      int x =e.dx.toInt();
      bubbles[y][x].bubbleColor=BubbleColor0;
      notifyListeners();
    }).toList();
    mainRemoveNodes.clear();
    if(isDisappearAnimation){
      isFallingAnimation =true; //if there more than 3 bubble with color then set isFallingAnimation =true
    }
    isDisappearAnimation =false;

   await calculateFalling();


    //notifyListeners();
  }
  setNewFake(){
    if(fakeTop>1){
      fakeTop =fakeTop-1;
      min(fakeTop, 0);

    }else{
      fakeTop=0;
    }
    clearFalling();
    notifyListeners();
  }
  Future clearFalling()async{
    mainFallingNode.map((e) {
      int y = e.dy.toInt();
      int x =e.dx.toInt();
      bubbles[y][x].bubbleColor=BubbleColor0;

    }).toList();
    mainFallingNode.clear();
    notifyListeners();

    //notifyListeners();
  }
  Future fireFunction() async {

    clearFalling();
     clearRemoveNode();

      if(isGameOver==false){

        int y = 22;
        int x = 8;

        int newScore =0;
        int defaultScorerForSingleBubble =10;
        Color newBubbleColor = fireBubble[0];



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
              mainRemoveNodes.add(bubbles[Y1][X1].bubbleCoordinate);

             // assignNewValueToBubbleClass(Y1, X1, BubbleColor0, false);

              // Timer(Duration(milliseconds: 100), () {
              //   assignNewValueToBubbleClass(Y1, X1, BubbleColor0, true);
              // });
              removedOffsetList.remove(removedOffsetList.elementAt(b));
            }

          } while (removedOffsetList.length != 0);
          isDisappearAnimation =true;

          if(mainRemoveNodes.length<3){


            mainRemoveNodes.clear();
            isDisappearAnimation =false;
          }else{
            isDisappearAnimation =true;
          }
          print('after${isDisappearAnimation}');

          setScorer(newScore);
        }
      }

    removeFiredColorFromQueue();
      notifyListeners();
  }

  Future calculateFalling() async{
    print('calcuate fal');
    mainFallingNode.clear();
    final Set<Offset> checkedNode = Set();
    final Set<Offset> mustCheckedList = Set();


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
            mainFallingNode.add(guessOffset);
            //fallingNodesMain.add(guessOffset);
          }
        }
      }
    }
    //notFallingNode =checkedNode;

   // setTarget(-1, -1);
   //removeEmptyRow();

    notifyListeners();
    // fallAndRemoveMethod();
    //function over
  }

  Future removeEmptyRow()async{
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

        removeRow.add(bubbles[a]);
      }
    }
 //   print(fakeTop);
    if(removeRow.length>0){
      removeRow.remove(removeRow.first);
      bubbles.removeWhere( (e) => removeRow.contains(e));

    }

   // notifyListeners();

  }
   assignNewValueToBubbleClass(int y, int x, Color newColor, bool visible)
   {
     bubbles[y][x].bubbleColor =newColor;
     bubbles[y][x].isVisible =visible;
     notifyListeners();
  }


}

