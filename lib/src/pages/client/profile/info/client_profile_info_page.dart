import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/pages/client/profile/info/client_profile_info_controller.dart';

class ClientProfileInfoPage extends StatelessWidget {
  ClientProfileInfoController con = Get.put(ClientProfileInfoController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            _backgroundCover(context),
            _body(context),
            _buttonSignOut(),
          ],
        ),
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
        Expanded(
          child: _boxFrom(context),
        ),
        /*
        Expanded y ajusta los márgenes y tamaños relativos
        para mejorar la responsividad del diseño en diferentes tamaños de pantalla
         */
      ],
    );
  }

  //Datos Profile
  Widget _boxFrom(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.only(
          right: 30,
          left: 30,
          top: 20,
          bottom: MediaQuery.of(context).size.height * 0.17),
      height: MediaQuery.of(context).size.height * 0.33,
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
            _textName(),
            _textEmail(),
            _textPhone(),
            _buttonUpdate(context),
          ],
        ),
      ),
    );
  }

  Widget _textName() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(
              '${con.user.value.name ?? ''} ${con.user.value.lastname ?? ''}  '),
          subtitle: const Text('Nombre de Usuario'),
        ));
  }

  Widget _textEmail() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListTile(
          leading: const Icon(Icons.email),
          title: Text(con.user.value.email ?? ''),
          subtitle: const Text('Email'),
        ));
  }

  Widget _textPhone() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListTile(
          leading: const Icon(Icons.call),
          title: Text(con.user.value.phone ?? ''),
          subtitle: const Text('Teléfono'),
        ));
  }

  Widget _buttonUpdate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          return con.goToProfileUpdate();
        },
        child: const Text(
          'ACTUALIZAR DATOS',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  //Widget imagen
  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 20),
        child: CircleAvatar(
          backgroundImage: con.user.value.image != null
              ? NetworkImage(con.user.value.image!)
              : const AssetImage('assets/img/llama_profile') as ImageProvider,
          radius: 60,
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buttonSignOut() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () => con.signOut(),
          icon: const Icon(
            Icons.power_settings_new,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
