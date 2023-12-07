import 'package:flutter/material.dart';

class Boton_Personalizado extends StatelessWidget{

  final Function()? onPressed;
  final String hintText;
  final bool colorPrimarios;

  const Boton_Personalizado({super.key, required this.onPressed, required this.hintText, required this.colorPrimarios,});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialButton(
      onPressed: onPressed,
      height: 50,
      color: colorPrimarios 
          ? Color.fromRGBO(108, 99, 255, 1)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: colorPrimarios 
            ? Text(hintText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
            : Text(hintText, style: TextStyle(color: Color.fromRGBO(108, 99, 255, 1), fontWeight: FontWeight.bold),),
    ),
    );
  }
}