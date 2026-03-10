import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import '../screens/account_page.dart';
class AppBottomNav extends StatelessWidget{
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  Widget _buildBadgeIcon({
    required IconData icon,
    required int count,
  }){return Stack(
      clipBehavior:Clip.none,
      children:[
        Icon(icon),
        if (count>0)
          Positioned(right:-8,top:-6,
            child:Container(
              padding:const EdgeInsets.symmetric(horizontal:6,vertical:2),
              decoration: BoxDecoration(
                color:Colors.redAccent,
                borderRadius:BorderRadius.circular(12),
              ),
              child:Text("$count",style:const TextStyle(color:Colors.white,fontSize:10,fontWeight:FontWeight.bold,),),
            ),
          ),
      ],
    );
  }
  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable:WishlistService.instance.wishlist,
      builder:(context,wishlistItems,child){
        return ValueListenableBuilder<List<dynamic>>(
          valueListenable:CartService.instance.cart,
          builder:(context,cartItems,child){
            final int cartCount=CartService.instance.totalItems;
            final int wishlistCount=WishlistService.instance.wishlist.value.length;
            return BottomNavigationBar(
              currentIndex:currentIndex,
              onTap:onTap,
              type:BottomNavigationBarType.fixed,
              backgroundColor:Colors.white,
              elevation:10,
              selectedItemColor:Colors.black,
              unselectedItemColor:Colors.grey,
              items:[
                const BottomNavigationBarItem(icon:Icon(Icons.home_filled),label:"Home",),
                const BottomNavigationBarItem(icon:Icon(Icons.grid_view_outlined),label:"Categories",),
                BottomNavigationBarItem(icon:_buildBadgeIcon(icon:Icons.shopping_cart_outlined,count:cartCount,),label:"Cart",),
                BottomNavigationBarItem(icon:_buildBadgeIcon(icon:Icons.favorite_border,count:wishlistCount,),label:"Wishlist",),
                const BottomNavigationBarItem(icon:Icon(Icons.person_outline),label:"Account",),
              ],
            );
          },
        );
      },
    );
  }
}