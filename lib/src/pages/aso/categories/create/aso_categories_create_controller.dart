import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/models/category.dart';
import 'package:poli_shop/src/models/response_api.dart';
import 'package:poli_shop/src/providers/categories_provider.dart';

class AsoCategoriesCreateController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  //METODO PARA CREAR LA CATEGORIA -> BOTON
  void createCategory() async {
    String name = nameController.text;
    String description = descriptionController.text;

    //VALIDACIONES DE LOS CAMPOS
    if (name.isNotEmpty && description.isNotEmpty) {
      Category category = Category(
        name: name,
        description: description,
      );
      ResponseApi responseApi = await categoriesProvider.create(category);
      Get.snackbar('Proceso Terminado', responseApi.message ?? '');
      //Condicion para verificar si se creo una categoria
      if(responseApi.success == true){
        clearForm();
      }
    } else {
      Get.snackbar('Formulario invalido',
          'Ingrese todos los campos para generar la categoria');
    }
  }

  //METODO PARA LIMPIAR LOS CAMPOS
  void clearForm(){
    nameController.text='';
    descriptionController.text='';
  }
}
