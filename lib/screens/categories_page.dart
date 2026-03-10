import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import 'category_items_page.dart';
class CategoriesPage extends StatelessWidget{
  static const String routeName='/categories';
  const CategoriesPage({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color(0xFFF6F7FB),
      appBar:AppBar(
        title:const Text("Categories",style:TextStyle(fontWeight:FontWeight.w600,color:Colors.black,),),
        backgroundColor:Colors.white,
        foregroundColor:Colors.black,
        elevation:0,
      ),
      body:FutureBuilder<List<Category>>(
        future:CategoryService.getCategories(),
        builder:(context,snapshot){
          if (snapshot.connectionState==ConnectionState.waiting){
            return const Center(child:CircularProgressIndicator());
          }
          if (snapshot.hasError){
            return Center(
              child:Padding(
                padding:const EdgeInsets.all(16),
                child:Text("failed to load categories:\n${snapshot.error}",textAlign:TextAlign.center,),
              ),
            );
          }
          final List<Category> categories=snapshot.data??[];
          if (categories.isEmpty){
            return const Center(child: Text("no categories found"),);
          }
          return ListView.builder(
            padding:const EdgeInsets.all(16),
            itemCount:categories.length,
            itemBuilder:(context,index){
              final Category category=categories[index];
              return GestureDetector(
                onTap:(){Navigator.pushNamed(context,CategoryItemsPage.routeName,arguments:{"categoryId":category.id,"categoryName":category.name,},);},
                child:Container(
                  margin:const EdgeInsets.only(bottom:14),
                  padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),
                  decoration:BoxDecoration(color:const Color(0xFFFFFFFF),borderRadius:BorderRadius.circular(18),
                  ),
                  child:Row(
                    children:[
                      Container(
                        width:42,
                        height:42,
                        decoration:BoxDecoration(
                          color:const Color(0xFFF7F7F7),
                          borderRadius:BorderRadius.circular(12),
                        ),
                        child:Icon(_getCategoryIcon(category.name),color:Colors.black87,size:20,),
                      ),
                      const SizedBox(width:14),
                      Expanded(
                        child:Text(category.name,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w600,color:Colors.black,),),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  static IconData _getCategoryIcon(String categoryName){
    final name=categoryName.toLowerCase();
    if (name.contains('shoe')){
      return Icons.shopping_bag_outlined;
    }else if (name.contains('bag')){
      return Icons.work_outline;
    }else if (name.contains('watch')){
      return Icons.watch_outlined;
    }else if (name.contains('cloth')){
      return Icons.checkroom_outlined;
    }else{
      return Icons.grid_view_rounded;
    }
  }
}