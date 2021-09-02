import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Service/BubbleService.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScorerBar extends StatefulHookWidget {
  const ScorerBar();
  @override
  _ScorerBarState createState() => _ScorerBarState();
}

class _ScorerBarState extends State<ScorerBar> with TickerProviderStateMixin{
  late AnimationController scorerController ;
  late AnimationController percentageController ;
  late AnimationController valueController ;
 late Animation scorerAnimation;
  late Animation percentageAnimation;
  late Animation valueAnimation;
 int scorer  =0;
 bool start=true;
 bool isPercentageOverHundred =false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scorerController= AnimationController(duration: Duration(seconds: 4),vsync: this);
    valueController= AnimationController(duration: Duration(milliseconds: 700),vsync: this);

    percentageController= AnimationController(duration: Duration(seconds: 4),vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  applyAnimation(BubbleNotifier provider ){

      percentageAnimation=Tween(begin: provider.oldScorerPercentage,end: provider.currentScorerPercentage).animate(CurvedAnimation(parent: percentageController, curve: Curves.ease))..addListener(() {

      });



    scorerAnimation=IntTween(begin: provider.oldScorer,end: provider.currentScorer).animate(CurvedAnimation(parent: scorerController, curve: Curves.ease))..addListener(() {

    });

      valueAnimation =IntTween(begin: provider.moves,end: provider.moves-1).animate(CurvedAnimation(parent: scorerController, curve: Curves.ease))..addListener(() {

      });
      if(provider.moves!=0){
        valueController.forward();
      }
    if(scorer!=provider.currentScorer){
      scorerController.reset();
      scorerController.forward();
      if(isPercentageOverHundred ==false){
        percentageController.reset();
        percentageController.forward();
       // print(provider.currentScorerPercentage);
      }
      if(provider.currentScorerPercentage==100.0){
        isPercentageOverHundred=true;
      }



      //  print('forward');
    }
    scorer =provider.currentScorer;
  }
  @override

  Widget build(BuildContext context) {
    final provider = useProvider(jBubbleProvider);
    applyAnimation(provider);
    final size =MediaQuery.of(context).size;
    BorderRadius  borderRadius= BorderRadius.circular(loadingBorderRadius);
    return Container(
      height: size.height*0.05,
      width: size.width,
      color: scorerBarColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
           
            AnimatedBuilder(
              animation: percentageController,
              builder: (context, snapshot) {
                return Material(
                  elevation: 10,
                  //color: scorerBoxColor,
          borderRadius: borderRadius,
                  child: Container(
                    height: size.height*0.03,
                    width: size.width*0.6,
                    decoration: BoxDecoration(
                        color: scorerBoxColor,
                      border: Border.all(
                      //  color: Colors.black
                      ),
                      borderRadius: borderRadius,
                    ),
                    child: Stack(
                      children: [

                        // Container(
                        //
                        //
                        //   decoration: BoxDecoration(
                        //     color: Colors.transparent,
                        //     borderRadius: borderRadius,
                        //   ),
                        // ),
                        percentageAnimation.value!=0? Container(
                         // constraints: BoxConstraints(minWidth: 0, maxWidth:  0),
                          height: size.height*0.03,
                          //width:   (size.width*0.006*percentageAnimation.value),

                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                             gradient: LinearGradient(colors: [
                               progress1,
                               progress2,
                               progress3,
                             ]),
                           // borderRadius: BorderRadius.horizontal(right: Radius.circular( percentageAnimation.value>98.0?0: 20.0))
                          ),
                        ):Container(),
                        Center(child: Text(
                            scorerAnimation.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: size.width*0.04,
                            color: scorerTextColor
                          ),

                        )),

                      ],
                    ),
                  ),
                );
              }
            ),

            AnimatedBuilder(
                animation: valueController,
                builder: (context,index){
              return Text(
                provider.moves.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width*0.05
                ),
              );
            })

          ],
        )
      ),
    );
  }
}
