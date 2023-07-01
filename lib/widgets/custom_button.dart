import 'package:flutter/material.dart';

import '../helper/colors.dart';
class CustomButton extends StatelessWidget {
  final String child;

  final void Function() func;

  const CustomButton({super.key, required this.child, required this.func});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: func,
        child: Container(
          alignment: Alignment.center,
          width: 150,
          height: 70,
          decoration: BoxDecoration(
            color: a1,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            child,
            style:  TextStyle(color: a6, fontSize: 35),
          ),
        ),
      ),
    );
  }
}
