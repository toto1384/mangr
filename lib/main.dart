
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:mangr/icon_pack_icons.dart';
import 'package:mangr/objects/goal.dart';
import 'package:mangr/objects/project.dart';
import 'package:mangr/utils.dart';
import 'package:mangr/widgets/pages/budget_page.dart';
import 'package:mangr/widgets/pages/company_goals_page.dart';
import 'package:mangr/widgets/pages/projects_page.dart';
import 'package:mangr/widgets/pages/settings_page.dart';
import 'package:mangr/widgets/pages/setup_page.dart';
import 'package:mangr/widgets/pages/stats_page.dart';
import 'package:mangr/widgets/widget_parts/animated_money_text.dart';
import 'package:mangr/widgets/widget_parts/goal_widget.dart';
import 'package:mangr/widgets/widget_parts/project_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data.dart';
import 'data/prefs.dart';
 
void main(){runApp(MyApp());}


class MyApp extends StatefulWidget{

  
  static bool isDarkMode = false;

  static restartApp(BuildContext context) {
    final MyAppState state =
        context.ancestorStateOfType(const TypeMatcher<MyAppState>());
    state.restartApp();
  }

  @override
  MyAppState createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp>{

  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Prefs.getInstance(),
      builder: (context,AsyncSnapshot<Prefs> snapshot){

        MyApp.isDarkMode=snapshot.hasData?snapshot.data.getDarkMode():false;
          
          return MaterialApp(
            title: 'Mangr',
            theme: ThemeData(
              accentColor: MyColors.color_secondary,
              primaryColor: MyColors.color_primary_light,
              primaryColorDark: MyColors.color_primary,
              scaffoldBackgroundColor: Colors.white,
              bottomAppBarColor:Colors.white,

            ),
            darkTheme: ThemeData(
              accentColor: MyColors.color_secondary,
              primaryColor: MyColors.color_primary_light,
              primaryColorDark: MyColors.color_primary,
              scaffoldBackgroundColor: MyColors.color_black,
              bottomAppBarColor: MyColors.color_black_darker,
            ),
            home: HomePage(),
            debugShowCheckedModeBanner: false,
            themeMode: MyApp.isDarkMode?ThemeMode.dark:ThemeMode.light,
        );
        
      },
    );

  }

}


class HomePage extends StatefulWidget {

  final bool updateDb;


  HomePage({Key key,this.updateDb}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  DataHelper dataHelper;
  List<Goal> companyGoals;
  List<Project> projects;

  int totalRevenue;
  int revenuePerMonth;
  int expensesPerMonth;

  SharedPreferences sharedPreferences;


  Future<bool> init()async{
    if(widget.updateDb??false||dataHelper==null){
      dataHelper = await DataHelper.getInstance(context,onDataUpdated: (){
        updateJson();
      });
    }

    if(companyGoals==null){
      companyGoals = dataHelper.getGoals();
    }

    if(projects==null){
      projects = dataHelper.getProjects();
    }

    if(sharedPreferences == null){
      sharedPreferences = await SharedPreferences.getInstance();
    }

    if(totalRevenue==null){
      totalRevenue=dataHelper.getTotalRevenue();
    }

    if(expensesPerMonth==null){
      expensesPerMonth = dataHelper.getExpensesPerMonth();
    }

    if(revenuePerMonth==null){
      revenuePerMonth = dataHelper.getRevenuePerMonth();
    }

    return true;
    
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (ctx,snap){

        if(snap.hasData){
          if(dataHelper.timesOpened==15){
            showDistivityDialog(
              actions: [],
              title: 'Help us',
              context: context,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getText('So, we hope that your business is doing great. And we hope that we provide the best service out there. If you can,please take a moment and :'),
                  Padding(
                    padding: EdgeInsets.only(top: 15,bottom: 5),
                    child: getButton(
                      variant: 1,
                      text: 'Rate the app',
                      onPressed: (){LaunchReview.launch();},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5,bottom: 5,),
                    child: getButton(
                      variant: 2,
                      text: 'Send feedback',
                      onPressed: (){showFeedbackBottomSheet(context);},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5,bottom: 15),
                    child: getButton(
                      variant: 2,
                      text: 'Share it with your friends',
                      onPressed: (){shareApp();},
                    ),
                  )
                ],
              ),

            );
          }
        }

        return snap.hasData?Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(IconPack.menu_line,color: getIconColor(),),
                  onPressed: (){showMenuBottomSheet();},
                ),
                IconButton(
                  icon: Icon(IconPack.dots_vertical,color: getIconColor(),),
                  onPressed: (){showMoreBottomSheet();},
                ),
              ],
            ),
          ),
          body: snap.hasData? ListView(
            children: <Widget>[
                  Visibility(
                    visible: !(sharedPreferences.getBool('disabletip')??false),//replace with setting
                    child: getTipView(getRandomTip()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 23,bottom: 10),
                    child: Card(
                      color: MyApp.isDarkMode?MyColors.color_black_darker:Colors.white,
                      shape: getShape(),
                      elevation: 10,
                      child: InkWell(
                        onTap: (){
                          launchPage(context, BudgetPage(dataHelper: dataHelper,));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      getText("Total Revenue",textType: TextType.textTypeSubtitle),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          AnimatedMoneyText(textType: TextType.textTypeTitle,value: totalRevenue),
                                          IconButton(
                                            icon: Icon(IconPack.edit,size: 15,color: getIconColor(),),
                                            onPressed: (){
                                              BudgetPageState.showEditTotalRevenueBottomSheet(
                                                context: context,
                                                dataHelper: dataHelper,
                                                updateJson: (value){
                                                  totalRevenue= value;
                                                  updateJson();
                                                }
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      getText("Revenue Per Month",textType: TextType.textTypeNormal),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          AnimatedMoneyText(textType: TextType.textTypeSubtitle,value: revenuePerMonth),
                                          IconButton(
                                            icon:  Icon(IconPack.edit,size: 15,color: getIconColor(),),
                                            onPressed: (){
                                               BudgetPageState.showEditExpensesRevenuePerMonthBottomSheet(
                                                expensesNotRevenue: false,
                                                context: context,
                                                updateJson: (value){
                                                  revenuePerMonth = value;
                                                  updateJson();
                                                },
                                                dataHelper: dataHelper);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  getSkeletonView(3, 30),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      getText("Expenses Per Month",textType: TextType.textTypeNormal),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          AnimatedMoneyText(textType: TextType.textTypeSubtitle,value: expensesPerMonth),
                                          IconButton(
                                            icon:  Icon(IconPack.edit,size: 15,color: getIconColor(),),
                                            onPressed: (){
                                              BudgetPageState.showEditExpensesRevenuePerMonthBottomSheet(
                                                expensesNotRevenue: true,
                                                context: context,
                                                updateJson: (value){
                                                  expensesPerMonth = value;
                                                  updateJson();
                                                },
                                                dataHelper: dataHelper);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Padding(
                              //   padding: EdgeInsets.all(10),
                              //   child: getText("Payday: ${dataHelper.getPayDay()}"),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: (){launchPage(context, StatsPage(dataHelper: dataHelper,));},
                          child: getText("Stats",textType: TextType.textTypeSubtitle),
                        ),
                        IconButton(
                          icon: Icon(IconPack.expand_icon,size: 15,color: getIconColor(),),
                          onPressed: (){
                            launchPage(context, StatsPage(dataHelper: dataHelper,));
                          },
                        )
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: 250,
                      height: 250,
                      child: getChart(dataHelper.getRevenueHistory()),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 10,top: 25,bottom: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: (){launchPage(context, CompanyGoalsPage(dataHelper: dataHelper,));},
                          child: getText("Company Goals",textType: TextType.textTypeSubtitle),
                        ),
                        IconButton(
                          icon: Icon(IconPack.expand_icon,size: 15,color: getIconColor(),),
                          onPressed: (){
                            launchPage(context, CompanyGoalsPage(dataHelper: dataHelper,));
                          },
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: getPGList(false),
                  ),


                
                  Padding(
                    padding: EdgeInsets.only(left: 10,top: 25,bottom: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: (){launchPage(context, ProjectsPage(dataHelper: dataHelper,));},
                          child: getText("Projects",textType: TextType.textTypeSubtitle),
                        ),
                        IconButton(
                          icon: Icon(IconPack.expand_icon,size: 15,color: getIconColor(),),
                          onPressed: (){
                            launchPage(context, ProjectsPage(dataHelper: dataHelper,));
                          },
                        )
                      ],
                    ),
                  ),
                  Column(

                    mainAxisSize: MainAxisSize.min,
                    children: getPGList(true),
                  ),
            ],
          ):Column(
            //skeleton view
          ),
            appBar: getAppBar(dataHelper.getBusinessName()),
        ):Center(
          child: Image.asset(AssetsPath.appIcon),
        );
      },
    );
  }


  updateJson(){
    setState(() {
     companyGoals=dataHelper.getGoals();
     projects = dataHelper.getProjects();
    });
  }

  showMoreBottomSheet(){

    showDistivityModalBottomSheet(context, Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        ListTile(
          leading: Icon(IconPack.settings,color: getIconColor(),),
          title: getText('Settings'),
          onTap: (){
            launchPage(context, SettingsPage());
          },
        ),
        ListTile(
          leading: Icon(IconPack.star,color: getIconColor(),),
          title: getText('Rate'),
          onTap: (){
            LaunchReview.launch();
          },
        ),


        ListTile(
          leading: Icon(IconPack.person,color: getIconColor(),),
          title: getText('Share'),
          onTap: (){
            shareApp();
          },
        ),
          
        

        ListTile(
          leading: Icon(IconPack.feedback,color: getIconColor(),),
          title: getText('Send feedback'),
          onTap: (){
            showFeedbackBottomSheet(context);
          },
        ),
        ListTile(
          leading: Icon(IconPack.trash,color: MyColors.color_red,),
          title: getText('Delete business',color: MyColors.color_red),
          onTap: (){
            dataHelper.deleteBusiness();
            launchPage(context, SetupPage(dataHelper: dataHelper,));
          },
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15,bottom: 5),
              child: getText('Mangr- beta 0.1(holy s*it that\'s buggy)',maxLines: 2,textType: TextType.textTypeSubNormal),
            ),
          ],
        ),
        
      ],
    ));
  }

  showMenuBottomSheet(){
    showDistivityModalBottomSheet(context, Column(
      children: <Widget>[





        ListTile(
          leading: Container(width: 30,height: 30,child: Center(child: Icon(IconPack.money_icon,size: 20,color: MyColors.color_black_darker,),),
            decoration: BoxDecoration(color: MyColors.color_secondary,borderRadius: BorderRadius.circular(30)),),
          title: getText('Budgeting'),
          onTap: (){
            launchPage(context, BudgetPage(dataHelper: dataHelper,));
          },
        ),


        ListTile(
          leading: Container(width: 30,height: 30,child: Center(child: Icon(IconPack.chart,size: 20,color: MyColors.color_black_darker,)),
            decoration: BoxDecoration(color: MyColors.color_secondary,borderRadius: BorderRadius.circular(30))),
          title: getText('Statistics'),
          onTap: (){
            launchPage(context, StatsPage(dataHelper: dataHelper,));
          },
        ),


        ListTile(
          leading: Container(width: 30,height: 30,child: Center(child: Icon(IconPack.goal,size: 20,color: MyColors.color_black_darker,)),
            decoration: BoxDecoration(color: MyColors.color_secondary,borderRadius: BorderRadius.circular(30))),
          title: getText('Company goals'),
          onTap: (){
            launchPage(context, CompanyGoalsPage(dataHelper: dataHelper,));
          },
        ),



         ListTile(
          leading: Container(width: 30,height: 30,child: Center(child: Icon(IconPack.todo,size: 20,color: MyColors.color_black_darker,)),
            decoration: BoxDecoration(color: MyColors.color_secondary,borderRadius: BorderRadius.circular(30))),
          title: getText('Projects'),
          onTap: (){
            launchPage(context, ProjectsPage(dataHelper: dataHelper,));
          },
        ),

      ],
    ));
  }

  List<Widget> getPGList(bool isProjects) {

    int length;

    if(isProjects){

      length=projects.length>=5?6:projects.length;

      return List<Widget>.generate(length, (index){
        return index==5?getButton(variant: 2,text: 'More..',onPressed: (){launchPage(context, ProjectsPage(dataHelper: dataHelper,));}):
          ProjectWidget(dataHelper: dataHelper,project: projects[index],);
      });

    }else{

      length=companyGoals.length>=5?6:companyGoals.length;


    return List<Widget>.generate(length, (index){

      return index==5?getButton(variant: 2,text: 'More...',onPressed: (){launchPage(context, CompanyGoalsPage(dataHelper: dataHelper,));}):
        GoalWidget(goal: companyGoals[index],);

    });
    }


  }


}
