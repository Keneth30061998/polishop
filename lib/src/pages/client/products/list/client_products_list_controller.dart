import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:poli_shop/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:poli_shop/src/pages/client/products/list/client_products_list_page.dart';
import 'package:poli_shop/src/providers/categories_provider.dart';
import 'package:poli_shop/src/providers/products_provider.dart';
import '../../../../models/category.dart';
import '../../../../models/product.dart';


class ClientsProductListController extends GetxController {
  CategoriesProvider categoriesProvider = CategoriesProvider();
  ProductsProvider productsProvider = ProductsProvider();
  List<Category> categories = <Category>[].obs;

  ClientsProductListController() {
    getCategories();
  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  //Listar Productos
  Future<List<Product>> getProducts(String idCategory) async {
    return await productsProvider.findByCategory(idCategory);
  }

  //Detalles del producto -> boton
  void openBottomSheet(BuildContext context, Product product) async{
    showMaterialModalBottomSheet(
      context: context,
      builder: (context)=>ClientProductsDetailPage(product: product,),
    );
  }
}
