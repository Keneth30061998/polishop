import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poli_shop/src/models/response_api.dart';
import 'package:poli_shop/src/providers/users_provider.dart';

import '../../models/user.dart';

class LoginController extends GetxController{
  User user = User.fromJson(GetStorage().read('user') ?? {});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Para el login
  UserProvider userProvider = UserProvider();

  void goToRegisterPage(){
    Get.toNamed('/register');
  }


  void login()async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');

    if(isValidForm(email,password)){

      ResponseApi responseApi = await userProvider.login(email, password);
      
      print('Response Api: ${responseApi.toJson()}');

      //Iniciar sesion
      if(responseApi.success==true){
        Get.snackbar('Login Exitoso', responseApi.message ?? '');
        //Para guardar los datos del inicio de sesion
        GetStorage().write('user', responseApi.data); //DATOS USUARIO EN SESION
        //goToHomePage(); //Llamada metodo para pasar a la a siguiente pantalla
        User myUser = User.fromJson(GetStorage().read('user') ?? {});
        print('Roles length: ${user.roles!.length}');

        if(myUser.roles!.length >1){
          goToRolesPage();
        }else{
          goToClientHomePage();
        }

      }else{
        Get.snackbar('Login Fallido', responseApi.message ?? '');
      }
      //fin Inicias Sesison
    }
  }

  //METODO PARA IR AL HOMEPAGE
  void goToHomePage(){
    Get.offNamedUntil('/home', (route) => false);
  }
  //METODO PARA SELECICONAR ROLES
  void goToRolesPage(){
    Get.offNamedUntil('/roles', (route) => false);
  }
  //Metodo para ir a ClientProducti
  void goToClientHomePage() {
    Get.offNamedUntil('/client/home', (route) => false);
  }

  bool isValidForm(String email, String password){

    if(!GetUtils.isEmail(email)){
      Get.snackbar('Formulario no válido', 'Error en el campo email');
      return false;
    }

    if (email.isEmpty){
      Get.snackbar('Fomulario no válido', 'Ingrese informacion correcta');
      return false;
    }
    if(password.isEmpty){
      Get.snackbar('Fomulario no válido', 'Error en el campo password');
      return false;
    }
    return true;
  }
}