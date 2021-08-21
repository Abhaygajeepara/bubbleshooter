import 'dart:async';

import 'package:bubble/widgets/GameScreen/SubWidget/GameScreen.dart';
import 'package:bubble/widgets/Home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  bool isSplash = true;
  late AnimationController _animationController;
  late Animation _animation;
  late AnimationController _animationController2;
  late Animation _animation2;
  late AnimationController _animationController3;
  late Animation _animation3;
  // late AnimationController rotateController;
  // late Animation rotateAnimation;
  bool isVertical = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
     isSplash=false;
      });

    });
    super.initState();
  }
animationFunction (){
  _animationController = AnimationController(
      duration: Duration(seconds: 3), vsync: this);
  _animation = Tween(begin: 1.0, end: -0.01).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease))
    ..addListener(() {
      if (_animation.isCompleted) {
        _animationController.reverse();
        _animationController2.forward();
      }
      setState(() {});
    });

  _animationController2 =
      AnimationController(duration: Duration(seconds: 1), vsync: this);
  _animation2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController2, curve: Curves.ease))
    ..addListener(() {
      if (_animation2.isCompleted) {
        isVertical = true;

        _animationController3.forward();
      }
      setState(() {

      });
    });
  // rotateController =
  //     AnimationController(duration: Duration(milliseconds: 500), vsync: this);
  // rotateAnimation = Tween(begin: 0.0, end: 1.55).animate(
  //     CurvedAnimation(parent: rotateController, curve: Curves.ease))
  //   ..addListener(() {
  //     setState(() {
  //
  //     });
  //   });
  _animationController3 =
      AnimationController(duration: Duration(seconds: 2), vsync: this);
  _animation3 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController3, curve: Curves.ease))
    ..addListener(() {
      setState(() {

      });
    });


  _animationController.forward();
}
  @override
  Widget build(BuildContext context) {
    return !isSplash? GameScreen():Scaffold(

     // body: Center(child: bottomShotter()),
      body:Center(
        child: Image.asset('assets/BubbleShotter.png'),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _animationController.reset();
      //       _animationController.forward();
      //     });
      //   },
      // ),
    );
  }

  Widget bottomShotter() {
    final size = MediaQuery
        .of(context)
        .size;
    // double x =isVertical?0.0:_animation.value*size.width;
    //  double y =isVertical?_animation.value*size.height:0.0;
    double x = _animation.value * size.width;
    double y = _animation.value * size.height;

    double y2 = isVertical ? _animation3.value * size.height : 0.3;
    final bubbleWidth = size.width * 0.3;
    final bubbleHeight = size.height * 0.1;
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(


              child: Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Bubble',
                    style: TextStyle(
                      fontSize: size.height*0.08,
                      fontWeight: FontWeight.w600
                    ),

                  ),
                  Text('Shooter',
                    style: TextStyle(
                        fontSize: size.height*0.06,
                        fontWeight: FontWeight.w600
                    ),)
                ],
              )),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform(
                  transform: Matrix4.translationValues(
                        -_animation2.value, y2, 0.0),
                  child: customContainer(true),
                ),
                Transform(
                  transform: Matrix4.translationValues(
                        _animation2.value, y2, 0.0),
                  child: customContainer(false),
                ),


              ],
            )
          ],
        ),
        Transform(
          transform: Matrix4.translationValues(
              0.0, size.height * _animation.value, 0.0),
          child: Container(


            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Widget customContainer(bool isleft) {
    final size = MediaQuery
        .of(context)
        .size;

    BorderRadius borderRadius = isleft ? BorderRadius.only(topLeft: Radius.circular(size.height * 0.1), bottomLeft: Radius.circular(size.height * 0.1)) :
                                          BorderRadius.only(topRight: Radius.circular(size.height * 0.1),bottomRight: Radius.circular(size.height * 0.1));
    return Container(
      height: size.height * 0.18,
      width: size.width * 0.4,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: borderRadius
      ),
    );
  }

  Widget bubble(Color color, double height, double width) {
    final size = MediaQuery
        .of(context)
        .size;
    final fontSize = size.height * 0.1;
    return Container(
      height: height,
      width: width,

      decoration: BoxDecoration(
        color: color,

        //shape: BoxShape.circle
      ),
      // child: Text('Bubble',
      //   style: TextStyle(
      //       color:Colors.red,
      //       fontWeight: FontWeight.bold,
      //       fontSize: fontSize
      //
      //
      //   ),
      // ),
    );
  }


}