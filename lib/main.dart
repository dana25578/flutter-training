import 'screens/category_items_page.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/basket_page.dart';
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
        ProfilePage.routeName:(context){
          final args=ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
          final String username=(args?['username']??'User') as String;
          final String email=(args?['email']??'user@email.com') as String;
          return ProfilePage(username: username, email: email);
        },
        BasketPage.routeName:(context){
          return BasketPage();
        },
      },
    );
  }
}