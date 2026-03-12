import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_service.dart';
class ApiClient{
  ApiClient._();
  static const String baseUrl="http://10.0.2.2:8081";
  static Map<String,String> _headers({bool auth=false}){
    final headers=<String,String>{"Content-Type":"application/json",};
    if (auth){
      final t=SessionService.token.value;
      if (t!=null && t.isNotEmpty){
        headers["Authorization"]="Bearer $t";
      }
    }
    return headers;
  }
  static Future<http.Response> get(String path,{bool auth=false}) async{
    return http.get(Uri.parse("$baseUrl$path"),headers:_headers(auth:auth));
  }
  static Future<http.Response> post(String path,{Object?body,bool auth=false})async{
    return http.post(Uri.parse("$baseUrl$path"),headers:_headers(auth: auth),body:body==null?null:jsonEncode(body),);
  }
  static Future<http.Response> put(String path,{Object?body,bool auth =false}) async{
    return http.put(Uri.parse("$baseUrl$path"),headers:_headers(auth:auth),body:body== null? null:jsonEncode(body),);
  }
  static Future<http.Response> delete(String path,{Object? body,bool auth=false}) async{
    return http.delete(Uri.parse("$baseUrl$path"),headers:_headers(auth: auth),body:body==null? null:jsonEncode(body),);
  }
}