import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/CustomViews/Boton_Personalizado.dart';
import 'package:examen_pmdm_psp_carlos_castanedo_perea/CustomViews/BottomMenu_Personalizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
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
  bool bIsList = true;
  final _advancedDrawerController = AdvancedDrawerController();

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

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(child: FadeInUp(duration: Duration(milliseconds: 1200), child: Text("¿Deseas cerrar la sesión?", style: TextStyle(color: Colors.white, fontSize: 22),))),
          actions: [
          FadeInUp(
            duration: Duration(milliseconds: 1400),
              child:Row(
                children :[
                  Expanded(
                    child: Boton_Personalizado(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        hintText: "Cancelar",
                        colorPrimarios: false
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Boton_Personalizado(
                        onPressed: signOut,
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

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/loginview');
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AdvancedDrawer(
      backdrop: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      openRatio: 0.60,
      openScale: 0.9,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
    drawer: SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 128.0,
                    height: 128.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 64.0,
                      ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                      ),
                    child: Text("Hola"),
                    ),
                    ListTile(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/homeview');
                    },
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    ),
                    ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed("/ajustesperfilview");
                    },
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Settings'),
                    ),
                    ListTile(
                    onTap: (){
                      _showLogoutConfirmationDialog(context);
                      },
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar sesión'),
                    ),
                ],
              ),
            ),
          ),
        ), child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: const Text("POSTS", style: TextStyle(color: Colors.white),),
                backgroundColor: Color.fromRGBO(108, 99, 255, .4),
                centerTitle: true,
                leading: IconButton(
                  onPressed: _handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                          child: Icon(
                          value.visible ? Icons.clear : Icons.menu,
                          key: ValueKey<bool>(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
              ), body: cellsOList(bIsList),
              bottomNavigationBar: BottomMenu_Personalizado(onBotonesClicked: onBottonMenuPressed),
              floatingActionButton: FadeIn(
                duration: Duration(milliseconds: 1600),
                child: FloatingActionButton(
                  backgroundColor: Color.fromRGBO(108, 99, 255, .4),
                  onPressed: onClickNewPost,
                  tooltip: 'Nueva publicación ',
                  child: const Icon(Icons.add),
                ),
              ),
           ),
    );
  }

  void onClickNewPost() {
    Navigator.pushReplacementNamed(context, '/newpostview');
  }

  //Creador del item
  Widget? itemListCreator(BuildContext context, int index){
    return PostCellView(
      sNickName: posts[index].nickName,
      sBody: posts[index].body,
      sDate: posts[index].formattedData(),
      sId: posts[index].id,
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
      sId: posts[index].id,
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

  void onBottonMenuPressed(int indice) {

    setState(() {
      if(indice == 0){
        bIsList=true;
      }
      else if(indice==1){
        bIsList=false;
      }
    });
  }

}