import 'dart:convert';
import 'package:http/http.dart' as http;
class AuthService{
  static const String baseUrl="http://10.0.2.2:8081";
  static Future<Map<String,dynamic>> login(String email,String password,) async{
    final res=await http.post(Uri.parse("$baseUrl/api/auth/login"),headers: {"Content-Type":"application/json"},body: jsonEncode({"email":email,"password":password,}),);
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
  static Future<Map<String,dynamic>> register(String username, String email, String password,String phoneNumber,) async{
    final res= await http.post(Uri.parse("$baseUrl/api/auth/register"),headers: {"Content-Type":"application/json"},body: jsonEncode({"username":username,"email":email,"password":password,"phoneNumber":phoneNumber,}),);
    return jsonDecode(res.body) as Map<String,dynamic>;
  }

}
