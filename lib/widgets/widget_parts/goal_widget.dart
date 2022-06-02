import 'package:flutter/material.dart';
import 'package:mangr/icon_pack_icons.dart';
import 'package:mangr/objects/goal.dart';

import '../../utils.dart';


class GoalWidget extends StatelessWidget {
  final Function() onTap;
  final Goal goal;
  final PopupMenuButton popupMenuButton;

  const GoalWidget({Key key,@required this.goal,this.popupMenuButton,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: MyColors.color_primary_light,borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Icon(IconPack.goal,size: 25,color: Colors.white,),
        ),
      ),
      onTap: onTap,
      title: getText(goal.name),
      subtitle: getText(
        goal.description,
        textType: TextType.textTypeSubNormal
      ),
      
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getText(
            getDateFormat().format(goal.dueDate),
            textType: TextType.textTypeSubNormal,
            color: MyColors.color_primary_light
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: popupMenuButton,
          )
        ],
      )
      
    );
  }
}