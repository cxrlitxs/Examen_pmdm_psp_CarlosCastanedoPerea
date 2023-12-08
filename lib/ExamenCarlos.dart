import 'package:examen_pmdm_psp_carlos_castanedo_perea/Main/AjustesPerfilView.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/Main/HomeView.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/OnBoarding/CambiarPasswordView.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/OnBoarding/RegisterView.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/OnBoarding/SplashView.dart';
import 'package:flutter/material.dart';
import 'OnBoarding/LoginView.dart';

class ExamenCarlos extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    MaterialApp materialApp = MaterialApp(title: "ExamenCarlos",
    routes: {
      '/loginview': (context) => LoginView(),
      '/registerview': (context) => RegisterView(),
      '/cambiarpasswordview': (context) => CambiarPasswordView(),
      '/splashview': (context) => SplashView(),
      '/homeview': (context) => HomeView(),
      '/ajustesperfilview': (context) => AjustesPerfilView(),
    },
        initialRoute: '/ajustesperfilview',
    );
    return materialApp;
  }
}