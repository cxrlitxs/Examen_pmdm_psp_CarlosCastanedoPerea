import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../CustomViews/Boton_Personalizado.dart';
import '../CustomViews/TextFields_Personalizados.dart';
import '../Singletone/DataHolder.dart';

class PostView extends StatefulWidget{

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {

  String nickName = DataHolder().fbAdmin.selectedPost!.nickName;
  String body = DataHolder().fbAdmin.selectedPost!.body;
  String date = DataHolder().fbAdmin.selectedPost!.formattedData();

  TextEditingController bodyController = TextEditingController();

  void _editPost(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: FadeIn(
              duration: Duration(milliseconds: 1400),
              child: Text("Editar Post")),
          content: SingleChildScrollView(
            child: FadeInUp(duration: Duration(milliseconds: 1400),
                child: Container(
                  height: 200,
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
                      TextFields_Personalizados(controller: bodyController, hintText: "Cuerpo del post", obscuredText: false, height: 200,),
                    ],
                  ),
                )
            ),
          ),
          actions: [
            FadeInUp(
              duration: Duration(milliseconds: 1400),
              child:Row(
                  children :[
                    Expanded(
                      child: Boton_Personalizado(
                          onPressed: (){
                            Navigator.of(context).pop();
                            bodyController.text = body;
                          },
                          hintText: "Cancelar",
                          colorPrimarios: false
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Boton_Personalizado(
                          onPressed: (){
                            DataHolder().fbAdmin.updateBodyPost(bodyController.text, DataHolder().fbAdmin.selectedPost!.id);
                            Navigator.of(context)..pushReplacementNamed('/homeview');
                          },
                          hintText: "Confirmar",
                          colorPrimarios: true
                      ),
                    ),
                  ]
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    bodyController.text = body;
  }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build

    return Scaffold(
      appBar: AppBar(title: Row(children: [
        Text("Post de ", style: TextStyle(color: Colors.white),),
        Text(nickName, style: TextStyle(color: Colors.white),),
      ],),
        backgroundColor: Color.fromRGBO(108, 99, 255, .4),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Lógica para editar el post
              _editPost(context, );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: FadeIn(
            duration: Duration(milliseconds: 1400),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(108, 99, 255, .2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(
                            color: Color.fromRGBO(108, 99, 255, .4),
                            blurRadius: 20,
                            offset: Offset(0, 20)
                        )
                        ]
                    ),
                    margin: const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 25),
                    padding: const EdgeInsets.all(25),
                    //color: Colors.amber[iColorCode],
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nickName,style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 10,),
                                Text(body,),
                                const SizedBox(height: 10,),
                                Text(date),
                                //"$sNickName • $sDate"
                              ],
                            )
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}