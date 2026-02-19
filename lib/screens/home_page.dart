import 'package:app/screens/category_items_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'profile_page.dart';
import '../services/cart_service.dart';
import 'basket_page.dart';
import '../services/session_service.dart';
import '../services/category_service.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/product_service.dart';
class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  HomePage({super.key});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: (){
                final user=SessionService.currentUser.value;
                if(user==null){
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                  return;
                }
                Navigator.pushNamed(context, ProfilePage.routeName,arguments: {'id':user?.id,'username':user?.username??'User','email':user?.email?? 'user@gmail.com',},);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person,color: Colors.white),
              ),
            ),
            const SizedBox(width:12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome', style: TextStyle(fontSize: 12,color: Colors.black54),
                ),
                ValueListenableBuilder(valueListenable: SessionService.currentUser, builder: (context,user, _){
                  final name=user?.username??'User';
                  return Text(name, style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),);
                },
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, BasketPage.routeName);
          }, icon: Icon (Icons.shopping_basket_outlined),),
          IconButton(
              icon:const Icon(Icons.logout),
              onPressed: (){
                SessionService.clear();
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(colors: [Color(0xFF111827), Color(0xFF374151)],
              ),
            ),
            child: Row(
              children: [
                Expanded(child: Text(
                  'Discover new products \nand best deals!',
                  style: const TextStyle(
                    color:Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                 ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shopping_bag,color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Categories',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Category>>(
            future: CategoryService.getCategories(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Padding(padding: EdgeInsets.all(12),child: Center(child:CircularProgressIndicator()),);
              }
              if(snapshot.hasError){
              return Padding(padding:const EdgeInsets.all(12),child:Text("Failed to load categories:"+snapshot.error.toString()),);
              }
              final List<Category> categories=snapshot.data??[];
              if(categories.isEmpty){
                return const Padding(padding: EdgeInsets.all(12),child: Text("No categories found"),);
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: _buildCategoriesFromApi(context,categories),),
              );
            },

          ),
          const SizedBox(height:20),
          const  Text('Products',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Product>>(
            future: ProductService.getAllProducts(),builder: (context,snapshot){
              if (snapshot.connectionState==ConnectionState.waiting){
                return const Padding(padding: EdgeInsets.all(12),
                  child: Center(child:CircularProgressIndicator()),
                );
              }
              if(snapshot.hasError){
                return Padding(padding: const EdgeInsets.all(12),
                  child: Text("Failed to load products:${snapshot.error}"),
                );
              }
              final products=snapshot.data??[];
              if (products.isEmpty){
                return const Padding(padding: EdgeInsets.all(12),
                  child: Text("no products found"),
                );
              }
              return GridView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.65,crossAxisSpacing: 12,mainAxisSpacing: 12,),
                itemBuilder: (context,index){
                  return _buildProductCardFromApi(products[index]);
                },
              );
          },
          )
        ],
      ),
    );
  }
  List<Widget> _buildCategoriesFromApi(BuildContext context,List<Category>categories){
    final List<Widget> widgets=[];
    for(int i=0;i<categories.length;i++){
      final Category category=categories[i];
      final String imagePath=category.imageUrl??"assets/images/placeholder.png";
      widgets.add(Padding(padding: const EdgeInsets.only(right: 10),child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: (){
          Navigator.pushNamed(context, CategoryItemsPage.routeName,arguments: {"categoryId":category.id,"categoryName":category.name});
        },
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 12),decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath,width: 22,height: 22,fit: BoxFit.cover,),
            ),
            const SizedBox(width: 8),
            Text(category.name,style: const  TextStyle(fontWeight: FontWeight.w600),),
          ],
        ),
        ),
      ),),);
    }
    return widgets;
  }
  Widget _buildProductCardFromApi(Product product){
    final imagePath=product.imageUrl?? "assets/images/placeholder.png";
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow:[
          BoxShadow(color: Colors.black.withOpacity(0.06),blurRadius: 12,offset: const Offset(0, 8),),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                child: Image.asset(imagePath,fit: BoxFit.contain,),
              ),
            ),
            ),
            const SizedBox(height: 10),
            Text(product.name,maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 4),
            Text(product.description??"",maxLines: 1,overflow:TextOverflow.ellipsis,style: const TextStyle(color: Colors.black54,fontSize: 12)),
            const SizedBox(height: 6),
            Text("\$${product.price.toStringAsFixed(0)}",style: const TextStyle(fontWeight:FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: (){
                  CartService.instance.addProduct({
                    "name":product.name,
                    "price":product.price,
                    "image":imagePath,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                ),
                child: const Text("Add to cart", style: TextStyle(fontSize: 13,fontWeight:FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}