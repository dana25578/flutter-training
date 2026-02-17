import 'dart:convert';
import 'package:http/http.dart' as http;
class UserService{
  static const String baseUrl="http://10.0.2.2:8081";
  static Future<Map<String,dynamic>>updateUser({
    required int id,
    required String username,
    required String email,
    required String phoneNumber,
    required String address,
  })async{
    final res=await http.put(Uri.parse("$baseUrl/api/users/$id"),headers:{"Content-Type":"application/json"},body:jsonEncode({"username":username,"email":email,"phoneNumber":phoneNumber,"address":address,}),);
    if (res.body.isEmpty){
      throw Exception("empty response");
    }
    if(res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
  static Future<Map<String,dynamic>> getUserById(int id) async{
    final res=await http.get(Uri.parse("$baseUrl/api/users/$id"),headers: {"Content-Type":"application/json"},);
    if(res.body.isEmpty){
      throw Exception("empty respons");
    }
    if(res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
}