import 'package:cloud_firestore/cloud_firestore.dart';

class FbUser {

  String nombreCompleto;
  String nickName;

  FbUser ({
    required this.nombreCompleto,
    required this.nickName,
  });

  factory FbUser.fromFirestore (
      DocumentSnapshot <Map <String, dynamic> > snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FbUser(
      nombreCompleto: data?['nombreCompleto'] != null ? data!['nombreCompleto'] : "",
      nickName: data?['nickName'] != null ? data!['nickName'] : "",
    );
  }

  Map <String, dynamic> toFirestore() {
    return {
      if (nombreCompleto != null) "nombreCompleto": nombreCompleto,
      if (nickName != null) "nickName": nickName,
    };
  }
}