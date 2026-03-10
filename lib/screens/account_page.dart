import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'my_orders_page.dart';
class AccountPage extends StatelessWidget{
  static const String routeName='/account';
  const AccountPage({super.key});
  void _logout(BuildContext context){
    SessionService.clear();
    Navigator.pushNamedAndRemoveUntil(context,LoginPage.routeName,(route){return false;},);
  }
  Widget _menuCard({required IconData icon,required String title,required VoidCallback onTap,}){
    return GestureDetector(
      onTap:onTap,
      child:Container(
        margin:const EdgeInsets.only(bottom:14),
        padding:const EdgeInsets.symmetric(horizontal:14,vertical:10),
        decoration:BoxDecoration(color:const Color(0xFFFFFFFF),borderRadius:BorderRadius.circular(18),
        ),
        child:Row(
          children:[
            Container(width:42,height:42,
              decoration: BoxDecoration(color:const Color(0xFFF7F7F7),borderRadius:BorderRadius.circular(12),),
              child:Icon(icon,size:20,color:Colors.black87,),
            ),
            const SizedBox(width:14),
            Expanded(
              child:Text(title,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w600,color:Colors.black,),),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    final user=SessionService.currentUser.value;
    return Scaffold(
      backgroundColor:const Color(0xFFF6F7FB),
      appBar:AppBar(
        backgroundColor:Colors.white,
        foregroundColor:Colors.black,
        elevation:0,
        title:const Text("Account",style: TextStyle(fontWeight:FontWeight.w600,color:Colors.black,),),
      ),
      body:SafeArea(
        child:SingleChildScrollView(
          padding:const EdgeInsets.all(16),
          child:Column(
            children:[
              _menuCard(icon:Icons.person_outline,title:"Profile",
                onTap:(){
                  if (user==null){
                    Navigator.pushNamed(context,LoginPage.routeName);
                    return;
                  }
                  Navigator.pushNamed(context,ProfilePage.routeName,arguments:{"id":user.id,"username":user.username,"email":user.email,},);
                },
              ),
              _menuCard(icon:Icons.inventory_2_outlined,title:"My orders",
                onTap:(){
                  Navigator.pushNamed(context,MyOrdersPage.routeName);
                },
              ),
              _menuCard(icon:Icons.logout,title:"Logout",
                onTap:(){
                  _logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}