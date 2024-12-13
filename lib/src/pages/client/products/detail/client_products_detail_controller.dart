import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poli_shop/src/models/product.dart';

class ClientProductsDetailController extends GetxController {

  //Lista creada para añadir productos al carrito de compra
  List<Product> selectProducts = [];

  ClientProductsDetailController() { //Constructor
  }
  //contador de productos añadidos
  void addItem(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = product.price! * counter.value;
  }

  //contador de prodctos quitados
  void removeItem(Product product, var price, var counter) {
    if (counter.value > 0) {
      counter.value = counter.value - 1;
      price.value = product.price! * counter.value;
    }
  }

  //Metodo creado para añadir productos al carrito de compras
  void addToBag(Product product, var price, var counter) {

    if(counter.value > 0){ //Validacion para que exista almenos un item seleccionado

      //Valorar si el producto fue agregado con getstorage a la sesion del dispositivo
      int index = selectProducts.indexWhere((p) => p.id == product.id);
      if(index == -1){ //No ha sido agregado
        if(product.quantity == null){
          if( counter.value > 0 ){
            product.quantity = counter.value;
          }else{
            product.quantity= 1;
          }

        }
        selectProducts.add(product);
      }else{ //Producto ya ha sido agregado al storage
        selectProducts[index].quantity = counter.value;
      }
      GetStorage().write('shopping_bag', selectProducts);
      //instalamos flutter toast para enviar un mensaje pub.dev
      Fluttertoast.showToast(msg: 'Producto Agregado');

    }
    else{
      Fluttertoast.showToast(msg: 'Selecciona al menos un item para agregar');
    }

  }

  void checkIfProductWasAdded(Product product, var price, var counter){
    price.value = product.price ?? 0.0;

    //Obteniendo los productos almacenados en sesion
    if(GetStorage().read('shopping_bag') != null){

      if(GetStorage().read('shopping_bag') is List<Product>){
        selectProducts = GetStorage().read('shopping_bag');
      }
      else{
        selectProducts = Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      //Para que al iniciar no vuelva el contador a 1
      int index = selectProducts.indexWhere((p) => p.id == product?.id);

      if(index !=-1){ //El producto ya fue agregado
        counter.value = selectProducts[index].quantity??0;
        price.value = product.price!*counter.value;
        selectProducts.forEach((p) {
          print('Products: ${p.toJson()}');
        });
      }


    }
  }
}
