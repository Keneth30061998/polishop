import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/Rol.dart';
import '../../models/user.dart';

class RolesController extends GetxController{
    User user = User.fromJson(GetStorage().read('user') ?? {});

    //Metodo que nos permite movernos entres pantrallas
    void goToPageRol(Rol rol){
        print("_____________________________________");
        print(rol.route);
        print("---------------------------------------");
        Get.offNamedUntil(rol.route ?? '', (route) => false);
    }
}