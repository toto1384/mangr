


import 'package:shared_preferences/shared_preferences.dart';

class Prefs{

  static Prefs _instance;
  static Future<Prefs> getInstance()async{

    if(_instance.sharedPreferences==null){
      _instance.sharedPreferences= await SharedPreferences.getInstance();
    }

    return _instance;

  }


  SharedPreferences sharedPreferences;


  getTimesOpened(){
    return sharedPreferences.getInt(_PrefsValues.timesOpened)??0;
  }

  incrementTimesOpened(){
    sharedPreferences.setInt(_PrefsValues.timesOpened, getTimesOpened()+1);

  }

  resetTimesOpened(){
    sharedPreferences.setInt(_PrefsValues.timesOpened, 0);

  }

  getDarkMode(){
    return sharedPreferences.getBool(_PrefsValues.isDarkMode)??false;
  }

  setDarkMode(){
    sharedPreferences.setBool(_PrefsValues.isDarkMode, !getDarkMode());
  }


}

class _PrefsValues{
  static final String timesOpened = 'timesopened';

  static final String isDarkMode = 'isDarkMode';
}