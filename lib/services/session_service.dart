import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
class SessionService{
  static final ValueNotifier<AppUser?>currentUser=ValueNotifier<AppUser?>(null);
  static void setUser(AppUser user){
    currentUser.value=user;
  }
  static void clear(){
    currentUser.value=null;
  }
}