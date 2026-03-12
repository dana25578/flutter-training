import 'dart:convert';
import '../models/cart_item.dart';
import '../models/order_model.dart';
import 'api_client.dart';
class OrderService{
  static Future<Map<String,dynamic>> createOrder({
    required int userId,
    required String address,
    required List<CartItem> items,
  })async{
    final body={
      "userId":userId,
      "address":address,
      "items":items.map((it){
        return{
          "productId":it.productId,
          "quantity":it.quantity,
        };
      }).toList(),
    };
    final res=await ApiClient.post("/api/orders",auth:true,body: body);
    if (res.body.isEmpty) throw Exception("empty response from server");
    if (res.statusCode<200||res.statusCode>=300) throw Exception(res.body);
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
  static Future<List<OrderModel>> getOrdersByUser(int userId) async{
    final res=await ApiClient.get("/api/orders/by-user/$userId",auth: true,);
    if (res.body.isEmpty){
      throw Exception("empty response from server");
    }
    if (res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    final List<dynamic> data=jsonDecode(res.body) as List<dynamic>;
    return data.map((item){
      return OrderModel.fromJson(item as Map<String,dynamic>);
    }).toList();
  }
}