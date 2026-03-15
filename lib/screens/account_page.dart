import 'package:app/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'my_orders_page.dart';
import 'signup_page.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
class AccountPage extends StatelessWidget{
  static const String routeName='/account';
  const AccountPage({super.key});
  Future <void> _logout(BuildContext context) async{
    await CartService.instance.clearAll();
    await WishlistService.instance.clearAll();
    await SessionService.clear();
    Navigator.pushNamedAndRemoveUntil(context,HomePage.routeName,(route){return false;},);
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
  Widget _guestCard(){
    return Container(
      width:double.infinity,
      margin:const EdgeInsets.only(bottom:16),
      padding:const EdgeInsets.all(18),
      decoration:BoxDecoration(
        color:Colors.white,
        borderRadius:BorderRadius.circular(18),
      ),
      child:const Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          Text("Guest mode",style:TextStyle(fontSize:18,fontWeight:FontWeight.w700,color:Colors.black,),),
          SizedBox(height:8),
          Text("you can browse products, add items to cart, and use wishlist as a guest. To checkout,save your profile,and view your orders,please login or sign up.",
            style: TextStyle(fontSize:14,color:Colors.black87,height:1.4,),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    final user=SessionService.currentUser.value;
    final bool isLoggedIn=user!=null;
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
              if (!isLoggedIn) _guestCard(),
              if (isLoggedIn) ...[
                _menuCard(
                  icon:Icons.person_outline,
                  title:"Profile",
                  onTap:(){
                    Navigator.pushNamed(context,ProfilePage.routeName,arguments:{"id":user.id,"username":user.username,"email":user.email,},);
                  },
                ),
                _menuCard(
                  icon:Icons.inventory_2_outlined,
                  title:"My orders",
                  onTap:() {
                    Navigator.pushNamed(context,MyOrdersPage.routeName);
                  },
                ),
                _menuCard(
                  icon:Icons.logout,
                  title:"Logout",
                  onTap:() async{
                    await _logout(context);
                  },
                ),
              ]else ...[
                _menuCard(
                  icon:Icons.login,
                  title:"Login",
                  onTap:(){
                    Navigator.pushNamed(context,LoginPage.routeName);
                  },
                ),
                _menuCard(
                  icon:Icons.person_add_alt_1_outlined,
                  title:"Sign up",
                  onTap:(){
                    Navigator.pushNamed(context,SignupPage.routeName);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}