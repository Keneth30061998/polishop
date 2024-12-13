import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/pages/aso/categories/create/aso_categories_create_page.dart';
import 'package:poli_shop/src/pages/aso/home/aso_home_controller.dart';
import 'package:poli_shop/src/pages/aso/orders/list/aso_orders_list_page.dart';
import 'package:poli_shop/src/pages/aso/products/create/aso_products_create_page.dart';
import 'package:poli_shop/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:poli_shop/src/utils/custom_animated_bottom_bar.dart';

class AsoHomePage extends StatelessWidget {
  AsoHomeController con = Get.put(AsoHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
      ),
      body: Obx(
        () => IndexedStack(
          index: con.indexTab.value,
          children: [
            AsoOrdersListPage(),
            AsoCategoriesCreatePage(),
            AsoProductsCreatePage(),
            ClientProfileInfoPage(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
          containerHeight: 70,
          backgroundColor: Colors.redAccent,
          showElevation: true,
          itemCornerRadius: 20,
          curve: Curves.easeIn,
          selectedIndex: con.indexTab.value,
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.list),
              title: Text('Pedidos'),
              activeColor: Colors.white,
              inactiveColor: Colors.black54,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.category),
              title: const Text('Categoria'),
              activeColor: Colors.white,
              inactiveColor: Colors.black54,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.app_registration),
              title: const Text('Producto'),
              activeColor: Colors.white,
              inactiveColor: Colors.black54,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Perfil'),
              activeColor: Colors.white,
              inactiveColor: Colors.black54,
            ),
          ],
          onItemSelected: (index) => con.changeTab(index),
        ));
  }
}
