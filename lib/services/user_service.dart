import 'dart:convert';
import 'api_client.dart';
class UserService{
  static Future<Map<String,dynamic>>updateUser({
    required int id,
    required String username,
    required String email,
    required String phoneNumber,
    required String address,
  })async{
    final res=await ApiClient.put("/api/users/$id",auth:true,body:{"username":username,"email":email,"phoneNumber":phoneNumber,"address":address,},);
    if (res.body.isEmpty){
      throw Exception("empty response");
    }
    if(res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
  static Future<Map<String,dynamic>> getUserById(int id) async{
    final res=await ApiClient.get("/api/users/$id",auth:true);
    if(res.body.isEmpty){
      throw Exception("empty response");
    }
    if(res.statusCode<200||res.statusCode>=300){
      throw Exception(res.body);
    }
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
}