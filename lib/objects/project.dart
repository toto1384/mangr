


import 'package:flutter/foundation.dart';
import 'package:mangr/utils.dart';

class Project{

  int id;
  DateTime dueDate;
  List<bool> checklist;
  String name;
  String description;

  Project({@required this.id,@required this.dueDate,this.checklist, @required this.name, @required this.description}){

    if(checklist==null){
      checklist = [false,false,false,false,false,false];
    }
  }

  Map toMap(){
    return {
      'id': id,
      'dueDate' : getDateFormat().format(dueDate),
      'checklist': checklist,
      'name': name,
      'description' : description,
    };
  }


  static Project fromMap(Map map){

    List<bool> checklist = List();

    map['checklist'].forEach((item){
      checklist.add(item);
    });


    return Project(
      checklist: checklist,
      description: map['description'],
      id: map['id'],
      name: map['name'],
      dueDate: getDateFormat().parse(map['dueDate']));
  }








}


class ProjectObjectHelper{

  static const int todo_populate_todolist = 0;
  static const int todo_prioritize = 1;
  static const int set_deadlines = 2;
  static const int complete_tasks = 3;
  static const int release_demo = 4;
  static const int gain_feedback = 5;

}