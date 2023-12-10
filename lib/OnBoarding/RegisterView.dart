import 'package:animate_do/animate_do.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/CustomViews/Combo_Personalizado.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/Singletone/DataHolder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../CustomViews/TextFields_Personalizados.dart';

class RegisterView extends StatefulWidget{

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //Constantes
  FirebaseFirestore db = FirebaseFirestore.instance;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();

  String itemSeleccionadoPokemon = 'Ninguno';
  String itemSeleccionadoMarvel = 'Ninguno';

  List<String> pokemons = ['Ninguno', 'Descargando Pokémons...'];
  List<String> marvel = ['Ninguno', 'Descargando personajes...'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inicializarListaPokemons();
  }

  // Método para inicializar la lista de pokemons
  void inicializarListaPokemons() {
    DataHolder().apis.obtenerTiposDePokemons().then((tiposDePokemons) {
      this.pokemons = tiposDePokemons;
      setState(() {

      });
    });

    DataHolder().apis.obtenerPersonajesMarvel().then((personajesMarvel) {
      this.marvel = personajesMarvel;
      setState(() {

      });
    });
  }

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
                FadeInUp(duration: Duration(milliseconds: 1000), child: Text("Registrarse", style: TextStyle(color: Colors.white, fontSize: 40),)),
                SizedBox(height: 10,),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          FadeInUp(duration: Duration(milliseconds: 1200), child: Text("Introduce tus credenciales", style: TextStyle(color: Colors.grey, fontSize: 20),)),
                          SizedBox(height: 30,),
                          FadeInUp(duration: Duration(milliseconds: 1400), child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                    color: Color.fromRGBO(108, 99, 255, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10)
                                )]
                            ),
                            child: Column(
                              children: [
                                TextFields_Personalizados(controller: usernameController, hintText: "Email", obscuredText: false),
                                TextFields_Personalizados(controller: passwordController, hintText: "Contraseña", obscuredText: true),
                                TextFields_Personalizados(controller: rePasswordController, hintText: "Repite la contraseña", obscuredText: true),
                                TextFields_Personalizados(controller: nameController, hintText: "Nombre completo", obscuredText: false),
                                TextFields_Personalizados(controller: nicknameController, hintText: "Apodo", obscuredText: false),
                                MyCombo(options: pokemons, text: "Selecciona tu Pokémon favorito", onItemSelected: (selectedItem) {
                                  itemSeleccionadoPokemon = selectedItem;
                                },),
                                MyCombo(options: marvel, text: "Selecciona tu peronaje de Marvel favorito", onItemSelected: (selectedItem) {
                                  itemSeleccionadoMarvel = selectedItem;
                                },),
                              ],
                            ),
                          )),
                          SizedBox(height: 30,),
                          FadeInUp(duration: Duration(milliseconds: 1500),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("¿Ya tienes una cuenta?", style: TextStyle(color: Colors.grey),),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pushNamed("/loginview");
                                      },
                                      child: Text("¡Inicia sesión!", style: TextStyle(color: Color.fromRGBO(108, 99, 255, 1)),),
                                    )
                                  ],
                                ),
                              )
                          ),
                          SizedBox(height: 30,),
                          FadeInUp(duration: Duration(milliseconds: 1600), child: MaterialButton(
                            onPressed: () {
                              if(passwordController.text == rePasswordController.text){
                                DataHolder().fbAdmin.onClickRegistar(passwordController, usernameController, nameController, nicknameController, itemSeleccionadoMarvel, itemSeleccionadoPokemon, context);
                              }
                              else {
                                SnackBar(content: Text("Las contraseñas no son iguales"));
                              }
                            },
                            height: 50,
                            color: Color.fromRGBO(108, 99, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text("Registrarse", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
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