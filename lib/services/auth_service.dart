import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/session_service.dart';
class AuthService{
  static const String baseUrl="http://10.0.2.2:8081";
  static Future<Map<String,dynamic>> login(String email,String password,) async{
    final res=await http.post(Uri.parse("$baseUrl/api/auth/login"),headers: {"Content-Type":"application/json"},body: jsonEncode({"email":email,"password":password,}),);
    final data=jsonDecode(res.body) as Map<String,dynamic>;
    if (res.statusCode!=200 && res.statusCode!=201){
      throw Exception(data["message"]??"login failed");
    }
    return data;
  }
  static Future<Map<String,dynamic>> register(String username, String email, String password,String phoneNumber,) async{
    final res= await http.post(Uri.parse("$baseUrl/api/auth/register"),headers: {"Content-Type":"application/json"},body: jsonEncode({"username":username,"email":email,"password":password,"phoneNumber":phoneNumber,}),);
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
  static Future<Map<String,dynamic>> verifyOtp(String email,String code) async{
    final res=await http.post(
      Uri.parse("$baseUrl/api/auth/verify-otp"),headers:{"Content-Type":"application/json"},body:jsonEncode({"email":email,"code":code}),);
    final data=jsonDecode(res.body) as Map<String,dynamic>;
    if (res.statusCode!=200 && res.statusCode!=201){
      throw Exception(data["message"]??"otp verification failed");
    }
    return data;
  }
  static Future<Map<String,dynamic>> resendOtp(String email) async{
    final res=await http.post(Uri.parse("$baseUrl/api/auth/resend-otp"),headers: {"Content-Type":"application/json"},body: jsonEncode({"email":email,"code":""}),);
    return jsonDecode(res.body) as Map<String,dynamic>;
  }
}
