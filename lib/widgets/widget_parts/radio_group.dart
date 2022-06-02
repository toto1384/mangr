import 'package:flutter/material.dart';
import 'package:mangr/main.dart';
import 'package:mangr/utils.dart';



class MyRadioGroup extends StatefulWidget {

  final bool isMultipleSelect;
  final List<RadioItem> items;
  final Function(int,bool,List<RadioItem>) onItemSelected;

  MyRadioGroup({Key key,@required this.isMultipleSelect,@required this.items,@required this.onItemSelected}) : super(key: key);

  @override
  _MyRadioGroupState createState() => _MyRadioGroupState();
}

class _MyRadioGroupState extends State<MyRadioGroup> {

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: List.generate(widget.items.length, (index){
           return Visibility(
             visible: !(widget.items[index].toString()!=null&&widget.items[index].isSelected),
             child: InkWell(
                onTap: (){
                  setState(() {
                    List<RadioItem> listToReturn = widget.items;
                    if(!widget.isMultipleSelect){
                      for(int i =0;i<listToReturn.length;i++){
                        listToReturn[i].isSelected=false;
                      }
                    }
                    if(listToReturn[index].subItems!=null){
                      if(listToReturn[index].isSelected){
                        listToReturn[index].subItems.forEach((subItem){
                          listToReturn.remove(subItem);
                        });
                      }else{
                        listToReturn.addAll(listToReturn[index].subItems);
                      }
                    }
                    listToReturn[index].isSelected= widget.isMultipleSelect?!listToReturn[index].isSelected:true;
                    widget.onItemSelected(index,listToReturn[index].isSelected,listToReturn); 
                    });
                },
                child: Card(
                  shape: getShape(),
                  color: widget.items[index].isSelected?MyApp.isDarkMode?MyColors.color_secondary:MyColors.color_primary_light:Colors.transparent,
                  child: getText(widget.items[index].name,color: widget.items[index].isSelected?MyApp.isDarkMode?MyColors.color_black:Colors.white:Colors.transparent),
                ),
             ),
           );
         }),
       ),
    );
  }
}



class RadioItem{

  String name;
  bool isSelected;
  List<RadioItem> subItems;

  RadioItem({@required this.name,this.isSelected,this.subItems}){
    if(isSelected==null){
      isSelected=false;
    }
  }

}

