import 'package:app/services/session_service.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import '../services/auth_service.dart';
import 'package:app/models/app_user.dart';
import 'otp_page.dart';
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
  final TextEditingController _phoneController=TextEditingController();
  bool _hidePassword=true;
  bool _isLoading=false;
  bool isValidEmail(String email){
    return email.contains('@') && email.contains('.');
  }
  Future<void> signup() async{
    if(_isLoading) return;
    if(!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading=true;
    });
    final username=_nameController.text.trim();
    final email=_emailController.text.trim();
    final password=_passwordController.text;
    final phone= _phoneController.text.trim();
    try{
      final result=await AuthService.register(username,email,password,phone);
      if (result["success"]==true){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(result["message"]??"otp sent")),);
       Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){return OtpPage(email: email);},),);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(result["message"]??"Signup failed")),);
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection error:$e")),);
    }finally{
      setState(() {
        _isLoading=false;
      });
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
                        validator: (v){
                          if (v==null||v.trim().isEmpty) return "name is required";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v){
                          if(v==null||v.trim().isEmpty) return "email is required";
                          if(!isValidEmail(v.trim())) return "enter a valid email";
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
                        validator: (v){
                          if(v==null|| v.length<6) return "minimum 6 characters";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: "Phone Number",border: const OutlineInputBorder(),),
                        validator: (v){
                          if (v==null||v.trim().isEmpty) return "phone number is required";
                          if (v.length<7) return "minimum 7 digits";
                          if (!RegExp(r'^[0-9]+$').hasMatch(v)) return "enter a valid phone number";
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
                          onPressed: _isLoading?null:signup,
                          child: _isLoading?const SizedBox(width: 22,height: 22,child: CircularProgressIndicator(strokeWidth: 2),):const Text('Create account'),
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