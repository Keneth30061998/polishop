import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/pages/home/home_controller.dart';

class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: ()=>con.signOut(),
        child: const Text('Cerrar Sesion'),
      ),
    );
  }
}
