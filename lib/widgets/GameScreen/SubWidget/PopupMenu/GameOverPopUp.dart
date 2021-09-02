import 'package:bubble/Common/commmonTitle.dart';
import 'package:bubble/Common/customTextStyle.dart';
import 'package:bubble/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameOverPopUp extends StatefulWidget {
  @override
  _GameOverPopUpState createState() => _GameOverPopUpState();
}

class _GameOverPopUpState extends State<GameOverPopUp> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bubbleData = context.read(jBubbleProvider);
    return Center(
      child: Container(
        height: size.width*0.55,
        width: size.width*0.55,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          border: Border.all(
            color: Colors.red,
            width: 5
          )
        ),


        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: size.height*0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                bubbleData.gameOverReasons.reason,
                style: regularStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width*0.05
                ),
              ),
              ElevatedButton(onPressed: ()async{
             await bubbleData.setLoadingAndInitializedFLag(false);
              }, child: Text(
                startAgain,
                style: regularStyle.copyWith(
                    fontSize: size.width*0.04
                ),
              )),
              ElevatedButton(onPressed: (){}, child: Text(
                exit_level,
                style: regularStyle.copyWith(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
