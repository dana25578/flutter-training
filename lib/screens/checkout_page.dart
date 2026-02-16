import 'package:flutter/material.dart';
import '../services/session_service.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
class CheckoutPage extends StatelessWidget{
  static const String routeName='/checkout';
  const CheckoutPage({super.key});
  static const double deliveryFee=5.0;
  @override
  Widget build(BuildContext context){
    final user=SessionService.currentUser.value;
    if(user==null){
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
    }
    final address=(user.address??'').trim();
    if (address.isEmpty){
      Future.microtask((){
        Navigator.pushNamed(context, ProfilePage.routeName,arguments: {"id":user.id,"username":user.username,"email":user.email,});
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartService.instance.cart,
        builder: (context,items,_){
          if (items.isEmpty){
            return const Center(child: Text("your basket is empty"));
          }
          final subtotal=CartService.instance.totalPrice;
          final total=subtotal+deliveryFee;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _card(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Delivery info",style: TextStyle(fontWeight: FontWeight.bold,fontSize:16 ),
                    ),
                    const SizedBox(height: 10),
                    Text("Name:${user.username}"),
                    Text("Phone:${user.phoneNumber??''}"),
                    const SizedBox(height: 6),
                    Text("Address:$address"),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, ProfilePage.routeName,arguments: {
                            "id":user.id,
                            "username":user.username,
                            "email":user.email,
                          });
                        },
                        child: const Text("edit address"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _card(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("order summary",style:TextStyle(fontWeight: FontWeight.bold,fontSize:16 ),),
                    const SizedBox(height: 10),
                    ...items.map(_summaryRow).toList(),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [const Text("Subtotal"),Text("\$${subtotal.toStringAsFixed(0)}")],
                    ),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      const Text("Delivery fee"),
                      Text("\$${deliveryFee.toStringAsFixed(0)}"),
                    ],),
                    const Divider(height: 24),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text("Total", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                      Text("\$${total.toStringAsFixed(0)}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                    ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
                onPressed: (){
                CartService.instance.cart.value=[];
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order placed")),);
                Navigator.pushReplacementNamed(context, HomePage.routeName);
                },
                child: const Text("Place order"),
              ),
              ),
            ],
          );
        },
      ),
    );
  }
  static Widget _card(Widget child){
    return Container(
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
      child: child,
    );
  }
  static Widget _summaryRow(CartItem item){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(item.image,width: 60,height: 60,fit: BoxFit.cover,),
          ),
          const SizedBox(width: 12),
         Expanded(child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [Text(item.name,style: const TextStyle(fontWeight: FontWeight.bold),),
           const SizedBox(height: 4),
             Text("x${item.quantity}",style: const TextStyle(color: Colors.black54),),
           ],
         ),
         ),
          Text("\$${(item.price*item.quantity).toStringAsFixed(0)}",style: const TextStyle(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}