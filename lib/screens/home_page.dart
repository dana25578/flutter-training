import 'package:flutter/material.dart';
import 'login_page.dart';
class HomePage extends StatelessWidget{
  static const String routeName='/home';
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(icon: Icon(Icons.logout),onPressed: () {
            Navigator.pushReplacementNamed(context, LoginPage.routeName);
          },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Home page',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),

        ),
      ),
    );
  }
}