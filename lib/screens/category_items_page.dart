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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text("Category:$categoryName(ID:$categoryId) products are still as listtt hardcodedd", textAlign: TextAlign.center,style: const TextStyle(fontSize: 16),),
        ),
      ),
    );
  }
}