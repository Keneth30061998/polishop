import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/pages/aso/orders/list/aso_orders_list_controller.dart';

class AsoOrdersListPage extends StatelessWidget {
  AsoOrdersListController con = Get.put(AsoOrdersListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Aso Orders List Page'),
      ),
    );
  }
}
