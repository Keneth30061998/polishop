import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/pages/aso/orders/list/aso_orders_list_page.dart';
import 'package:poli_shop/src/pages/client/home/client_home_controller.dart';
import 'package:poli_shop/src/pages/client/products/list/client_products_list_page.dart';
import 'package:poli_shop/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:poli_shop/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:poli_shop/src/pages/register/register_page.dart';
import 'package:poli_shop/src/utils/custom_animated_bottom_bar.dart';

class ClientHomePage extends StatelessWidget {
  ClientsHomeController con = Get.put(ClientsHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>IndexedStack(
        index: con.indexTab.value,
        children: [
          ClientProductsListPage(),
          DeliveryOrdersListPage(),
          ClientProfileInfoPage(),
        ],
      ),),
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
          icon: Icon(Icons.apps),
          title: Text('Products'),
          activeColor: Colors.white,
          inactiveColor: Colors.black54,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.list),
          title: Text('Mis Pedidos'),
          activeColor: Colors.white,
          inactiveColor: Colors.black54,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.person),
          title: Text('Perfil'),
          activeColor: Colors.white,
          inactiveColor: Colors.black54,
        ),
      ],
      onItemSelected: (index) => con.changeTab(index),
    ));
  }
}
