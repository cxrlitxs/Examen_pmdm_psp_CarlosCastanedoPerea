import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashViewState();
  }
}


class _SplashViewState extends State<SplashView>{

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(duration: Duration(milliseconds: 1000), child: Text("¡Bienvenido!", style: TextStyle(color: Colors.white, fontSize: 40),)),
                  SizedBox(height: 1,),
                ],
              ),
            ),
            FadeInUp(duration: Duration(milliseconds: 1200), child: Text("Cargando...", style: TextStyle(color: Colors.white, fontSize: 20),)),
            const SizedBox(height: 30,),
            FadeInUp(duration: Duration(milliseconds: 1400),child: CircularProgressIndicator()),
      ],
     ),
    );

    Scaffold scaffold = Scaffold(backgroundColor: Colors.grey[300],
        body: Center(
            child: container,),
    );

    return scaffold;
  }

}