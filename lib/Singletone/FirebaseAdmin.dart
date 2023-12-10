import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ClasesFb/FbPost.dart';
import '../ClasesFb/FbUser.dart';

class FirebaseAdmin{

  FirebaseFirestore db = FirebaseFirestore.instance;
  late FbUser user;
  FbPost? selectedPost;

  //Metodo de comprobación del splash
  void checkSession(BuildContext context) async{
    await Future.delayed(Duration(seconds: 3));
    if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).popAndPushNamed("/homeview");
    }
    else{
      Navigator.of(context).popAndPushNamed("/loginview");
    }

  }

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
      TextEditingController nombreController, TextEditingController nickNameController,
      String personajeMarvelFavorito, String pokemonFavorito,BuildContext context) async {

      try {
        //Crear usuario
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );

        //Añadirle los datos al usuario
        FbUser user = FbUser(nombreCompleto: nombreController.text, nickName: nickNameController.text, personajeMarvelFavorito: personajeMarvelFavorito, pokemonFavorito: pokemonFavorito);
        //Create document with ID
        String userUid = FirebaseAuth.instance.currentUser!.uid;
        await db.collection("users").doc(userUid).set(user.toFirestore());

        Navigator.of(context).pushNamed("/loginview");

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          SnackBar(content: Text('The password provided is too weak.'));
        } else if (e.code == 'email-already-in-use') {
          SnackBar(content: Text('The account already exists for that email.'));
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

  StreamSubscription<QuerySnapshot<FbPost>>? postsSubscription;

  // Método para iniciar la escucha de posts
  void iniciarEscuchaPosts({
    required void Function(List<FbPost> posts) onData,
    required void Function(dynamic error) onError,
  }) {
    CollectionReference<FbPost> ref = db.collection("posts").withConverter(
      fromFirestore: FbPost.fromFirestore,
      toFirestore: (FbPost post, _) => post.toFirestore(),
    );

    postsSubscription = ref
        .orderBy("date", descending: true) // Ordenar por fecha descendente
        .snapshots().listen(
          (QuerySnapshot<FbPost> postsDescargados) {
        List<FbPost> posts = postsDescargados.docs
            .map((doc) {
          FbPost post = doc.data()!;
          post.id = doc.id; // Asignar el ID del documento al atributo 'id' de FbPost
          return post;
        })
            .toList(growable: false);

        onData(posts);
      },
      onError: onError,
    );
  }

  // Método para detener la escucha de posts
  void detenerEscuchaPosts() {
    postsSubscription?.cancel();
  }

  //Actualizar el nombre y apellidos
  Future<void> updateUserName_nickName(String nuevoNombre, String nuevoNickName) async {
    // Obtener el usuario actual
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Obtener el documento del usuario actual
      DocumentReference<FbUser> userDocRef = db.collection("users").doc(currentUser.uid).withConverter(
        fromFirestore: FbUser.fromFirestore,
        toFirestore: (FbUser user, _) => user.toFirestore(),
      );

      // Obtener los datos actuales del usuario
      DocumentSnapshot<FbUser> userDoc = await userDocRef.get();
      FbUser usuarioActual = userDoc.data()!;

      // Actualizar solo los atributos necesarios
      usuarioActual.nombreCompleto = nuevoNombre;
      usuarioActual.nickName = nuevoNickName;

      // Guardar los cambios en Firestore
      await userDocRef.set(usuarioActual);
    }
  }

  //Actualizar un post
  Future<void> updateBodyPost(String body, String? id) async {

      // Obtener el documento del post actual
      DocumentReference<FbPost> userDocRef = db.collection("posts").doc(id).withConverter(
        fromFirestore: FbPost.fromFirestore,
        toFirestore: (FbPost user, _) => user.toFirestore(),
      );

      // Obtener los datos actuales del post
      DocumentSnapshot<FbPost> postDoc = await userDocRef.get();
      FbPost postActual = postDoc.data()!;

      // Actualizar solo los atributos necesarios
      postActual.body = body;

      // Guardar los cambios en Firestore
      await userDocRef.set(postActual);
  }

}