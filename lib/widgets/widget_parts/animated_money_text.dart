import 'package:flutter/material.dart';
import 'package:mangr/utils.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class AnimatedMoneyText extends StatefulWidget {

  final int value;
  final TextType textType;

  AnimatedMoneyText({Key key,@required this.value,this.textType}) : super(key: key);

  @override
  _AnimatedMoneyTextState createState() => _AnimatedMoneyTextState();
}

class _AnimatedMoneyTextState extends State<AnimatedMoneyText> {

  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
      duration: Duration(seconds: 2),
      tween: IntTween(begin: 0,end: widget.value),
      playback: Playback.PLAY_FORWARD,
      builder: (context, val) {
        return getText("$val\$",textType: widget.textType??TextType.textTypeNormal);
      },
    );
  }
}