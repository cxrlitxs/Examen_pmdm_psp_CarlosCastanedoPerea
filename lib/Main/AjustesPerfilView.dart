import 'package:animate_do/animate_do.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/CustomViews/Boton_Personalizado.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/Singletone/DataHolder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../CustomViews/TextFields_Personalizados.dart';

class AjustesPerfilView extends StatelessWidget{

  //Constantes
  FirebaseFirestore db = FirebaseFirestore.instance;
  final nombreController = TextEditingController();
  final nickNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Container container = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromRGBO(158, 99, 255, 1),
                Color.fromRGBO(108, 99, 255, 1),
                Color.fromRGBO(99, 190, 255, 1),
              ]
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 80,),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(duration: Duration(milliseconds: 1000), child: Text("Configuración de la cuenta", style: TextStyle(color: Colors.white, fontSize: 40),)),
                SizedBox(height: 10,),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    FadeInUp(duration: Duration(milliseconds: 1200), child: Text("Introduce los credenciales que desea cambiar", style: TextStyle(color: Colors.grey, fontSize: 20),)),
                    SizedBox(height: 30,),
                    FadeInUp(duration: Duration(milliseconds: 1400),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(108, 99, 255, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )
                              ]
                          ),
                          child: Column(
                            children: [
                              TextFields_Personalizados(controller: nombreController, hintText: "Nombre", obscuredText: false),
                              TextFields_Personalizados(controller: nickNameController, hintText: "Apodo", obscuredText: false),
                            ],
                          ),
                        )
                    ),
                    SizedBox(height: 15,),
                    FadeInUp(duration: Duration(milliseconds: 1600),
                        child: Boton_Personalizado(onPressed: (){
                          Navigator.pushReplacementNamed(context, '/homeview');
                        }, hintText: "Volver", colorPrimarios: false)
                    ),
                    SizedBox(height: 15,),
                    FadeInUp(duration: Duration(milliseconds: 1600),
                        child: Boton_Personalizado(onPressed: (){
                          DataHolder().fbAdmin.updateUserName_nickName(nombreController.text, nickNameController.text);
                          Navigator.of(context).pushNamed("/homeview");
                        }, hintText: "Modificar el perfil", colorPrimarios: true)
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );


    Scaffold scaffold = Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: container,),
        )
    );

    return scaffold;
  }

}