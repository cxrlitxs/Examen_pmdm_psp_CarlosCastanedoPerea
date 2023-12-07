import 'package:flutter/material.dart';

class TextFields_Personalizados extends StatelessWidget{

  final controller;
  final String hintText;
  final bool obscuredText;

  const TextFields_Personalizados ({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscuredText,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))
      ),
      child: TextField(
        controller: controller,
        obscureText: obscuredText,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none
        ),
      ),
    );
  }
}



