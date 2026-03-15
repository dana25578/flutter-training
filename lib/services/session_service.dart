import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class SessionService{
  static final ValueNotifier<AppUser?>currentUser=ValueNotifier<AppUser?>(null);
  static final ValueNotifier<String?> token=ValueNotifier<String?>(null);
  static const String _tokenKey="token";
  static const String _userKey="user";
  static Future<void> init() async{
    final prefs=await SharedPreferences.getInstance();
    final savedToken=prefs.getString(_tokenKey);
    final savedUserJson=prefs.getString(_userKey);
    if (savedToken!=null && savedToken.isNotEmpty){
      token.value=savedToken;
    }
    if (savedUserJson!=null && savedUserJson.isNotEmpty){
      final Map<String,dynamic> userMap=jsonDecode(savedUserJson);
      currentUser.value=AppUser.fromJson(userMap);
    }
  }
  static Future<void> setSession({required AppUser user,required String tokenValue,}) async{
    currentUser.value=user;
    token.value=tokenValue;
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey,tokenValue);
    await prefs.setString(_userKey,jsonEncode(user.toJson()));
  }
  static Future<void> setUser(AppUser user,{String? tokenValue}) async{
    currentUser.value=user;
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString(_userKey,jsonEncode(user.toJson()));
    if (tokenValue!=null){
      token.value=tokenValue;
      await prefs.setString(_tokenKey,tokenValue);
    }
  }
  static Future<void> clear() async{
    currentUser.value=null;
    token.value=null;
    final prefs=await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
  static bool get isLoggedIn{
    final t=token.value;
    return t!=null && t.isNotEmpty && currentUser.value!=null;
  }
}