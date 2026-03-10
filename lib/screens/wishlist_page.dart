import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
class WishlistPage extends StatelessWidget{
  static const String routeName='/wishlist';
  const WishlistPage({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(backgroundColor:const Color(0xFFF6F7FB),
      appBar:AppBar(
        title:const Text("Wishlist"),
        backgroundColor:Colors.white,
        foregroundColor:Colors.black,
        elevation:0,
      ),
      body:ValueListenableBuilder<List<Product>>(
        valueListenable:WishlistService.instance.wishlist,
        builder:(context,items,child){
          if (items.isEmpty){
            return const Center(
              child:Text("your wishlist is empty",style:TextStyle(fontSize:16),),
            );
          }
          return ListView.builder(
            padding:const EdgeInsets.all(16),
            itemCount:items.length,
            itemBuilder:(context, index){
              final product=items[index];
              final String imagePath=product.imageUrl??"";
              return Container(
                margin:const EdgeInsets.only(bottom:12),
                padding:const EdgeInsets.all(12),
                decoration:BoxDecoration(
                  color:Colors.white,
                  borderRadius:BorderRadius.circular(16),
                  boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.05),blurRadius:12,offset:const Offset(0, 8),),],
                ),
                child:Row(
                  children:[
                    ClipRRect(
                      borderRadius:BorderRadius.circular(12),
                      child:Container(
                        width:70,
                        height:70,
                        color:const Color(0xFFF3F4F6),
                        child:imagePath.isNotEmpty?Image.network("${AuthService.baseUrl}$imagePath",fit:BoxFit.cover,):const Icon(Icons.image_outlined),
                      ),
                    ),
                    const SizedBox(width:12),
                    Expanded(
                      child:Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children:[
                          Text(product.name,style:const TextStyle(fontWeight:FontWeight.bold,),),
                          const SizedBox(height: 4),
                          Text("\$${product.price.toStringAsFixed(0)}"),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed:(){
                        WishlistService.instance.toggleProduct(product);
                      },
                      icon:const Icon(Icons.favorite,color: Colors.red,),
                    ),
                    IconButton(
                      onPressed:(){
                        CartService.instance.addProduct({"id":product.id,"name":product.name,"price":product.price,"image":imagePath,});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("${product.name} added to cart"),duration:const Duration(milliseconds: 800),),);
                      },
                      icon:const Icon(Icons.add_shopping_cart),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}