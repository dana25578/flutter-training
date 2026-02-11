import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import '../services/auth_service.dart';
class SignupPage extends StatefulWidget{
  static const String routeName='/signup';
  @override
  State<SignupPage> createState(){
    return _SignupPageState();
  }
}
class _SignupPageState extends State<SignupPage>{
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool _hidePassword=true;
  bool isValidEmail(String email){
    return email.contains('@') && email.contains('.');
  }
  Future<void> signup() async{
    if(!_formKey.currentState!.validate()) return;
    final username=_nameController.text.trim();
    final email=_emailController.text.trim();
    final password=_passwordController.text;
    try{
      final result=await AuthService.register(username, email, password);
      if (result["success"]==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"]??"Account created")),);
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"]??"Signup failed")),);
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection error:$e")),);
    }
  }
  @override
  void dispose(){
    _nameController.dispose();
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
                  Container(width: 38,height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_add,color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Create account",style: TextStyle(fontSize: 12,color: Colors.black54),
                      ),
                      Text("Sign up", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                      ),
                      ),
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
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
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
                          onPressed: signup, child: const Text('Create account'),
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