import 'dart:convert';
import 'package:e_com/model/UserLoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> storeData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> retrieveData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  setRememberMe(String lang) async {

    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    sharedPref.setString('RememberMe', lang); //storing

  }

  setLanguage(String lang) async {

    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    sharedPref.setString('language', lang); //storing

  }
  setUserData(String jsonString) async {

    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('user', jsonString); //storing
  }

  setSettingsData(String jsonString) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('settings', jsonString); //storing
  }

  Future<String?> getSettings() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? settings = sharedPref.getString('settings');
    return settings;
  }
  setLoginUserData(String jsonString) async {

    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('LoginUser', jsonString); //storing
  }

  Future<String?>  getLanguage()  async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? lang = sharedPref.getString('language');
    if(lang == null){
      return "en";
    }else{

    return lang;}
  }

  Future<dynamic> getUserData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? user = sharedPref.getString('user');

    return user;
  }
  Future<dynamic> getLoginUserData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? user = sharedPref.getString('LoginUser');
    Map decodeOptions = jsonDecode(user!);
    return UserLoginModel.fromJson(decodeOptions);
  }




  Future<dynamic> getRememberMe() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if(sharedPref.containsKey('RememberMe')){
    String? user = sharedPref.getString('RememberMe');
    return user;}else{
      return "";
    }
  }

  Future<bool> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('LoginUser')){
      return true;
    }else{
      return false;
    }
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("language");
    prefs.remove("LoginUser");
    prefs.remove("user");


  }
}
