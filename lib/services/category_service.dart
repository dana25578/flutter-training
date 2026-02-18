import "dart:convert";
import "package:http/http.dart" as http;
import '../models/category.dart';
class CategoryService{
  static const String baseUrl="http://10.0.2.2:8081";
  static Future<List<Category>> getCategories() async{
    final Uri url=Uri.parse(baseUrl+"/api/categories");
    final http.Response res=await http.get(url,headers: {"Content-Type":"application/json"},);
    if(res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    final List data=jsonDecode(res.body) as List;
    final List<Category> categories=[];
    for(final item in data){
      categories.add(Category.fromJson(item as Map<String,dynamic>));
    }
    return categories;
  }
}