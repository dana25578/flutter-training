import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
class ProductService{
  static const String baseUrl="http://10.0.2.2:8081";
  static Future<List<Product>> getAllProducts() async{
    final res=await http.get(
      Uri.parse("$baseUrl/api/products"),
      headers: {"Content-Type":"application/json"},
    );
    if (res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    final List data=jsonDecode(res.body) as List;
    List<Product> products=[];
    for (int i=0 ;i<data.length;i++){
      Map<String,dynamic> item=data[i];
      Product product=Product.fromJson(item);
      products.add(product);
    }
    return products;
  }
  static Future<List<Product>> getProductsByCategory(int categoryId) async{
    final Uri url=Uri.parse("$baseUrl/api/products/by-category/$categoryId");
    final http.Response res=await http.get(url, headers: {"Content-Type":"application/json"},);
    if (res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    final List<dynamic> data=jsonDecode(res.body);
    List<Product> products=[];
    for (int i=0 ;i<data.length;i++){
      Map<String,dynamic> item=data[i];
      Product product=Product.fromJson(item);
      products.add(product);
    }
    return products;
  }
}