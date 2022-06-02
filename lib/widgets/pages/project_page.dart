import 'package:flutter/material.dart';
import 'package:mangr/data/data.dart';
import 'package:mangr/icon_pack_icons.dart';
import 'package:mangr/main.dart';
import 'package:mangr/objects/project.dart';
import 'package:mangr/utils.dart';
import 'package:mangr/utils.dart' as prefix0;


class ProjectPage extends StatefulWidget {

  final Project project;
  final DataHelper dataHelper;

  ProjectPage({Key key,@required this.project,@required this.dataHelper}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {

  bool snapToEnd = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(widget.project.name,backEnabled: true,context: context),
      body: Column(
        children: <Widget>[
          
          Padding(
            padding: EdgeInsets.only(top: 20,bottom: 10,left: 7,right: 7),
            child: getText(widget.project.description,maxLines: 30),
          ),

          FlatButton(
            shape: getShape(),
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7,),
                    child: Icon(IconPack.calendar,size: 15,color: MyApp.isDarkMode?MyColors.color_secondary:MyColors.color_primary_light,),
                  ),
                  getText('Deadline: ${getDateFormat().format(widget.project.dueDate)}',
                    color:MyApp.isDarkMode?MyColors.color_secondary:MyColors.color_primary_light ),
                ],
              ),
            ),
            onPressed: (){
              prefix0.showDistivityDatePicker(
                context: context,
                onDateSelected: (date){
                  setState(() async {
                   widget.project.dueDate=date;
                   await widget.dataHelper.addProject(true,product: widget.project);
                  });
                }
              );
            },
          ),

          getButton(
            variant: 2,
            text: 'Curent date: ${getDateFormat().format(widget.project.dueDate)}',
            onPressed: (){
              prefix0.showDistivityDatePicker(
                context: context,
                onDateSelected: (date){
                  setState(() async {
                   widget.project.dueDate=date;
                   await widget.dataHelper.addProject(true,product: widget.project);
                  });
                }
              );
            }
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.project.checklist.length, (index){

              List<String> strings = getCheckName(index).split('.');

              return ListTile(
                leading: getFlareCheckbox(widget.project.checklist[index], snapToEnd,
                  onCallbackCompleted: (checked){
                    setState(() async {
                      await widget.dataHelper.addProject(true,product: widget.project); 
                      launchPopupifProjectDone();
                    });
                  },
                  onTap: (){
                    setState(() {
                     snapToEnd=false;
                     widget.project.checklist[index] = !widget.project.checklist[index]; 
                    });
                  },
                  ),
                title: getText(strings[0],crossed: widget.project.checklist[index]),
                subtitle:strings.length!=1?getText(strings[1],textType: TextType.textTypeSubNormal):null,
              );
            }),
          )
        ],
      ),
    );
  }


  String getCheckName(int index){
    switch(index){
      case ProjectObjectHelper.todo_populate_todolist: return 'Populate your todolist with actions';break;
      case ProjectObjectHelper.todo_prioritize: return 'Prioritize your todos.Remember, effectiveness beats productivity';break;
      case ProjectObjectHelper.set_deadlines: return 'Set deadlines to this project';break;
      case ProjectObjectHelper.release_demo: return 'Release the product to the public'; break;
      case ProjectObjectHelper.gain_feedback: return 'Gain feedback from the users and meetings.See what you did right,wrong and what you can improve on';break;
      case ProjectObjectHelper.complete_tasks: return 'Complete tasks'; break;
      default: return 'dlkdfjldf'; break;
    }
  }

  void launchPopupifProjectDone() {

    bool areAllChecked= true;

    widget.project.checklist.forEach((value){
      if(!value){
        areAllChecked=false;
      }
    });

    if(areAllChecked){
      showDistivityDialog(
        actions: [
          getButton(
            variant: 1,
            onPressed: (){
              Navigator.pop(context);
            },
            text: 'Ok'
          ),
          getButton(
            variant: 2,
            onPressed: () async {
              await widget.dataHelper.deleteProject(widget.project.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: 'Delete project'
          ),
          
        ],
        content: getText('Yay, you\'ve completed this project'),
        context: context,
        title: 'Congrats',
        );
    }
  }
}