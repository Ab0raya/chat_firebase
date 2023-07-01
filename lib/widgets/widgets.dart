import 'package:flutter/material.dart';

import '../helper/colors.dart';

void nextPageNamed(context , routeName){
  Navigator.pushNamed(context, routeName);
}
void nextPageNamedReplacement(context , routeName){
  Navigator.pushReplacementNamed(context, routeName);
}

void nextPage(context,Widget route){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> route));
}
showSnackBar(msg , context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
