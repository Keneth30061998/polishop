import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poli_shop/src/models/category.dart';
import 'package:poli_shop/src/models/product.dart';
import 'package:poli_shop/src/models/response_api.dart';
import 'package:poli_shop/src/providers/categories_provider.dart';
import 'package:poli_shop/src/providers/products_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AsoProductsCreateController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();
  ProductsProvider productsProvider = ProductsProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  var idCategory=''.obs;
  List<Category> categories = <Category>[].obs;

  void getCategories()async{
    var result  = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  //Para que se muestren: llamar desde el cosntructor
  AsoProductsCreateController(){
    getCategories();
  }

  //METODO PARA CREAR EL PRODUCTO -> BOTON
  void createProduct(BuildContext context) async {
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;
    print('Name: ${name}');
    print('Description: ${description}');
    print('Price: ${price}');
    print('ID Category: ${idCategory}');
    //CREAR UN PROGRESSDIALOG MIENTRAS SE SUBE UNA IMAGEN
    ProgressDialog progressDialog = ProgressDialog(context: context);
    //VALIDACIONES DE LOS CAMPOS
    if (isValidForm(name, description, price)) {
      Product product = Product(
        name: name,
        description: description,
        price: double.parse(price),
        idCategory: idCategory.value,
      );
      //MOSTRAR DIALOGO CARGANDO
      progressDialog.show(max: 100,msg: 'Registrando Producto...');
      List<File> images = [];
      images.add(imageFile1!);
      images.add(imageFile2!);
      images.add(imageFile3!);
      Stream stream = await productsProvider.create(product, images);
      stream.listen((res) { 
        progressDialog.close();
        
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        Get.snackbar('Proceso Terminado', responseApi.message ?? '');
        if(responseApi.success == true){
          clearForm();
        }
      });
    }
  }

  //METODO PARA VALIDAR LOS CAMPOS DEL FORMULARIO DE INGRESO DE PRODUCTOS
  bool isValidForm(String name, String description, String price){
    if(name.isEmpty){
      Get.snackbar('Formulario no válido', 'Ingrese nombre del producto');
      return false;
    }
    if(description.isEmpty){
      Get.snackbar('Formulario no válido', 'Ingrese descripción del producto');
      return false;
    }
    if(price.isEmpty){
      Get.snackbar('Formulario no válido', 'Ingrese precio del producto');
      return false;
    }
    if(idCategory.value == ''){
      Get.snackbar('Formulario no válido', 'Seleccione una categoria para el producto');
      return false;
    }

    if(imageFile1 == null ){
      Get.snackbar('Formulario no válido', 'Seleccione imagen 1 del producto');
      return false;
    }
    if(imageFile2 == null ){
      Get.snackbar('Formulario no válido', 'Seleccione imagen 2 del producto');
      return false;
    }
    if(imageFile3 == null ){
      Get.snackbar('Formulario no válido', 'Seleccione imagen 3 del producto');
      return false;
    }
    return true;
  }

  //Metodos diseñados para acceder a la camara - galleria - otros recursos
  void showAlertDialog(BuildContext context, int numberFile) {
    Widget galleryButtom = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery,numberFile);
      },
      child: const Text('Galería'),
    );
    Widget cameraButtom = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera, numberFile);
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
  Future selectImage(ImageSource imageSource, int numbreFile) async{
    XFile? image = await picker.pickImage(source: imageSource);
    if(image != null){

      if(numbreFile==1){
        imageFile1 = File(image.path);
      }else if(numbreFile==2){
        imageFile2 = File(image.path);
      }else if(numbreFile==3){
        imageFile3 = File(image.path);
      }
      update();
    }
  }

  //METODO PARA LIMPIAR LOS CAMPOS
  void clearForm(){
    nameController.text='';
    descriptionController.text='';
    priceController.text='';
    imageFile1 = null;
    imageFile2= null;
    imageFile3=null;
    idCategory.value='';
    update();
  }
}
