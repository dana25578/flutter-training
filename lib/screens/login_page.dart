import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'home_page.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';
import '../services/session_service.dart';
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
  Future<void> login() async {
    if (!_formkey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final result=await AuthService.login(email, password);
    print("Login result:$result");
    final bool success=result["success"]==true;
    if(success){
      final user=AppUser.fromJson(result);
      SessionService.setUser(user);
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"]?.toString()??"Login failed"),),);
    }
  }
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
@override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black,
                       borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person,color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back", style:TextStyle(fontSize: 12,color: Colors.black54)),
                      Text("Login", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'dana@abc.com',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value){
                          if (value==null|| value.isEmpty){
                            return 'Email is required';
                          }
                          if (!isValidEmail(value)){
                            return 'Email must contain @ and .';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword?Icons.visibility_off:Icons.visibility,
                            ),
                            onPressed: (){
                              setState(() {
                                _hidePassword=!_hidePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value){
                          if (value==null|| value.length<6){
                            return 'Minimum 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: login,child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(onPressed: (){
                        Navigator.pushNamed(context, SignupPage.routeName);
                      },
                        child: const Text("Don't have an account? Sign up",
                      style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
