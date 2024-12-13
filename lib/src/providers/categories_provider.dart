import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/category.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import '../models/user.dart';

class CategoriesProvider extends GetConnect {
  String url = /*'${Environment.API_URL}api/categories';*/
  Environment.API_URL + 'api/categories';
  //Usuario creado -> para poder usar el JWT que le da autorizacion
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  Future<ResponseApi> create(Category category) async {
    Response response = await post(
      '$url/create',
      category.toJson(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : userSession.sessionToken! ?? ''
      },
    ); //ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  //Listar categorias
  Future<List<Category>> getAll() async {
    Response response = await get(
      '$url/getAll',
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : userSession.sessionToken! ?? ''
      },
    ); //ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    if(response.statusCode == 401){
      Get.snackbar('Peticion denegada', 'Usuario no autorizado para acceder a la información');
      return [];
    }
    List<Category> categories = Category.fromJsonList(response.body);
    return categories;
  }
}
