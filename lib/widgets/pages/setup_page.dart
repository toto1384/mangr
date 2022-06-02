
import 'package:flutter/material.dart';
import 'package:mangr/data/data.dart';

import '../../main.dart';
import '../../utils.dart';

class SetupPage extends StatefulWidget {

  final DataHelper dataHelper;

  SetupPage({Key key,@required this.dataHelper}) : super(key: key);

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  int qIndex = 0;
  Function onContinuePressed;

  TextEditingController bsnameEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  body: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      //    children: <Widget>[
      //      Padding(
      //        padding: const EdgeInsets.all(10),
      //        child: getText(QuestionWidget.getQuestionName(qIndex),textType: TextType.textTypeTitle),
      //      ),
      //      Padding(
      //        padding: const EdgeInsets.only(bottom: 20,top: 30,left: 10,right: 10),
      //        child: QuestionWidget(
      //          dataHelper: widget.dataHelper,
      //          index: qIndex,
      //          onCriteriaSelected: (){
      //            setState(() {
      //             qIndex++; 
      //            });
      //          },
      //          setOnContinuePressed: (onContinuePr){
      //            this.onContinuePressed=onContinuePr;
      //          },
      //        ),
      //      ),
      //    ],
      //  ),

       body: Center(
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: <Widget>[
             getText('Business name:',textType: TextType.textTypeSubtitle),
             Padding(
               padding: EdgeInsets.only(top: 20),
               child: getTextField(textEditingController: bsnameEditingController,textInputType: TextInputType.text,width: 300,focus: true,
                hint: 'Enter your business name here'),
             )
           ],
         ),
       ),
       appBar: getAppBar('Setup'),
       floatingActionButton: getButton(variant: 1,
            text: "Continue",
            onPressed: () async {
              await widget.dataHelper.setBusinessName(bsnameEditingController.text);
              launchPage(context, HomePage(updateDb: true,));
              // onContinuePressed();
              // setState(() {
              //   if(qIndex==7){
              //     launchPage(context, HomePage());
              //   }else{
              //     qIndex++;
              //   }
              // });
            }),
    );
  }
}



