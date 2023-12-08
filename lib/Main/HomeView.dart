import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../ClasesFb/FbPost.dart';
import '../CustomViews/PostCellView.dart';
import '../CustomViews/PostGridCellView.dart';
import '../Singletone/DataHolder.dart';

class HomeView extends StatefulWidget{
  @override
  // TODO: implement build
  State<HomeView> createState() => _HomeViewState();
}


class _HomeViewState extends State<HomeView> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<FbPost> posts = [];
  bool bIsList = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Iniciar la escucha de posts
    DataHolder().fbAdmin.iniciarEscuchaPosts(
      onData: (List<FbPost> updatedPosts) {
        setState(() {
          posts = updatedPosts;
        });
      },
      onError: (error) {
        print("Error en la escucha de posts: $error");
      },
    );
  }

  @override
  void dispose() {
    // Detener la escucha de posts al cerrar la vista
    DataHolder().fbAdmin.detenerEscuchaPosts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("POSTS", style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromRGBO(108, 99, 255, .4),
        centerTitle: true,
      ), body: cellsOList(bIsList),
    );
  }

  //Creador del item
  Widget? itemListCreator(BuildContext context, int index){
    return PostCellView(
      sNickName: posts[index].nickName,
      sBody: posts[index].body,
      sDate: posts[index].formattedData(),
      dFontSize: 20,
      iColorCode: 0,
      iPosition: index,
      onItemListClickedFun: onItemListClicked,
    );
  }

  Widget? matrixItemCreator(BuildContext context, int index){
    return PostGridCellView(
      sNickName: posts[index].nickName,
      sBody: posts[index].body,
      sDate: posts[index].formattedData(),
      dFontSize: 20,
      iColorCode: 0,
      iPosition: index,
      onItemListClickedFun: onItemListClicked,
    );
  }

  void onItemListClicked(int index){
    DataHolder().fbAdmin.selectedPost = posts[index];
    Navigator.of(context).pushNamed("/postview");
  }

  //Separador de los posts
  Widget listSeparatorCreator(BuildContext context, int index) {
    //return Divider(thickness: 5,);
    return Column(
      children: [
        Divider(
          thickness: 0.5,
          color: Colors.grey[400],
        ),
        //CircularProgressIndicator(),
      ],
    );
  }

  Widget cellsOList(bool isList) {

    if (isList) {
      return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: posts.length,
        itemBuilder: itemListCreator,
        separatorBuilder: listSeparatorCreator,
      );
    } else {
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: posts.length,
          itemBuilder: matrixItemCreator
      );
    }
  }

}