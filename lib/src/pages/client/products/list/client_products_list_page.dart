import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/models/category.dart';
import 'package:poli_shop/src/pages/aso/orders/list/aso_orders_list_page.dart';
import 'package:poli_shop/src/pages/client/home/client_home_controller.dart';
import 'package:poli_shop/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:poli_shop/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:poli_shop/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:poli_shop/src/pages/register/register_page.dart';
import 'package:poli_shop/src/utils/custom_animated_bottom_bar.dart';
import 'package:poli_shop/src/widgets/no_data_widget.dart';

import '../../../../models/product.dart';

class ClientProductsListPage extends StatelessWidget {
  ClientsProductListController con = Get.put(ClientsProductListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: con.categories.length,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(75),
              child: AppBar(
                backgroundColor: Colors.redAccent,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: List<Widget>.generate(con.categories.length, (index) {
                    return Tab(
                      child: Text(con.categories[index].name ?? ''),
                    );
                  }),
                ),
              ),
            ),
            body: TabBarView(
              children: con.categories.map((Category category) {
                return FutureBuilder(
                    future: con.getProducts(category.id ?? '1'),
                    builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                      if (snapshot.hasData) {

                        if(snapshot.data!.length>0){
                          return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardProduct(context, snapshot.data![index]);
                            },
                          );
                        }else{
                          return NoDataWidget(text: 'No existen productos',);
                        }

                      } else {
                        return NoDataWidget(text: 'No existen productos',);
                      }
                    });
              }).toList(),
            ),
          ),
        ));
  }

  //widget para mostrar los datos del producto
  Widget _cardProduct(BuildContext context, Product product) {
    return GestureDetector(
      onTap: ()=>con.openBottomSheet(context, product),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 10, right: 10),
            child: ListTile(
              title: Text(
                product.name ?? '',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.description ?? '',
                    maxLines: 2,
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '\$${product.price.toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Text(product.price.toString())
      
                ],
      
              ),
              leading: Container(
                height: 80,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    image: product.image1 != null
                        ? NetworkImage(product.image1!)
                        : AssetImage('assets/img/noImage.jpg') as ImageProvider,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 30),
                    placeholder: AssetImage('assets/img/noImage.jpg'),
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 1,color: Colors.grey[300], indent: 25,endIndent: 25,),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
