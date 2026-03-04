import 'package:app/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import '../models/app_user.dart';
import '../services/session_service.dart';
class OtpPage extends StatefulWidget{
  static const routeName='/otp';
  final String email;
  const OtpPage({super.key,required this.email});
  @override
  State<OtpPage> createState(){
    return _OtpPageState();
  }
}
class _OtpPageState extends State<OtpPage>{
  final TextEditingController _codeCtrl=TextEditingController();
  bool _loading=false;
  Future<void> _verify() async{
    if (_loading){
      return;
    }
    setState(() {
      _loading =true;
    });
    try{
      final res=await AuthService.verifyOtp(
        widget.email,
        _codeCtrl.text.trim(),
      );
      final bool ok=res["success"]==true;
      String message;
      if (res["message"]!=null){
        message=res["message"].toString();
      }else{
        if (ok){
          message="Verified";
        }else{
          message="Failed";
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(message),),);
      if (ok){
        final user=AppUser.fromJson(res);
        final token=(res["token"]??"").toString();
        if (token.isEmpty){
          throw Exception("missing token from backend after otp");
        }
        SessionService.setSession(user:user,tokenValue:token);
        print("token:${SessionService.token.value}");
        Navigator.pushReplacementNamed(context,HomePage.routeName);
      }
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Error: "+e.toString()),),);
    }finally{
      if (mounted){
        setState((){
          _loading=false;
        });
      }
    }
  }
  Future<void> _resend() async{
    setState(() {
      _loading=true;
    });
    try{
      final res=await AuthService.resendOtp(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(res["message"]??"otp reset"),),);
    }finally{
      setState(() {
        _loading=false;
      });
    }
  }
  @override
  void dispose(){
    _codeCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color(0xFFF6F7FB),
      body:SafeArea(
        child:SingleChildScrollView(padding:const EdgeInsets.all(20),
          child:Column(
            children:[
              const SizedBox(height:30),
              Row(
                children:[
                  Container(
                    width:38,
                    height:38,
                    decoration:BoxDecoration(
                      color:Colors.black,
                      borderRadius:BorderRadius.circular(12),
                    ),
                    child:const Icon(Icons.verified_user,color:Colors.white),
                  ),
                  const SizedBox(width:12),
                  const Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [Text("Almost there",style:TextStyle(fontSize:12,color:Colors.black54)),
                      Text("Verify OTP",style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height:20),
              Align(
                alignment:Alignment.centerLeft,
                child:Text("We sent a code to:${widget.email}",style:const TextStyle(color:Colors.black54),),
              ),
              const SizedBox(height:18),
              Container(
                padding:const EdgeInsets.all(16),
                decoration:BoxDecoration(
                  color:Colors.white,
                  borderRadius:BorderRadius.circular(16),
                  boxShadow:[
                    BoxShadow(
                      color:Colors.black.withOpacity(0.06),
                      blurRadius:14,
                      offset:const Offset(0, 6),
                    ),
                  ],
                ),
                child:Column(
                  children:[
                    TextField(
                      controller:_codeCtrl,
                      keyboardType:TextInputType.number,
                      decoration:const InputDecoration(labelText:"6-digit code",border:OutlineInputBorder(),),
                    ),
                    const SizedBox(height:20),
                    SizedBox(
                      width:double.infinity,
                      height:48,
                      child:ElevatedButton(
                        style:ElevatedButton.styleFrom(
                          backgroundColor:Colors.black,
                          foregroundColor:Colors.white,
                          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12),),
                        ),
                        onPressed:_loading?null:_verify,
                        child:_loading? const SizedBox(width: 22,height: 22,child: CircularProgressIndicator(strokeWidth: 2),):const Text("Verify"),
                      ),
                    ),
                    const SizedBox(height:8),
                    TextButton(
                      onPressed:_loading? null:_resend,
                      child:const Text("Resend code",style:TextStyle(color:Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}