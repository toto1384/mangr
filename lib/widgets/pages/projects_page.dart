import 'package:flutter/material.dart';
import 'package:mangr/data/data.dart';
import 'package:mangr/icon_pack_icons.dart';
import 'package:mangr/objects/project.dart';
import 'package:mangr/utils.dart';
import 'package:mangr/widgets/widget_parts/project_widget.dart';


class ProjectsPage extends StatefulWidget {


  final DataHelper dataHelper;

  ProjectsPage({Key key,@required this.dataHelper}) : super(key: key);

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {

  List<Project> projects;

  @override
  void initState() { 
    if(projects==null){
      projects = widget.dataHelper.getProjects();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (ctx,index){
          Project curentProject = projects[index];
          return ProjectWidget(
            dataHelper: widget.dataHelper,
            project: curentProject,
            onItemDeleted: (){updateData();},
            onEditPressed: (){
              showAddProjectBottomSheet(project: curentProject);
            },
          );
        },
      ),
      appBar: getAppBar('Projects',context: context,backEnabled: true),
      floatingActionButton: FloatingActionButton.extended(
        label: getText('Add project',color: Colors.white),
        icon: Icon(IconPack.add,color: Colors.white,),
        onPressed: (){
          showAddProjectBottomSheet();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  showAddProjectBottomSheet({Project project}){

    TextEditingController nameEditingController = TextEditingController();
    TextEditingController descriptionEditingController = TextEditingController();
    int id;
    DateTime deadline = DateTime(2019);

    if(project!=null){
      nameEditingController.text = project.name;
      descriptionEditingController.text = project.description;
      id= project.id;
      deadline = project.dueDate;
    }else{
      id= widget.dataHelper.getIdCount();
    }

    showDistivityModalBottomSheet(context, Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            getTextField(
              textEditingController: nameEditingController,
              textInputType: TextInputType.text,
              width: 300,
              focus: true,
              hint: 'Enter project here,'
            ),
            IconButton(
              icon: Icon(IconPack.send,color: getIconColor(),),
              onPressed: () async {
                await widget.dataHelper.addProject(project!=null,product: Project(
                  dueDate: deadline,
                  description: descriptionEditingController.text,
                  id: id,
                  name: nameEditingController.text,
                  checklist: project!=null?project.checklist:null,
                ));
                updateData();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        getTextField(
          textEditingController: descriptionEditingController,
          textInputType: TextInputType.text,
          width: 350,
          focus: false,
          hint: 'Project description',
          variant: 2,
        ),

        Padding(
          padding: EdgeInsets.only(top: 10),
          child: getButton(
            variant: 2,
            text: 'Pick deadline',
            onPressed: (){
              showDistivityDatePicker(
                context: context,
                onDateSelected: (datetime){
                  deadline = datetime;
                }
              );
            }
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 10,bottom: 7,left: 7,right: 7
          ),
          child: getTipView('You can also use projects as \'versions\' or \'sprints\''),
        )
      ],
    ));
  } 


  updateData(){
    setState(() {
     projects= widget.dataHelper.getProjects(); 
    });
  }

}