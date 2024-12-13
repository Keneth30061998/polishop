import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/models/category.dart';
import 'aso_products_create_controller.dart';

class AsoProductsCreatePage extends StatelessWidget {
  AsoProductsCreateController con = Get.put(AsoProductsCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          _backgroundCover(context),
          _body(context),
        ],
      ),),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.30,
      color: Colors.redAccent,
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        _textNewProduct(),
        Flexible(
          child: _boxFrom(context),
        ),
      ],
    );
  }

  //Formulario de Create Product
  Widget _boxFrom(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.only(
        top: 10,
        right: 25,
        left: 25,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            offset: Offset(0, 0.75),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldName(),
            _textFieldDescription(),
            _textFieldPrice(),
            _carreteImage(context),
            _dropDownCategories(con.categories),
            _buttonCreate(context),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 18),
      child: const Text(
        'INGRESA DATOS DEL PRODUCTO',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
            hintText: 'Nombre', prefixIcon: Icon(Icons.category)),
      ),
    );
  }

  Widget _textFieldPrice() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: con.priceController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            hintText: 'Precio',
            prefixIcon: Icon(Icons.monetization_on_rounded)),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: con.descriptionController,
        keyboardType: TextInputType.emailAddress,
        maxLines: 2,
        decoration: InputDecoration(
          hintText: 'Descripcion',
          prefixIcon: Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Icon(Icons.description),
          ),
        ),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          con.createProduct(context);
        },
        child: const Text(
          'CREAR PRODUCTO',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // card imagen
  Widget _cardImage(BuildContext context, File? imageFile, int numberFile) {
    return GestureDetector(
        onTap: () => con.showAlertDialog(context, numberFile),
        child: imageFile != null
            ? Card(
                elevation: 3,
                child: Container(
                  color: Colors.white70,
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Card(
                elevation: 3,
                child: Container(
                  color: Colors.white70,
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: const Image(
                    image: AssetImage('assets/img/image_cover.png'),
                  ),
                ),
              ));
  }

  // Carrete de 3 imagenes
  Widget _carreteImage(BuildContext context) {
    return GetBuilder<AsoProductsCreateController>(
      builder: (value) => Container(
        margin: EdgeInsets.only(top: 15, bottom: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _cardImage(context, con.imageFile1, 1),
              _cardImage(context, con.imageFile2, 2),
              _cardImage(context, con.imageFile3, 3),
            ],
          ),
        ),
      ),
    );
  }

  //Listar Categorias
  List<DropdownMenuItem<String?>> _dropDownItem(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(category.name ?? ''),
        value: category.id,
      ));
    });
    return list;
  }

  //WIDGET DE LISTAR
  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.redAccent,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Selecciona una categoria',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        items: _dropDownItem(categories),
        value: con.idCategory.value == '' ? null : con.idCategory.value,
        onChanged: (option){
          print('Opcion seleccionada:  ${option}');
          con.idCategory.value = option.toString();
        },
      ),
    );
  }

  //Widget texto titulo
  Widget _textNewProduct() {
    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Icon(
              Icons.checkroom_outlined,
              size: 75,
              color: Colors.white,
            ),
            Text(
              'NUEVO PRODUCTO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
