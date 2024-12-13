
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poli_shop/src/models/user.dart';
import 'package:poli_shop/src/pages/aso/home/aso_home_page.dart';
import 'package:poli_shop/src/pages/aso/orders/list/aso_orders_list_page.dart';
import 'package:poli_shop/src/pages/client/home/client_home_page.dart';
import 'package:poli_shop/src/pages/client/products/list/client_products_list_page.dart';
import 'package:poli_shop/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:poli_shop/src/pages/client/profile/update/client_profile_update_page.dart';
import 'package:poli_shop/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:poli_shop/src/pages/home/home_page.dart';
import 'package:poli_shop/src/pages/login/login_page.dart';
import 'package:poli_shop/src/pages/register/register_page.dart';
import 'package:poli_shop/src/pages/roles/roles_page.dart';

//Para que solo haga un registro
User userSession = User.fromJson(GetStorage().read('user')??{});

void main() async{
  await GetStorage.init(); //para construir el inicio de sesion de usuario -> home
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Token de sesion : ${userSession.sessionToken}');
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PoliShop',
      theme: ThemeData(
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.id != null ? userSession.roles!.length > 1 ? '/roles' : '/client/home' : '/',
      getPages: [
        GetPage(name: '/', page: ()=>LoginPage()),
        GetPage(name: '/register', page: ()=>RegisterPage()),
        GetPage(name: '/home', page: ()=>HomePage()),
        GetPage(name: '/roles', page: ()=>RolesPage()),
        GetPage(name: '/aso/home', page: ()=>AsoHomePage()),
        GetPage(name: '/aso/orders/list', page: ()=>AsoOrdersListPage()),
        GetPage(name: '/delivery/orders/list', page: ()=> DeliveryOrdersListPage()),
        GetPage(name: '/client/home', page: ()=>ClientHomePage()),
        GetPage(name: '/client/products/list', page: ()=>ClientProductsListPage()),
        GetPage(name: '/client/profile/info', page: ()=>ClientProfileInfoPage()),
        GetPage(name: '/client/profile/update', page: ()=>ClientProfileUpdatePage()),
      ],
    );
  }
}
