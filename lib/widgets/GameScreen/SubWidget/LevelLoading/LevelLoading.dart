
import 'package:bubble/Common/Commonvalue.dart';
import 'package:bubble/Service/BubbllrNotiffier.dart';
import 'package:bubble/main.dart';
import 'package:bubble/widgets/GameScreen/SubWidget/GameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
class LevelLoading extends StatefulHookWidget {
  BubbleNotifier bubbleNotifier;
  Size size;
  LevelLoading({required this.bubbleNotifier,required this.size});
  @override
  _LevelLoadingState createState() => _LevelLoadingState();
}

class _LevelLoadingState extends State<LevelLoading> with SingleTickerProviderStateMixin {
 late AnimationController animationController;
 late Animation loadingAnimation ;
bool animationOver =false;
  @override
  void initState() {
    // TODO: implement initState
    // widget.bubbleNotifier.assignColorToFiredBubbleColor();
    // widget.bubbleNotifier.init(widget.size);
    animationController =AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    loadingAnimation =Tween(begin: 0.0,end: 100).animate(animationController);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final bubbleData =useProvider(jBubbleProvider);
    final size =MediaQuery.of(context).size;
    BorderRadius  borderRadius= BorderRadius.circular(loadingBorderRadius);
    if(!bubbleData.isLevelLoaded){
      bubbleData.assignColorToFiredBubbleColor();
      bubbleData.init(widget.size);
      animationController.reset();
      animationController.forward().whenComplete(() {
        animationOver =true;
        setState(() {

        });
      });
    }
    return Scaffold(

      body: bubbleData.isLevelLoaded &&animationOver?GameScreen(): Container(
        child: Center(
          child: Stack(
            children: [
              Container(
                width: size.width*0.8,
                height: size.height*0.03,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Colors.white,
                ),

              ),
              Container(
                width: size.width*0.8,
                height: size.height*0.03,
                decoration: BoxDecoration(
                  color: scorerBoxColor,
                  border: Border.all(
                    //  color: Colors.black
                  ),
                  borderRadius: borderRadius,
                ),
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (context,va){
                  return  Container(
                    width: size.width*0.008*loadingAnimation.value,
                    height: size.height*0.03,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: LinearGradient(colors: [
                        progress1,
                        progress2,
                        progress3,
                      ]),
                      // borderRadius: BorderRadius.horizontal(right: Radius.circular( percentageAnimation.value>98.0?0: 20.0))
                    ),
                  );
                },
              )
            ],
          )
        ),
      ),
    );
  }
}
