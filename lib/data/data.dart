
import 'dart:convert';
import 'dart:io' as io;

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mangr/objects/date_value_object.dart';
import 'package:mangr/objects/goal.dart';
import 'package:mangr/objects/project.dart';
import 'package:mangr/utils.dart';
import 'package:mangr/widgets/pages/setup_page.dart';
import 'package:path/path.dart';
import "package:path_provider/path_provider.dart";

class DataHelper{


  Map<String,dynamic> business;
  io.Directory localDirectory;
  Function onDataUpdated;
  int timesOpened;




  DataHelper({this.onDataUpdated});

  static DataHelper _dataHelper;

  static Future<DataHelper> getInstance(BuildContext context,{Function onDataUpdated})async{

    if(_dataHelper==null){
      _dataHelper=DataHelper();
    }

    if(_dataHelper.localDirectory==null){
      _dataHelper.localDirectory =await getApplicationDocumentsDirectory();
    }

    if(onDataUpdated!=null){
      _dataHelper.onDataUpdated=onDataUpdated;
    }

    io.File file = io.File(join(_dataHelper.localDirectory.path,"business.json"));

    if(!await file.exists()){
      await file.create();
      file.writeAsString(jsonEncode({'name':'Your business','id':0}));
      _dataHelper.business = jsonDecode(await file.readAsString());
    }else{
      _dataHelper.business = jsonDecode((await file.readAsString())??'  ');
    }

    if(_dataHelper.getBusinessName()=='ls--'){
      launchPage(context,SetupPage(dataHelper: _dataHelper,));
    }

    return _dataHelper;
  }



  
/////////goals
addGoal(bool update,{@required Goal goal}) async {

    List goals = business[_ConstantsHelpers.goals]??List();
    if(update){
      for(int i = 0 ; i < goals.length ; i++){
        if(goals[i]['id']==goal.id){
          goals[i]=goal.toMap();
        }
      }
    }else{
      goals.add(goal.toMap());
    }

    business[_ConstantsHelpers.goals]=goals;
    await saveJson();

  }

  List<Goal> getGoals(){

    List<Goal> goals = List();

    List mappedGoals = business[_ConstantsHelpers.goals]??List();

    if(mappedGoals==null){
      return List();
    }

    mappedGoals.forEach((f){
      goals.add(Goal.fromMap(f));
    });

    return goals;
  }


  deleteGoal(int goalId) async {

    List<Map<String,dynamic>> goalsMap = business[_ConstantsHelpers.goals];

    for(int i = 0 ; i<goalsMap.length;i++){
      if(goalsMap[i]['id']==goalId){
        goalsMap.removeAt(i);
        business[_ConstantsHelpers.goals]=goalsMap;
        await saveJson();
      }
    }


  }
////////




  //business name
  setBusinessName(String name) async {
    business['bsname']=name;
    await saveJson();
  }

  getBusinessName(){
    return business['bsname']??'ls--';
  }




  //products
  addProject(bool update,{@required Project product}) async {

    print('print set in add project');

    List products = business[_ConstantsHelpers.projects]??List();


    if(update){
      for(int i = 0 ; i< products.length; i++){
        Project curentProject = Project.fromMap(products[i]);
        if(product.id==curentProject.id){
          products[i]=product.toMap();
        } 
      }
    }else{
      products.add(product.toMap());
    }


    
    business[_ConstantsHelpers.projects]=products;
    await saveJson();

  }

  List<Project> getProjects(){

    List products = business[_ConstantsHelpers.projects];


    if(products ==null){
      return List();
    }else{

      List<Project> toReturn = List();

      products.forEach((product){
        toReturn.add(Project.fromMap(product));
      });

      return toReturn;
    }


  }


  deleteProject(int id) async {

    List products = business[_ConstantsHelpers.projects];

    for(int i = 0 ; i<products.length;i++){
      if(products[i]['id']==id){
        products.removeAt(i);
        business[_ConstantsHelpers.projects]=products;
        await saveJson();
      }
    }


  }
  ///



  getIdCount() async {
    int id= business[_ConstantsHelpers.idCount]??-1;


    business[_ConstantsHelpers.idCount]= id+1;
    await saveJson();


    return id;
  }




  //niche
  setNiche(String niche) async {
    business[_ConstantsHelpers.niche] = niche;
    await saveJson();
  }

  String getNiche(){
    return business[_ConstantsHelpers.niche]?? 'No niche';
  }  
  //


  //digital_or_phisichal
  setIsBusinessDigital(bool isDigital) async {
    business[_ConstantsHelpers.isDigital] = isDigital;
    await saveJson();
  }

  bool getIsBusinessDigital(){
    return business[_ConstantsHelpers.isDigital]?? false;
  }  
  //


  List<DateValueObject> getRevenueHistory(){

    List mapRH = business[_ConstantsHelpers.revenueHistory];

    List<DateValueObject> rh = List();

    if(mapRH == null){
      return rh;
    }

    mapRH.forEach((i){
      rh.add(DateValueObject.fromMap(i));
    });

    return rh;
  }


  List<DateValueObject> getRevenuePerMonthHistory(){

    List mapRH = business[_ConstantsHelpers.revenuePerMonthHistory]??List();

    List<DateValueObject> rh = List();

    mapRH.forEach((i){
      rh.add(DateValueObject.fromMap(i));
    });

    return rh;
  }


  List<DateValueObject> getExpensesPerMonthHistory(){

    List mapRH = business[_ConstantsHelpers.expensesPerMonthHistory]??List();

    List<DateValueObject> rh = List();

    mapRH.forEach((i){
      rh.add(DateValueObject.fromMap(i));
    });

    return rh;
  }


  /////////revenue related
  setRevenuePerMonth(int rpm) async {
    business[_ConstantsHelpers.revenuePerMonth]=rpm;


    List revenuePerMonthHistory =business[_ConstantsHelpers.revenuePerMonthHistory]?? List();

    revenuePerMonthHistory.add(DateValueObject(DateTime.now(),rpm).toMap());

    business[_ConstantsHelpers.revenuePerMonthHistory]=revenuePerMonthHistory;

    await saveJson();
  }
  int getRevenuePerMonth(){
    return business[_ConstantsHelpers.revenuePerMonth]??0;
  }

  setExpensesPerMonth(int epm) async {
    business[_ConstantsHelpers.expensesPerMonth]=epm;


    List expensesPerMonthHistory = business[_ConstantsHelpers.expensesPerMonthHistory]??List();

    expensesPerMonthHistory.add(DateValueObject(DateTime.now(),epm).toMap());

    business[_ConstantsHelpers.expensesPerMonthHistory]=expensesPerMonthHistory;


    await saveJson();
  }
  int getExpensesPerMonth(){
    return business[_ConstantsHelpers.expensesPerMonth]??0;
  }

  setTotalRevenue(int tr,{bool update}) async {

    if(update==null){
      update=true;
    }

    business[_ConstantsHelpers.totalRevenue]=tr;

    List<Map<String,dynamic>> revenueHistory = List();
    List maprh =business[_ConstantsHelpers.revenueHistory];
    if(maprh!=null){
      maprh.forEach((item){
        revenueHistory.add(item);
      });
    }

    revenueHistory.add(DateValueObject(DateTime.now(),tr).toMap());

    business[_ConstantsHelpers.revenueHistory]=revenueHistory;


    if(update){
      await saveJson();
    }
  }
  int getTotalRevenue(){
    return business[_ConstantsHelpers.totalRevenue]??0;
  }
  /////revenuerelated
  


  saveJson()async{
    await io.File(join(localDirectory.path,"business.json")).writeAsString(jsonEncode(business));
    onDataUpdated();
  }

  deleteBusiness()async{
    await io.File(join(localDirectory.path,"business.json")).writeAsString('  ');
    onDataUpdated();
  }

  downloadJson()async{
    io.Directory directory = await  DownloadsPathProvider.downloadsDirectory;

    await (io.File(join(directory.path,'business.json'))..create()).writeAsString(jsonEncode(business));
  }

  Future loadJson()async {
   io.File file =  await FilePicker.getFile(fileExtension: '.json');
   business = jsonDecode(await file.readAsString());
   onDataUpdated();
  }


}

class _ConstantsHelpers{
  static const String businessId = "businessId";
  static const String businessName = 'businessName';
  static const String niche = "niche";
  static const String idCount = "idCount";
  static const String isDigital = "isDigital";

  static const String totalRevenue = "totalRevenue";
  static const String revenuePerMonth = "revenuePerMonth";
  static const String expensesPerMonth = "expensesPerMonth";

  static const String goals = "goals";
  static const String projects = "projects";

  static const String revenueHistory = "revenueHistory";
  static const String revenuePerMonthHistory = "revenuePerMonthHistory";
  static const String expensesPerMonthHistory = 'expensesPerMonthHistory';

  //remember to update schema
}


class Backend{


  GoogleSignInAccount  currentUser ;
  

  // Specify the permissions requested at login 
  GoogleSignIn  googleSignIn  =  new  GoogleSignIn ( 
    scopes:  <String>[ 
      
    ], 
  );


  void  initState ()  { 
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount  account)  { 
      
      currentUser  =  account ; 

      //send to backend
      
      if (currentUser != null )  { 
        // _HandleGetFiles (); 
      } 
    } ); 
    googleSignIn.signInSilently (); 
  }

  // google sign in 
  Future handleSignIn ()  async  { 
    try  { 
      await  googleSignIn.signIn (); 
    }  catch  (error){ 
      print(error); 
    } 
  }




}