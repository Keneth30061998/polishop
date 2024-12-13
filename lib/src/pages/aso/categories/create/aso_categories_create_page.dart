import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/pages/aso/categories/create/aso_categories_create_controller.dart';

class AsoCategoriesCreatePage extends StatelessWidget {

  AsoCategoriesCreateController con = Get.put(AsoCategoriesCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundCover(context),
          _body(context),
        ],
      ),
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
        _textNewCategory(),
        Flexible(
          child: _boxFrom(context),
        ),
      ],
    );
  }

  //Formulario de Login
  Widget _boxFrom(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      padding: const EdgeInsets.all(25),
      margin: EdgeInsets.only(
        top: 15,
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
        'INGRESE DATOS DE LA CATEGORIA',
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

  Widget _textFieldDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: con.descriptionController,
        keyboardType: TextInputType.emailAddress,
        maxLines: 4,
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
        onPressed: () {
          con.createCategory();
        },
        child: const Text(
          'CREAR CATEGORIA',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  //Widget texto titulo
  Widget _textNewCategory() {
    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Icon(Icons.category, size: 120,color: Colors.white,),
            Text('NUEVA CATEGORIA',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,),),
          ],
        ),
      ),
    );
  }
}
