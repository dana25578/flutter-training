import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'home_page.dart';
class LoginPage extends StatefulWidget{
  static const String routeName='/login';
  @override
  State<LoginPage> createState(){
    return _LoginPageState();
  }
}
class _LoginPageState extends State<LoginPage>{
  final GlobalKey<FormState> _formkey= GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController =TextEditingController();
  bool _hidePassword = true;
  bool isValidEmail(String email){
    return email.contains('@') && email.contains('.');
  }
  void login(){
    if (_formkey.currentState!.validate()){
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    }
  }
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formkey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Login',
                    style:TextStyle(color:Colors.blue, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'dana@abc.com',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if (value==null || value.isEmpty){
                        return 'Email is required';
                      }
                      if (!isValidEmail(value)){
                        return 'Email must contain @ amd .';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword ?Icons.visibility_off :Icons.visibility,
                        ),
                        onPressed: (){
                          setState(() {
                            _hidePassword=!_hidePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value){
                      if (value==null|| value.isEmpty){
                        return 'Password is required';
                      }
                      if (value.length<6){
                        return 'minimum 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: login, child: Text('Login'),
                  ),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, SignupPage.routeName);
                  }, child: Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),

    );
  }
}