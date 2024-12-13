import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poli_shop/src/models/response_api.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../models/user.dart';
import '../../../../providers/users_provider.dart';
import '../info/client_profile_info_controller.dart';

class ClientProfileUpdateController extends GetxController{

  //Datos cargados en el update page
  User user = User.fromJson(GetStorage().read('user'));

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  //instancias para subir imagenes -> imagepicker
  ImagePicker  picker = ImagePicker();
  File? imageFile;

  //Provider para actualizar el usuario
  UserProvider userProvider = UserProvider();

  //Intaciar el controller de info para cargar los cambios
  ClientProfileInfoController clientProfileInfoController = Get.find();

  //Constructor para cargar datos: nombre, apellido, phone
  ClientProfileUpdateController(){
    nameController.text = user.name ?? '';
    lastnameController.text = user.lastname ?? '';
    phoneController.text = user.phone ?? '';
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

  //Validaciones de los text
  bool isValidForm(String name, String lastname, String phone) {

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

    return true;
  }

  //Metodo para realizar el registro actualizado
  void updateInfo(BuildContext context) async {

    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;


    if (isValidForm(name, lastname, phone,)) {

      //Herramienta progres dialog para cargar datos del cliente registrado
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando Datos...',progressValueColor: Colors.redAccent);

      User myUser = User(
          id: user.id,
          name: name,
          lastname: lastname,
          phone: phone,
          sessionToken: user.sessionToken
      );

      if(imageFile==null){ //Validacion para comprobar si el usuario actualizo la imagen o no
        ResponseApi responseApi = await userProvider.update(myUser);
        print('Response Api Update: ${responseApi.data}');
        Get.snackbar('Proceso Terminado', responseApi.message ?? '');
        progressDialog.close();
        if(responseApi.success == true){
          //usamos GetStorage para almacenar al usuario actualizado
          GetStorage().write('user', responseApi.data);
          clientProfileInfoController.user.value = User.fromJson(responseApi.data);
        }
      }else{
        Stream stream = await userProvider.updateWithImage(myUser, imageFile!);
        stream.listen((res) {

          //Una vez cargado retirar el progress Dialog
          progressDialog.close();

          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          Get.snackbar('Proceso Terminado', responseApi.message ?? '');
          print('Response Api Update: ${responseApi.data}');
          if(responseApi.success ==true){
            //usamos GetStorage para almacenar al usuario actualizado
            GetStorage().write('user', responseApi.data);
            clientProfileInfoController.user.value = User.fromJson(responseApi.data);
          }else{
            Get.snackbar('Resgistro Fallido', responseApi.message ?? '');
          }
        });
      }


      //Response response = await userProvider.create(user);
      //print('RESPONSE: ${response.body}');
      /**/

    }
  }
}