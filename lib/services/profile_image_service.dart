import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'session_service.dart';
class ProfileImageService{
  static const baseUrl="http://10.0.2.2:8081";
  static Future<String> uploadImage(File image) async{
    final token=SessionService.token.value;
    final request=http.MultipartRequest("POST",Uri.parse("$baseUrl/api/profile/upload-image"),);
    request.headers['Authorization']="Bearer $token";
    request.files.add(await http.MultipartFile.fromPath('file',image.path),);
    final response=await request.send();
    final respStr=await response.stream.bytesToString();
    if(response.statusCode!=200){
      throw Exception(respStr);
    }
    return respStr.replaceAll('"','');
  }
}