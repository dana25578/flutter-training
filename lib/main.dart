import 'screens/category_items_page.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/basket_page.dart';
import 'screens/checkout_page.dart';
import 'screens/category_items_page.dart';
import 'screens/wishlist_page.dart';
import 'screens/categories_page.dart';
import 'screens/account_page.dart';
import 'screens/my_orders_page.dart';
void main(){
  runApp (MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Training',
      debugShowCheckedModeBanner: false,
      initialRoute:HomePage.routeName,
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
        CategoriesPage.routeName:(context){
          return const CategoriesPage();
        },
        WishlistPage.routeName:(context){
          return const WishlistPage();
        },
        AccountPage.routeName:(context){
          return const AccountPage();
        },
        MyOrdersPage.routeName:(context){
          return const MyOrdersPage();
        },
        ProfilePage.routeName:(context){
          final args=ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
          final int id=(args?['id']??0) as int;
          final String username=(args?['username']??'User') as String;
          final String email=(args?['email']??'user@email.com') as String;
          return ProfilePage(id:id,username: username, email: email);
        },
        BasketPage.routeName:(context){
          return BasketPage();
        },
        CheckoutPage.routeName:(context){
          return const CheckoutPage();
        }
      },
    );
  }
}