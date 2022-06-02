import 'package:flutter/cupertino.dart';
import 'package:mangr/utils.dart';

class Goal{


  int id;
  String name;
  String description;
  DateTime dueDate;

  Goal({@required this.id,@required this.name,@required this.dueDate,@required this.description});


  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'name':name,
      'description':description,
      'dueDate':getDateFormat().format(dueDate),
    };
  }

  static Goal fromMap(Map map){

    return Goal(
      description: map['description'],
      dueDate: getDateFormat().parse(map['dueDate']),
      id: map['id'],
      name: map['name'],
    );
  }
}