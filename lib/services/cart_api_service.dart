import 'dart:convert';
import '../models/cart_item.dart';
import 'api_client.dart';
class CartApiService{
  static Future<List<CartItem>> getMyCart() async{
    final res=await ApiClient.get("/api/cart",auth:true);
    if (res.body.isEmpty){
      return [];
    }
    if (res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    final List<dynamic> data=jsonDecode(res.body);
    return data.map((item){
      final map=item as Map<String,dynamic>;
      return CartItem(
        productId:map["productId"] as int,
        name:(map["name"]??"").toString(),
        price:(map["price"] as num).toDouble(),
        image:(map["imageUrl"]??"").toString(),
        quantity:map["quantity"] as int,
      );
    }).toList();
  }
  static Future<List<CartItem>> updateCartItem({
    required int productId,
    required int quantity,
  })async{
    final res=await ApiClient.put("/api/cart",auth:true,
      body:{
        "productId":productId,
        "quantity":quantity,
      },
    );
    if (res.body.isEmpty){
      return [];
    }
    if (res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    final List<dynamic> data=jsonDecode(res.body);
    return data.map((item){
      final map=item as Map<String, dynamic>;
      return CartItem(
        productId:map["productId"] as int,
        name:(map["name"]?? "").toString(),
        price:(map["price"] as num).toDouble(),
        image:(map["imageUrl"]?? "").toString(),
        quantity:map["quantity"] as int,
      );
    }).toList();
  }
  static Future<void> clearCart() async{
    final res=await ApiClient.delete("/api/cart/clear",auth:true);
    if (res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
  }
}