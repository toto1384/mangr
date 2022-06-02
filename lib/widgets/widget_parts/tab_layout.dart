import 'package:flutter/material.dart';

import '../../utils.dart';


class TabLayout extends StatefulWidget {
  final List<String> entries;
  final Function(int) onSelectedPos;

  TabLayout({Key key,@required this.entries,this.onSelectedPos}) : super(key: key);

  @override
  _TabLayoutState createState() => _TabLayoutState();
}

class _TabLayoutState extends State<TabLayout> {

  int position=0;

  @override
  Widget build(BuildContext context) {
     return Row(
      children: List<FlatButton>.generate(widget.entries.length, (pos){
        return getButton(text: widget.entries[pos],variant: pos==position?1:2,onPressed: (){
          setState(() {
            position=pos;
            widget.onSelectedPos(pos); 
          });
        });
      }),
    );
  }
}