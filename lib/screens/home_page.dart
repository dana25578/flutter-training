import 'package:app/screens/category_items_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget{
  static const String routeName='/home';
  HomePage ({super.key});
  final String userName='dana';
  final List<Map<String,dynamic>> categories=[
    { 'name':'Shoes',
      'image':'assets/images/sneakers.webp',
      'items':[
        {'name': 'Running Shoes','price':60,'description':'comfortable','image':'assets/images/running shoes.jpeg',},
        {'name':'Sneakers','price':45,'description':'casual style','image':'assets/images/air sneakers.jpeg',},
        {'name': 'Training Shoes','price':55,'description':'lightweight','image':'assets/images/training shoes.jpeg',},
      ],},
    { 'name':'Bags',
      'image':'assets/images/backpack.jpeg',
      'items':[
        {'name': 'Backpack','price':60,'description':'for school','image':'assets/images/backpack.jpeg',},
        {'name':'HandBag','price':45,'description':'daily use','image':'assets/images/handbag.webp',},
        {'name': 'Travel bag','price':55,'description':'large capacity','image':'assets/images/travel bag.jpeg',},
      ],},
      {'name':'Watches',
      'image':'assets/images/smart watch.jpeg',
      'items':[
        {'name': 'classic watch','price':60,'description':'elegant','image':'assets/images/classic watch.jpeg',},
        {'name':'sport watch','price':45,'description':'waterproof','image':'assets/images/sport watch.jpeg',},
        {'name': 'Smart watch','price':55,'description':'modern','image':'assets/images/smart watch.jpeg',},
      ],},
    {'name':'Clothes',
      'image':'assets/images/tshirt.jpeg',
      'items':[
        {'name': 'T-shirt','price':60,'description':'cotton','image':'assets/images/smart watch.jpeg',},
        {'name':'jacket','price':45,'description':'comfy','image':'assets/images/jacket.jpeg',},
        {'name': 'jeans','price':55,'description':'regular fit','image':'assets/images/jeans.jpeg',},
      ],
    }
  ];
  final List<Map<String,dynamic>> products =[
    {'name':'air sneakers','price':49,'image':'assets/images/air sneakers.jpeg',},
    {'name':'leather jacket','price':49,'image':'assets/images/leather jacket.jpeg',},
    {'name':'classic watch','price':49,'image':'assets/images/classic watch.jpeg',},
    {'name':'jeans','price':49,'image':'assets/images/jeans.jpeg',},
    {'name':'running shoes','price':49,'image':'assets/images/running shoes.jpeg',},
    {'name':'smart watch','price':49,'image':'assets/images/smart watch.jpeg',},
  ];
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
                Navigator.pushNamed(context, ProfilePage.routeName, arguments: {'username':userName,'email':'dana@email.com'},);
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
                Text(
                  userName, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
              icon:const Icon(Icons.logout),
              onPressed: (){
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildCategories(context),
            ),
          ),
          const SizedBox(height:20),
          const  Text('Products',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder( itemCount: products.length,shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemBuilder:(context,index){
                Map<String,dynamic> product=products[index];
                return _buildProductCard(product);
              },
          ),
        ],
      ),
    );
  }
  List<Widget> _buildCategories(BuildContext context){
    List<Widget> widgets=[];
    for(int i=0; i<categories.length;i++){
      Map<String,dynamic> category = categories[i];
      widgets.add(
        Padding(padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: (){
              Navigator.pushNamed(context, CategoryItemsPage.routeName,arguments: {
                'categoryName':category['name'],
                'items':category['items'],
              },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(category['image'],width: 22,height: 22,fit: BoxFit.cover,),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category['name'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
  Widget _buildProductCard(Map<String,dynamic> product){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container(
              width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),

                child:ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(product['image'],fit: BoxFit.cover,),
                )
              ),
              ),
            const SizedBox(height: 10),
            Text(
              product['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight:FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('\$${product['price']}', style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}