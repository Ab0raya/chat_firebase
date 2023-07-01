import 'package:flutter/material.dart';

import '../helper/colors.dart';
class CustomTextField extends StatelessWidget {
  final IconData? visibleIcon;
  final IconData? icon;

  final String hint;

  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final void Function()? hiding;
  bool obscured;


  CustomTextField(
      {super.key,
        required this.hint,
        required this.onChanged,
        required this.obscured,
        this.visibleIcon,
        this.hiding,
        required this.onSubmitted, this.icon,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: TextFormField(
        onFieldSubmitted: onSubmitted,
        obscureText: obscured,
        validator: (data) {
          if (data!.isEmpty) {
            return 'Required input';
          }
          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(icon,color: a1,),
          suffixIcon: IconButton(
            onPressed: hiding,
            icon: Icon(visibleIcon),
            color: obscured ? a1 : a4,
          ),
          filled: true,
          fillColor: a3,
          hintText: hint,
          hintStyle:  TextStyle(color: a4),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
