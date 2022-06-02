

import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mangr/icon_pack_icons.dart';
import 'package:mangr/main.dart';
import 'package:mangr/objects/date_value_object.dart';
import 'package:share/share.dart';

getText(String text, { TextType textType, Color color,int maxLines,bool crossed,bool isCentered}){

  if(textType==null){
    textType=TextType.textTypeNormal;
  }

  if(color==null){
    color= MyApp.isDarkMode?Colors.white:MyColors.color_black;
  }

  if(crossed==null){
    crossed=false;
  }

  if(isCentered==null){
    isCentered=false;
  }

  return Text(text,maxLines: maxLines??1,style: TextStyle(fontSize: textType.size,
    color: color,
    fontWeight: textType.fontWeight,
    decoration: crossed?TextDecoration.lineThrough:TextDecoration.none
  ),textAlign: isCentered?TextAlign.center:null,);

}


getRandomTip(){
  Random random = Random();

  switch(random.nextInt(10)){
    case 0 : return Tips.tip1;
    case 1 : return Tips.tip2;
    case 2 : return Tips.tip3;
    case 3 : return Tips.tip4;
    case 4 : return Tips.tip5;
    case 5 : return Tips.tip6;
    case 6 : return Tips.tip7;
    case 7 : return Tips.tip8;
    case 8 : return Tips.tip9;
    default :return Tips.tip10;
  }
}


getTipView(String text){
  return Card(
    shape: getShape(),
    elevation: 10,
    color: MyApp.isDarkMode?MyColors.color_black_darker:Colors.white,
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            child: Icon(IconPack.bulb,color: MyColors.color_secondary,),
            padding: EdgeInsets.symmetric(horizontal: 7),
          ),
          Expanded(
            child: getText(text,maxLines: 3,),
          )
        ],
      ),
    ),
  );
}


getChart(List<DateValueObject> listDateValueObject,{bool yIsMoney}){


  if(yIsMoney==null){
    yIsMoney=true;
  }

  return charts.TimeSeriesChart(
    [
      charts.Series<DateValueObject, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DateValueObject dateValueObject, _) => dateValueObject.dateTime,
        measureFn: (DateValueObject dateValueObject, _) => dateValueObject.value,
        data: listDateValueObject,
      )
    ],
    primaryMeasureAxis: yIsMoney?charts.NumericAxisSpec(
      tickFormatterSpec: charts.BasicNumericTickFormatterSpec.fromNumberFormat(NumberFormat.compactSimpleCurrency())):null,
    domainAxis: charts.DateTimeAxisSpec(
            tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                day: charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'MM/dd/yyyy'))),
  );

}

showDistivityDatePicker({@required Function(DateTime) onDateSelected,@required BuildContext context}){

  Future<DateTime> dateTime =showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime(2050),
    initialDate: DateTime.now(),
  );

  dateTime.then((onValue){
    onDateSelected(onValue);
  });

}


showFeedbackBottomSheet(BuildContext context){

  TextEditingController feedBackTEC = TextEditingController();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;


  showDistivityModalBottomSheet(context, Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: <Widget>[

      getTextField(
        textEditingController: feedBackTEC,
        textInputType: TextInputType.text,
        width: 300,
        focus: true,
        hint: 'Your feedback goes here',
        variant: 1,
      ),

      IconButton(
        icon: Icon(IconPack.send),
        onPressed: (){
          firebaseDatabase.reference().push().set(feedBackTEC.text);
          Navigator.pop(context);
          showDistivitySnackBar(context, "Feedback send. Thank you <3");
        },
      ),
    ],



  ));


}


showDistivitySnackBar(BuildContext context, String text,{SnackBarAction action}){

  // Scaffold.of(context).showSnackBar(SnackBar(
  //   content: getText(text),
  //   action: action,
  //   shape: getShape(bottomSheetShape: true),
  //   backgroundColor: MyApp.isDarkMode? MyColors.color_black_darker:Colors.white,
  // ));

}

getPopupMenuItem({@required int value,@required String name, @required IconData iconData,String description}){

  return PopupMenuItem(
    value: value,
    child: ListTile(
      trailing: Icon(iconData,color: getIconColor(),),
      title: getText(name),
      subtitle: description!=null?getText(description,textType: TextType.textTypeSubNormal):null,
    ),
  );
}

getTextField({@required TextEditingController textEditingController,String hint,@required int width,
  @required TextInputType textInputType,bool focus,int variant}){

    if(focus==null){
      focus = false;
    }

    if(variant==null){
      variant=1;
    }

  return Container(
    width: width.toDouble(),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: variant==1?MyApp.isDarkMode?MyColors.color_gray_darker:MyColors.color_gray_lighter:Colors.transparent),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      child: TextFormField(
        autofocus: focus,
        keyboardType: textInputType,
        controller: textEditingController,
        style: TextStyle(fontSize: TextType.textTypeNormal.size,color: MyApp.isDarkMode?Colors.white:MyColors.color_black),
        decoration: InputDecoration.collapsed(
          hintText: hint??'',
          hintStyle: TextStyle(fontSize: TextType.textTypeNormal.size,color: MyApp.isDarkMode?MyColors.color_gray_lighter:MyColors.color_gray_darker),
        ),
      ),
    ),
  );

}

getSkeletonView(int width,int height){
  return Container(
                        height: height.toDouble(),
                        width: width.toDouble(),
                        decoration: BoxDecoration( color: MyColors.color_gray,borderRadius: BorderRadius.circular(7)),
                      );
}



getButton({int variant,@required Function onPressed,@required String text}){
  if(variant==null||variant>2){
    variant=1;
  }

  return FlatButton(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 7),
      child: getText("$text",color: variant==1?MyColors.color_black:MyApp.isDarkMode?MyColors.color_secondary:MyColors.color_primary_light),
    ),
    onPressed: onPressed,
    shape: getShape(),
    color: variant==1?MyColors.color_secondary:Colors.transparent,
  );
}



getCheckBox(String text,bool checked,Function(bool) onCheckedChanged ){
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Checkbox(
          onChanged: onCheckedChanged,
          value: checked,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: getText(text),
      )
    ],

  );
}


Widget getSwitch(String text,bool isChecked, Function(bool isChecked) onCheckedChangedPlusSetState,){
  return Row(
    children: <Widget>[
      Switch(
        onChanged: onCheckedChangedPlusSetState,
        value: isChecked,
      ),
      getText(text)
    ],
  );
}


RoundedRectangleBorder getShape({bool bottomSheetShape}){

  if(bottomSheetShape==null){
    bottomSheetShape=false;
  }

  if(bottomSheetShape){
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )
    );
  }else{
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    );
  }
}

Widget getAppBar(String title,{bool backEnabled,bool centered, BuildContext context}){
  if(centered==null){
    centered=false;
  }
  if(backEnabled==null){
    backEnabled=false;
  }
  return PreferredSize(
    preferredSize: Size.fromHeight(85),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Align(
        alignment: centered?Alignment.bottomCenter:Alignment.bottomLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              visible: backEnabled,
              child: IconButton(icon: Icon(IconPack.carret_backward,color: MyApp.isDarkMode?Colors.white:MyColors.color_black,),onPressed: (){Navigator.pop(context);},),
            ),
            getText(title, textType: TextType.textTypeTitle)
          ],
        ),
      ),
    ),
  );
}



showDistivityDialog({@required BuildContext context,@required List<Widget> actions ,@required String title,@required Widget content}){

  showDialog(context: context,builder: (ctx){
    return AlertDialog(
      backgroundColor: MyApp.isDarkMode?MyColors.color_black_darker:Colors.white,
      shape: getShape(),
      actions: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: actions
          ),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: getText(title,textType: TextType.textTypeSubtitle)
          ),
          content
        ],
      ),
    );
  });
}


Widget getFlareCheckbox(bool enabled,bool snapToEnd,{Function(bool) onCallbackCompleted,Function onTap}){
    return Container(
      width: 30,
      height: 30,
      child: GestureDetector(
        onTap: onTap,
        child: FlareActor(AssetsPath.checkboxAnimation,snapToEnd: snapToEnd,
          animation: enabled?'onCheck':'onUncheck',
          callback: (name){
            if(onCallbackCompleted!=null)onCallbackCompleted(name=='onCheck');
          },
        ),
      ),
    );
  }

getIconColor(){
    return MyApp.isDarkMode?Colors.white:MyColors.color_black;
}


showDistivityModalBottomSheet(BuildContext context, Widget content,{bool hideHandler}){

  if(hideHandler==null){
    hideHandler=false;
  }


  showModalBottomSheet(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))),
    backgroundColor: MyApp.isDarkMode?MyColors.color_black_darker:Colors.white,
    isScrollControlled: true,context: context,builder: (ctx){
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: !hideHandler,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getSkeletonView(75, 4)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: content,
              )
            ],
          ),
        ),
      );
  },
  );
}


DateFormat getDateFormat({bool timeNotDate}){
  if(timeNotDate==null){
    timeNotDate=false;
  }

  return DateFormat(timeNotDate?'HH:mm':'dd-MM-yy');
}

shareApp(){
  Share.share('Hey. So this is helping my business a bunch, and I figured out that you should try it too : https://play.google.com/store/apps/details?id=com.distivity.mangr');
}




class MyColors{
  static const Color color_primary = Color(0xff142d4c);
  static const Color color_primary_light = Color(0xff2b517a);
  static const Color color_secondary = Color(0xffffe161);
  static const Color color_black = Color(0xff252525);
  static const Color color_black_darker = Color(0xff202020);
  static const Color color_gray = Color(0xff999999);
  static const Color color_gray_darker = Color(0xff393939);
  static const Color color_red = Color(0xffC14242);
  static const Color color_gray_lighter = Color(0xffd6d6d6);
    
}




class TextType{

  double size;
  FontWeight fontWeight;
  TextType(this.size,this.fontWeight);

  static final TextType textTypeTitle =TextType(41,FontWeight.w700);
  static final TextType textTypeSubtitle =TextType(29,FontWeight.w600);
  static final TextType textTypeNormal =TextType(18,FontWeight.w500);
  static final TextType textTypeSubNormal =TextType(14,FontWeight.w300);
  static final TextType textTypeGigant =TextType(60,FontWeight.w900);

}


class AssetsPath{
  static var checkboxAnimation = "assets/animations/checkbox.flr";
  static var appIcon = 'assets/icons/mangr_icon.png';
}

launchPage(BuildContext context , Widget page){
  Navigator.push(context, MaterialPageRoute(
    builder: (context){
      return page;
    }
  ));
}



class Tips{

  static const String tip1 = 'First win the war, then go to it';
  static const String tip2 = 'What are 20% of your efforts that produce 80% of your income';
  static const String tip3 = 'Don\'t stop when you\'re tired. Stop when you\'re done!';
  static const String tip4 = 'If a warrior keeps death in mind at all times and lives as though each day might be his last, he will conduct himself properly in all his actions ';
  static const String tip5 = 'Whenever you find yourself on the side of the majority, it\'s time to pause and reflect';
  static const String tip6 = 'Innovation is a combination of knowledge, skill and courage';
  static const String tip7 = 'Creativity removes competition';
  static const String tip8 = 'What would happen if you did the oposite of those around you?';
  static const String tip9 = 'Define your unique selling point';
  static const String tip10 = 'Your product needs to be so good, when you rise the price to be greater than your competitors, your users will still be forced to buy it';

}