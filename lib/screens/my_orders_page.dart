import 'package:flutter/material.dart';
class MyOrdersPage extends StatelessWidget{
  static const String routeName='/my-orders';
  const MyOrdersPage({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(backgroundColor:const Color(0xFFF6F6F6),
      appBar:AppBar(
        backgroundColor:Colors.white,
        foregroundColor:Colors.black,
        elevation:0,
        title:const Text("My orders"),
      ),
      body:const Center(
        child:Text("i will add it next",style:TextStyle(fontSize:16,fontWeight:FontWeight.w500,),),
      ),
    );
  }
}