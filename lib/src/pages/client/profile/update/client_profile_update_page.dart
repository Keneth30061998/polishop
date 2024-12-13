import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/pages/client/profile/update/client_profile_update_controller.dart';

class ClientProfileUpdatePage extends StatelessWidget {

  ClientProfileUpdateController con = Get.put(ClientProfileUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundCover(context),
          _body(context),
          _buttonBack(),
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
        _imageUser(context),
        Flexible(
          child: _boxFrom(context),
        ),
        /*
        Expanded y ajusta los márgenes y tamaños relativos
        para mejorar la responsividad del diseño en diferentes tamaños de pantalla
         */
      ],
    );
  }

  //Formulario de Login
  Widget _boxFrom(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.50,
      padding: const EdgeInsets.all(25),
      margin: EdgeInsets.only(top: 15, right: 25, left: 25, ),
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
            _textFieldLastName(),
            _textFieldPhone(),
            _buttonUpdate(context),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 18),
      child: const Text(
        'INGRESA DATOS PERSONALES',
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
            hintText: 'Nombre', prefixIcon: Icon(Icons.person)),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: con.lastnameController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
            hintText: 'Apellido', prefixIcon: Icon(Icons.person_outline)),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
            hintText: 'Teléfono', prefixIcon: Icon(Icons.call)),
      ),
    );
  }

  Widget _buttonUpdate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
            return con.updateInfo(context);
        },
        child: const Text(
          'ACTUALIZAR',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  //Boton regresp
  Widget _buttonBack() {
    return SafeArea(
      child: Container(
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //Widget imagen
  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 40),
        child: GestureDetector(
          onTap: () {
            return con.showAlertDialog(context);
          },
          child: GetBuilder<ClientProfileUpdateController>(
            builder: (value) => CircleAvatar(
              backgroundImage: con.imageFile != null
                  ? FileImage(con.imageFile!)
                  : con.user.image != null 
                  ? NetworkImage(con.user.image!)
                    :const AssetImage('assets/img/llama_profile.png') as ImageProvider,
              radius: 75,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ),
      ),
    );
  }
}
