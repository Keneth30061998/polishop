import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:poli_shop/src/pages/client/products/detail/client_products_detail_controller.dart';

import '../../../../models/product.dart';

class ClientProductsDetailPage extends StatelessWidget {
  Product? product;
  late ClientProductsDetailController con;
  var counter = 0.obs;
  var price = 0.0.obs;

  ClientProductsDetailPage({@required this.product}){
    con = Get.put(ClientProductsDetailController());
  }

  @override
  Widget build(BuildContext context) {
    con.checkIfProductWasAdded(product!, price, counter);
    return Obx(() =>  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5),
        child: AppBar(
          backgroundColor: Colors.redAccent[200],
        ),
      ),
      body: Column(
        children: [
          _imageSlideShow(context),
          _textProductName(),
          _textProductDetail(),
          _textProductPrice()
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: _buttonAddToBag(),
      ),
    )
    );
  }

  //widget para el carrusel de iumagenes
  Widget _imageSlideShow(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ImageSlideshow(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            initialPage: 0,
            indicatorColor: Colors.red,
            children: [
              FadeInImage(
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 30),
                placeholder: AssetImage('assets/img/noImage.jpg'),
                image: product!.image1 != null
                    ? NetworkImage(product!.image1!)
                    : AssetImage('assets/img/noImage.jpg') as ImageProvider,
              ),
              FadeInImage(
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 30),
                placeholder: AssetImage('assets/img/noImage.jpg'),
                image: product!.image2 != null
                    ? NetworkImage(product!.image2!)
                    : AssetImage('assets/img/noImage.jpg') as ImageProvider,
              ),
              FadeInImage(
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 30),
                placeholder: AssetImage('assets/img/noImage.jpg'),
                image: product!.image3 != null
                    ? NetworkImage(product!.image3!)
                    : AssetImage('assets/img/noImage.jpg') as ImageProvider,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //widget de texto del producto
  Widget _textProductName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 30,
        left: 30,
        right: 30,
      ),
      child: Text(
        product?.name ?? '',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black),
      ),
    );
  }

  //widget de descripcion
  Widget _textProductDetail() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 30,
        left: 30,
        right: 30,
      ),
      child: Text(
        product?.description ?? '',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  //widget para el precio del producto
  Widget _textProductPrice() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 15,
        left: 30,
        right: 30,
      ),
      child: Text(
        '\$ ${product?.price.toString() ?? ''}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }

  //widget para los botones
  Widget _buttonAddToBag() {
    return Column(
      children: [
        Divider(
          height: 1,
          color: Colors.grey[300],
          indent: 20,
          endIndent: 20,
        ),
        Container(
          padding: EdgeInsets.only(right: 10,left: 10),
          margin: EdgeInsets.only(top: 10),
          child: Row(

            children: [
              ElevatedButton(
                onPressed: () =>con.removeItem(product!, price, counter),
                child: Text(
                  '-',
                  style: TextStyle(fontSize: 20,color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),

                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  '${counter.value}',
                  style: TextStyle(fontSize: 20,color: Colors.grey[500]),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),

                ),
              ),
              ElevatedButton(
                onPressed: () => con.addItem(product!, price, counter),
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 20,color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),

                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () =>con.addToBag(product!, price, counter),
                child: Text(
                  'Agregar: \$${price.value ?? ''}',
                  style: TextStyle(fontSize: 15,color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),

                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
