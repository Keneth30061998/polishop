import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poli_shop/src/models/response_api.dart';
import 'package:poli_shop/src/models/user.dart';
import 'package:poli_shop/src/providers/users_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  //Manejo del provider para enviar datos
  UserProvider userProvider = UserProvider();

  //instancias para subir imagenes -> imagepicker
  ImagePicker  picker = ImagePicker();
  File? imageFile;

  //Metodo para hacer el registro de cliente
  void register(BuildContext context) async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    String password = passwordController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();

    if (isValidForm(email, name, lastname, phone, password, confirmpassword)) {

      //Herramienta progres dialog para cargar datos del cliente registrado
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Registrando Datos...',progressValueColor: Colors.redAccent);

      User user = User(
          email: email,
          name: name,
          lastname: lastname,
          phone: phone,
          password: password);

      //Response response = await userProvider.create(user);
      //print('RESPONSE: ${response.body}');
      Stream stream = await userProvider.createWithImage(user, imageFile!);
      stream.listen((res) {

        //Una vez cargado retirar el progress Dialog
        progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        if(responseApi.success ==true){
          Get.snackbar('Fomulario Válido', 'Registrando usuario....');
          GetStorage().write('user', responseApi.data); //DATOS USUARIO EN SESION
          goToHomePage(); //Llamada metodo para pasar a la a siguiente pantalla
        }else{
          Get.snackbar('Resgistro Fallido', responseApi.message ?? '');
        }
      });

    }
  }

  //METODO PARA IR AL HOMEPAGE
  void goToHomePage(){
    Get.offNamedUntil('/client/products/list', (route) => false);
  }

  bool isValidForm(String email, String name, String lastname, String phone,
      String password, String confirmpassword) {
    if (email.isEmpty) {
      Get.snackbar(
          'Formulario no valido', 'Ingrese informacion en el campo Email');
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Formulario no válido', 'Informacion de Email incorrecta');
      return false;
    }

    if (name.isEmpty) {
      Get.snackbar(
          'Formulario no valido', 'Ingrese informacion en el campo nombre');
      return false;
    }
    if (!GetUtils.isUsername(name)) {
      Get.snackbar('Formulario no válido', 'Informacion de Nombre incorrecta');
      return false;
    }
    if (lastname.isEmpty) {
      Get.snackbar(
          'Formulario no valido', 'Ingrese informacion en el campo Apellido');
      return false;
    }
    if (!GetUtils.isUsername(lastname)) {
      Get.snackbar(
          'Formulario no válido', 'Informacion de Apellido incorrecta');
      return false;
    }
    if (phone.isEmpty) {
      Get.snackbar(
          'Formulario no valido', 'Ingrese informacion en el campo Teléfono');
      return false;
    }
    if (!GetUtils.isPhoneNumber(phone)) {
      Get.snackbar(
          'Formulario no válido', 'Informacion de Teléfono incorrecta');
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar(
          'Formulario no valido', 'Ingrese informacion en el campo Contraseña');
      return false;
    }
    if (confirmpassword.isEmpty) {
      Get.snackbar('Formulario no valido',
          'Ingrese informacion en el campo Confirmar Contraseña');
      return false;
    }
    if (password != confirmpassword) {
      Get.snackbar('Formilario no valido', 'Contraseñas no coinciden');
      return false;
    }

    if(imageFile == null){
      Get.snackbar('Formilario no valido', 'Imagen no seleccionada');
      return false;
    }
    return true;
  }

  //Metodos diseñados para acceder a la camara - galleria - otros recursos
  void showAlertDialog(BuildContext context) {
    Widget galleryButtom = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);
      },
      child: const Text('Galería'),
    );
    Widget cameraButtom = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera);
      },
      child: const Text('Cámara'),
    );
    AlertDialog alertDialog = AlertDialog(
      title: const Text('Seleccione una opción'),
      actions: [
        galleryButtom,
        cameraButtom,
      ],
    );
    showDialog(context: context, builder: (BuildContext context){return alertDialog;});
  }

  //Para añadir imagenes
  Future selectImage(ImageSource imageSource) async{
    XFile? image = await picker.pickImage(source: imageSource);
    if(image != null){
      imageFile = File(image.path);
      update();
    }
  }
}
