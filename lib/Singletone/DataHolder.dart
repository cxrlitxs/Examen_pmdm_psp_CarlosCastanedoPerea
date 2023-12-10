import 'package:examen_pmdm_psp_carlos_castanedo_perea/Singletone/HttpAdmin.dart';

import 'FirebaseAdmin.dart';

class DataHolder{

  static final DataHolder _dataHolder = DataHolder._internal();

  DataHolder._internal() {}

  factory DataHolder(){
    return _dataHolder;
  }

  FirebaseAdmin fbAdmin = FirebaseAdmin();
  HttpAdmin apis = HttpAdmin();

}