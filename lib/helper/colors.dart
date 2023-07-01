import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



  Color a1 = const Color(0xff4b86f8);
  Color a2 = Colors.black;
  Color a3 = const Color(0xffe0e0e0);
  Color a4 = const Color(0xffa5a5a7);
  Color a5 = const Color(0xffceced2);
  Color a6 = Colors.white;
  Color a7 = const Color(0xff2b2b2b);
  bool isDark = false;
  gerDarkModeBool()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    print('====================================${sf.getBool('darkMode')}');
    isDark = sf.getBool('darkMode')!;
  }


