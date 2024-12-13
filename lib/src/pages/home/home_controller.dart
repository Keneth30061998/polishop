import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user.dart';

class HomeController extends GetxController{
  User user = User.fromJson(GetStorage().read('user') ?? {}); //Metodo nos permite leer informacion almacenada
  
  HomeController(){
    print('USUARIO DE SESION: ${user.toJson()}');
  }

  void signOut(){
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
  }
}