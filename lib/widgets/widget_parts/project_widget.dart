import 'package:flutter/material.dart';
import 'package:mangr/data/data.dart';
import 'package:mangr/main.dart';
import 'package:mangr/objects/project.dart';
import 'package:mangr/widgets/pages/project_page.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


import '../../icon_pack_icons.dart';
import '../../utils.dart';

class ProjectWidget extends StatefulWidget {

  final Project project;
  final DataHelper dataHelper;
  final Function() onEditPressed;
  final Function onItemDeleted;

  ProjectWidget({Key key,@required this.project,@required this.dataHelper,this.onEditPressed,this.onItemDeleted}) : super(key: key);

  @override
  _ProjectWidgetState createState() => _ProjectWidgetState();
}

class _ProjectWidgetState extends State<ProjectWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
            onTap: (){
              launchPage(context, ProjectPage(dataHelper: widget.dataHelper,project: widget.project,));
            },
            title: getText(widget.project.name),
            subtitle: LinearPercentIndicator(
              animation: true,
              animationDuration: 2000,
              percent: getProgress(widget.project),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: MyColors.color_primary_light,
            ),
            trailing: Visibility(
              visible: widget.onEditPressed!=null,
              child: PopupMenuButton(
                color: MyApp.isDarkMode?MyColors.color_black_darker:Colors.white,
                shape: getShape(),
                icon: Icon(IconPack.dots_vertical,color: getIconColor(),),
                itemBuilder: (ctx){
                  return <PopupMenuItem>[
                    getPopupMenuItem(value: 1,name: 'EditProject',iconData: IconPack.edit),
                    getPopupMenuItem(value: 0,name: 'Delete project',iconData: IconPack.trash),
                  ];
                },
                onSelected: (value) async {
                  switch(value){
                    case 0 : await widget.dataHelper.deleteProject(widget.project.id);widget.onItemDeleted(); break;
                    case 1 : widget.onEditPressed(); break;
                  }
                },
              ),
            ),
          );
  }

  double getProgress(Project curentProject){
    double progress = 0;

    curentProject.checklist.forEach((check){
      if(check){
        progress = progress + 0.165;
      }
    });

    return progress;
  }
}