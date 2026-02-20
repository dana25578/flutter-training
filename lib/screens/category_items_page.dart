import 'package:app/models/product.dart';
import 'package:app/services/cart_service.dart';
import 'package:app/services/product_service.dart';
import 'package:flutter/material.dart';
import 'basket_page.dart';
class CategoryItemsPage extends StatelessWidget{
  static const String routeName='/category-items';
  const CategoryItemsPage({super.key});
  @override
  Widget build(BuildContext context){
    final Map<String,dynamic>? args=ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
    final int categoryId=(args?["categoryId"]??0) as int;
    final String categoryName=(args?["categoryName"]??"Category").toString();
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(categoryName),
        actions: [IconButton(onPressed: (){
          Navigator.pushNamed(context, BasketPage.routeName);
        }, icon: const Icon(Icons.shopping_basket_outlined),),],
      ),
      body:FutureBuilder<List<Product>>(
        future: ProductService.getProductsByCategory(categoryId),
        builder: (context,snapshot){
          if (snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Failed to load products:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final List<Product> products= snapshot.data?? [];
          if(products.isEmpty){
            return const Center(child: Text("no products found"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context,index){
              final product=products[index];
              final imagePath= product.imageUrl??"assets/images/placeholder.png";
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical:8,horizontal:12 ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 52,
                      height: 52,
                      color: const Color(0xFFF3F4F6),
                      child: Image.asset(imagePath,fit: BoxFit.cover,),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:4),
                    child: Text(product.description??""),
                  ),
                  trailing: SizedBox(
                    width: 125,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width:10),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius:BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: (){
                              CartService.instance.addProduct({
                                "id":product.id,
                                'name':product.name,
                                'price':product.price,
                                'image':imagePath,
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${product.name} added to cart"),duration: const Duration(milliseconds: 800),),);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

    );
  }
}