import 'package:flutter/material.dart';
class CategoryItemsPage extends StatelessWidget{
  static const String routeName='/category-items';

  @override
  Widget build(BuildContext context){
    Map<String,dynamic>? args=ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
    String categoryName= args!['categoryName'];
    List items= args['items'];
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(categoryName),
      ),
      body: ListView.builder(padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context,index){
          Map item =items [index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0,8),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.asset(item['image'],width: 52,height: 52,fit: BoxFit.cover,)
              ),
              title: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(item['description']),
              ),
              trailing: Text(
                  '\$${item['price']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )
              ),
            ),
          );
        },
      ),
    );
  }
}