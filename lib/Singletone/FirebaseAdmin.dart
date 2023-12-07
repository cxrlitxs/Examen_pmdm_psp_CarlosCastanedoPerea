import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ClasesFb/FbPost.dart';
import '../ClasesFb/FbUser.dart';

class FirebaseAdmin{

  FirebaseFirestore db = FirebaseFirestore.instance;
  late FbUser user;
  FbPost? selectedPost;

  //Cargar un usuario
  Future<FbUser?> loadFbUser() async{
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference<FbUser> ref = db.collection("users")
        .doc(uid)
        .withConverter(fromFirestore: FbUser.fromFirestore,
      toFirestore: (FbUser user, _) => user.toFirestore(),);

    DocumentSnapshot<FbUser> docSnap=await ref.get();
    user=docSnap.data()!;
    return user;
  }

  //Insertar un post
  Future<void> insertPostInFB(FbPost newPost) async {
    CollectionReference<FbPost> postsRef = db.collection("posts")
        .withConverter(
      fromFirestore: FbPost.fromFirestore,
      toFirestore: (FbPost post, _) => post.toFirestore(),
    );

    await postsRef.add(newPost);
  }

  //Inicio de sesion de un usuario
  Future<void> onClickSignIn(TextEditingController usernameController, TextEditingController passwordController, BuildContext context) async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text
      );

      FbUser? user= await loadFbUser();

      print("EL NICKNAME DEL USUARIO LOGEADO ES: "+user!.nickName);
      Navigator.of(context).popAndPushNamed("/homeview");

    } on FirebaseAuthException catch (e) {

      print('No user found for that email.');
      if (e.code == 'user-not-found') {
        SnackBar(content: Text('Correo no encontrado'));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        SnackBar(content: Text('Contraseña incorrecta',));
        print('Wrong password provided for that user.');
      }else if(e.code == 'user-not-found' && e.code == 'wrong-password'){
        SnackBar(content: Text('Correo y contraseña incorrecta',));
        print('No user found & wrong password.');
      }
    }

  }

  //Registrar a un usuario
  Future<void> onClickRegistar(TextEditingController passwordController, TextEditingController usernameController,
      TextEditingController nombreController, TextEditingController nickNameController, BuildContext context) async {

      try {
        //Crear usuario
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );

        //Añadirle los datos al usuario
        FbUser user = FbUser(nombreCompleto: nombreController.text, nickName: nickNameController.text,);
        //Create document with ID
        String userUid = FirebaseAuth.instance.currentUser!.uid;
        await db.collection("users").doc(userUid).set(user.toFirestore());

        Navigator.of(context).pushNamed("/loginview");

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
  }

  //Subir un post
  Future<void> onClickPost(TextEditingController tecBody, BuildContext context) async {
    try {

      //-----------------------INICIO DE SUBIR POST--------
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> datos = await db.collection("users").doc(uid).get();
      String nickName =  datos.data()?['nickName'];

      FbPost newPost = FbPost(nickName: nickName, body: tecBody.text, date: Timestamp.now());

      insertPostInFB(newPost);
      //-----------------------FIN DE SUBIR POST--------

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Publicación  agregada exitosamente'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacementNamed(context, '/homeview');

    } catch (e) {
      print("Error al agregar el post: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La publicación no se pudo agregar'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}