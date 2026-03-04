import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
class SessionService{
  static final ValueNotifier<AppUser?>currentUser=ValueNotifier<AppUser?>(null);
  static final ValueNotifier<String?> token=ValueNotifier<String?>(null);
  static void setSession({required AppUser user,required String tokenValue}){
    currentUser.value =user;
    token.value=tokenValue;
  }
  static void setUser(AppUser user,{String? tokenValue}){
    currentUser.value=user;
    token.value=tokenValue;
  }
  static void clear(){
    currentUser.value=null;
    token.value=null;
  }
}