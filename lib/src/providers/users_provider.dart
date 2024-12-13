import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poli_shop/src/environment/environment.dart';

import '../models/response_api.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UserProvider extends GetConnect {
  String url = /*'${Environment.API_URL}api/users';*/
  Environment.API_URL + 'api/users';

  //Usuario creado para poder usar el JWT que le da autorizacion
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  Future<Response> create(User user) async {
    Response response = await post(
      '$url/create',
      user.toJson(),
      headers: {'Content-Type': 'application/json'},
    ); //ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    return response;
  }

  //Para actualizar la informacion del usuario sin imagen
  Future<ResponseApi> update(User user) async {
    Response response = await put(
      '$url/updateWithoutImage',
      user.toJson(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? '',
      },
    ); //ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar el usuario');
      return ResponseApi();
    }

    //Para dar permisos del JWT
    if (response.body == 401) {
      Get.snackbar('Error', 'No está autorizado para realizar esta petición');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  //Para enviar el formulario conImagen
  Future<Stream> createWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/createWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile('image', http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)),
    );
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  //Para actualizar el usuario con imagen
  Future<Stream> updateWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/update');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = userSession.sessionToken ?? ''; //para usar el JWT
    request.files.add(
      http.MultipartFile('image', http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)),
    );
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  //Para el login
  Future<ResponseApi> login(String email, String password) async {
    Response response = await post(
      '$url/login',
      {'email': email, 'password': password},
      headers: {'Content-Type': 'application/json'},
    ); //ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.body == null) {
      Get.snackbar("Error", 'No se puedo ejecutar la petición');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
