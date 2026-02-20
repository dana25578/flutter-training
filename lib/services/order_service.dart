import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';
class OrderService{
  static const String baseUrl="http://10.0.2.2:8081";
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
    print("ORDER BODY: ${jsonEncode(body)}");
    final res=await http.post(Uri.parse("$baseUrl/api/orders"),
    headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (res.body.isEmpty) throw Exception("empty response from server");
    if (res.statusCode<200||res.statusCode>=300) throw Exception(res.body);
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
  static Future<List<dynamic>> getOrdersByUser(int userId) async{
    final res=await http.get(Uri.parse("$baseUrl/api/orders/by-user/$userId"),
    headers: {"Content-Type": "application/json"},
    );
    if (res.body.isEmpty) throw Exception("empty response from server");
    if (res.statusCode<200||res.statusCode>=300) throw Exception(res.body);
    return jsonDecode(res.body) as List<dynamic>;
  }
}