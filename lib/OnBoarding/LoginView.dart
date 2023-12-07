import 'package:animate_do/animate_do.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/CustomViews/Boton_Personalizado.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/Singletone/DataHolder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../CustomViews/TextFields_Personalizados.dart';

class LoginView extends StatelessWidget{

  //Constantes
  FirebaseFirestore db = FirebaseFirestore.instance;
  final correoController = TextEditingController();
  final passwordController = TextEditingController();

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
                FadeInUp(duration: Duration(milliseconds: 1000), child: Text("¡Bienvenido!", style: TextStyle(color: Colors.white, fontSize: 40),)),
                SizedBox(height: 10,),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60),)
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    SizedBox(height: 40,),
                    FadeInUp(duration: Duration(milliseconds: 1200), child: Text("Introduce tus credenciales", style: TextStyle(color: Colors.grey, fontSize: 20),)),
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
                              TextFields_Personalizados(controller: correoController, hintText: "Email", obscuredText: false),
                              TextFields_Personalizados(controller: passwordController, hintText: "Contraseña", obscuredText: true),
                          ],
                        ),
                      )
                    ),
                    SizedBox(height: 15,),
                    FadeInUp(duration: Duration(milliseconds: 1500),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: (){
                                  Navigator.of(context).pushNamed("/cambiarpasswordview");
                                },
                                child: Text("¿Olvidaste la contraseña?", style: TextStyle(color: Color.fromRGBO(108, 99, 255, 1)),),
                              )
                            ],
                          ),
                        )
                    ),
                    SizedBox(height: 15,),
                    FadeInUp(duration: Duration(milliseconds: 1600),
                        child: Boton_Personalizado(onPressed: (){
                          DataHolder().fbAdmin.onClickSignIn(correoController, passwordController, context);
                        }, hintText: "Iniciar sesión", colorPrimarios: true)
                    ),
                    SizedBox(height: 30,),
                    FadeInUp(duration: Duration(milliseconds: 1500),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("¿No tienes una cuenta?", style: TextStyle(color: Colors.grey),),
                              TextButton(
                                onPressed: (){
                                  Navigator.of(context).pushNamed("/registerview");
                                },
                                child: Text("¡Registrate!", style: TextStyle(color: Color.fromRGBO(108, 99, 255, 1)),),
                              )
                            ],
                          ),
                        )
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