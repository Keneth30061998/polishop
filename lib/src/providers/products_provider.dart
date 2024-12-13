import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poli_shop/src/environment/environment.dart';
import 'package:poli_shop/src/models/user.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ProductsProvider extends GetConnect {
  //URL DE LA API
  String url = Environment.API_URL + 'api/products';

  //PARA LAS AUTORIZACIONES -> importamos usuario
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<Stream> create(Product product, List<File> images) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/products/create');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = userSession.sessionToken ?? '';

    //FOR DISEÑADO PARA CARGAR N IMAGENES
    for (int i = 0; i < images.length; i++) {
      request.files.add(
        http.MultipartFile(
            'image', //porque asi la llamamos en las rutas back
            http.ByteStream(
              images[i].openRead().cast(),
            ),
            await images[i].length(),
            filename: basename(images[i].path)),
      );
    }

    request.fields['product'] = json.encode(product);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  //PARA LISTAR PRODUCTOS
  Future<List<Product>> findByCategory(String idCategory) async {
    Response response = await get(
      '$url/findByCategory/$idCategory',
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : userSession.sessionToken! ?? ''
      },
    ); //ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    if(response.statusCode == 401){
      Get.snackbar('Peticion denegada', 'Usuario no autorizado para acceder a la información');
      return [];
    }
    List<Product> products = Product.fromJsonList(response.body);
    return products;
  }
}
