import 'package:flutter/material.dart';
import 'package:mangr/data/data.dart';
import 'package:mangr/icon_pack_icons.dart';
import 'package:mangr/objects/goal.dart';
import 'package:mangr/utils.dart';
import 'package:mangr/utils.dart' as prefix0;
import 'package:mangr/widgets/widget_parts/goal_widget.dart';

import '../../main.dart';


class CompanyGoalsPage extends StatefulWidget {

  final DataHelper dataHelper;

  CompanyGoalsPage({Key key,@required this.dataHelper}) : super(key: key);

  @override
  _CompanyGoalsPageState createState() => _CompanyGoalsPageState();
}

class _CompanyGoalsPageState extends State<CompanyGoalsPage> {


  List<Goal> companyGoals ;

  @override
  void initState() {
    if(companyGoals==null){
      companyGoals=widget.dataHelper.getGoals();
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: companyGoals.length,
        itemBuilder: (ctx,index){
          return Dismissible(
            key: Key(companyGoals[index].id.toString()),
            onDismissed: (direction) async {
              setState(() {
                companyGoals.removeAt(index);
              });

              await widget.dataHelper.deleteGoal(companyGoals[index].id);
              Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("${companyGoals[index].name} completed")));
            },
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: MyColors.color_primary_light,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(IconPack.todo,color: Colors.white,),
                  Icon(IconPack.todo,color: Colors.white,),
                ],
              ),
            ),
            
            child: GoalWidget(
              goal: companyGoals[index],
              onTap: (){
                showAddGoalBottomSheet(goal: companyGoals[index]);
              },
              popupMenuButton: PopupMenuButton(
                color: MyApp.isDarkMode?MyColors.color_black_darker:Colors.white,
                shape: getShape(),
                itemBuilder: (ctx){
                  return [
                    PopupMenuItem(
                      value: 0,
                      child: ListTile(
                        leading: Icon(IconPack.edit,color: getIconColor(),),
                        title: getText('Edit goal'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        leading: Icon(IconPack.trash,color: getIconColor(),),
                        title: getText('Delete goal'),
                      ),
                    ),
                  ];
                },
                icon: Icon(IconPack.dots_vertical,color: getIconColor(),),
                onSelected: (i) async {
                  switch(i){
                    case 0: showAddGoalBottomSheet(goal: companyGoals[index]);break;
                    case 1: await widget.dataHelper.deleteGoal(companyGoals[index].id);break;
                  }
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: getText('Add goal',color: Colors.white),
        icon: Icon(IconPack.add,color: getIconColor(),),
        onPressed: (){
          showAddGoalBottomSheet();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: getAppBar('Company Goals',context: context,backEnabled: true),
    );
  }

  showAddGoalBottomSheet({Goal goal}){

    TextEditingController nameTextEditingController = TextEditingController();
    TextEditingController descriptionTextEditingController = TextEditingController();
    DateTime duedate = DateTime(2019);
    int id;


    if(goal!=null){
      nameTextEditingController.text = goal.name;
      descriptionTextEditingController.text = goal.description;
      duedate = goal.dueDate;
      id= goal.id;
    }else{
      id = widget.dataHelper.getIdCount();
    }

    showDistivityModalBottomSheet(context, Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            getTextField(
            textEditingController: nameTextEditingController,
            textInputType: TextInputType.text,
            width: 300,
            focus: true,
            hint: 'Enter your goal here'
              ),
            IconButton(
              icon: Icon(IconPack.send),
              onPressed: ()async {
                await widget.dataHelper.addGoal(goal!=null,goal: Goal(
                  description: descriptionTextEditingController.text,
                  dueDate: duedate,
                  id: id,
                  name: nameTextEditingController.text
                ));
                Navigator.pop(context);
                setChanges();
              },
            )
          ],
        ),
        getTextField(
          textEditingController: descriptionTextEditingController,
          textInputType: TextInputType.text,
          width: 350,
          focus: false,
          hint: 'Describe your goal here',
          variant: 2,
        ),
        getButton(
          onPressed: (){
           prefix0.showDistivityDatePicker(
             context: context,
             onDateSelected: (date){
               duedate = date;
             }
           );
          },
          text: 'Pick date',
          variant: 2,
        )
      ],
    ));
  }

  setChanges(){
    setState(() {
     companyGoals = widget.dataHelper.getGoals(); 
    });
  }
}