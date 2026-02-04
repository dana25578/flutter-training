import 'screens/category_items_page.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
void main(){
  runApp (MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Training',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context){
          return LoginPage();
        },
        SignupPage.routeName: (context){
          return SignupPage();
        },
        HomePage.routeName:(context){
          return HomePage();
        },
        CategoryItemsPage.routeName:(context){
          return CategoryItemsPage();
        },
      },
    );
  }
}