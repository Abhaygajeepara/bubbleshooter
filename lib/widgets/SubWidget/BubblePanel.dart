import 'package:bubble/main.dart';
import 'package:bubble/widgets/SubWidget/SingleBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class BubblePanel extends StatefulWidget {
  @override
  _BubblePanelState createState() => _BubblePanelState();
}

class _BubblePanelState extends State<BubblePanel> {

  @override
  Widget build(BuildContext context) {
    final bubbleData= context.read(buubleProvider);
    final size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: bubbleData.allBubble.length,
        itemBuilder: (context, index) {
          double rowPadding =0;
          if(index%2!=00){
            rowPadding=(size.width / 11)/2;
          }else{
            rowPadding =0;
          }
          return Container(
            height: size.height * 0.9 /21,

            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:rowPadding ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bubbleData.allBubble[index].length,
                  itemBuilder: (context, subIndex) {

                    return SingleBubble(
                        buubleColor: bubbleData.allBubble[index][subIndex].bubbleColor,y: index,x: subIndex,);
                  }),
            ),
          );
        });
  }
}
