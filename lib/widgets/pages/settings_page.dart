import 'package:flutter/material.dart';
import 'package:mangr/main.dart';
import 'package:mangr/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (ctx,AsyncSnapshot<SharedPreferences> snap){
        if(snap.hasData){
          return Scaffold(
            appBar: getAppBar('Settings',backEnabled: true,context: context),
            body: ListView(
              children: <Widget>[
                getSwitch('Dark theme', MyApp.isDarkMode, (val) async {
                  snap.data.setBool('isDark', !MyApp.isDarkMode);
                  MyApp.restartApp(context);
                }),
                getSwitch('Disable daily tip', snap.data.getBool('disabletip')??false, (val){
                  setState(() {
                    snap.data.setBool('disabletip', val);
                  });
                }),
              ],
            )
          );
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}