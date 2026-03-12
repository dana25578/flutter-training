import 'dart:convert';
import '../models/product.dart';
import 'api_client.dart';
class WishlistApiService{
  static Future<List<Product>> getMyWishlist() async{
    final res=await ApiClient.get("/api/wishlist",auth:true);
    if (res.body.isEmpty){
      return [];
    }
    if (res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    final List<dynamic> data=jsonDecode(res.body);
    return data.map((item){
      final map=item as Map<String,dynamic>;
      return Product(id:map["productId"] as int,
        name:(map["name"]??"").toString(),
        description:map["description"]?.toString(),
        price:(map["price"] as num).toDouble(),
        imageUrl:map["imageUrl"] as String?,
        categoryId:map["categoryId"] as int,
      );
    }).toList();
  }
  static Future<List<Product>> toggleProduct(int productId) async{
    final res=await ApiClient.put("/api/wishlist/toggle",auth:true,
      body:{
        "productId":productId,
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
      final map=item as Map<String,dynamic>;
      return Product(id:map["productId"] as int,
        name:(map["name"]??"").toString(),
        description:map["description"]?.toString(),
        price:(map["price"] as num).toDouble(),
        imageUrl:map["imageUrl"] as String?,
        categoryId:map["categoryId"] as int,
      );
    }).toList();
  }
  static Future<void> clearWishlist() async{
    final res=await ApiClient.delete("/api/wishlist/clear",auth:true);
    if (res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
  }
}