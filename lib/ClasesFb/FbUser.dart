import 'package:cloud_firestore/cloud_firestore.dart';

class FbUser {

  String nombreCompleto;
  String nickName;
  String pokemonFavorito;
  String personajeMarvelFavorito;

  FbUser ({
    required this.nombreCompleto,
    required this.nickName,
    required this.pokemonFavorito,
    required this.personajeMarvelFavorito,
  });

  factory FbUser.fromFirestore (
      DocumentSnapshot <Map <String, dynamic> > snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FbUser(
      nombreCompleto: data?['nombreCompleto'] != null ? data!['nombreCompleto'] : "",
      nickName: data?['nickName'] != null ? data!['nickName'] : "",
      pokemonFavorito: data?['pokemonFavorito'] != null ? data!['pokemonFavorito'] : "",
      personajeMarvelFavorito: data?['personajeFavorito'] != null ? data!['personajeFavorito'] : "",
    );
  }

  Map <String, dynamic> toFirestore() {
    return {
      if (nombreCompleto != null) "nombreCompleto": nombreCompleto,
      if (nickName != null) "nickName": nickName,
      if (pokemonFavorito != null) "pokemonFavorito": pokemonFavorito,
      if (personajeMarvelFavorito != null) "personajeFavorito": personajeMarvelFavorito,
    };
  }
}