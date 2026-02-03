import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
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
  void signup(){
    if (_formKey.currentState!.validate()){
      Navigator.pushReplacementNamed(context, HomePage.routeName);
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
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Sign up',
                  style:TextStyle(color:Colors.blue,fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value){
                    if (value==null|| value.isEmpty){
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'dana@abc.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return 'Email is required';
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
                  ),
                  validator: (value){
                    if (value==null||value.length<6){
                      return 'minimum 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: signup, child: Text('Create account'),
                ),
                TextButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                }, child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}