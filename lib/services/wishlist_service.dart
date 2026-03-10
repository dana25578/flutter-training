import 'package:flutter/foundation.dart';
import '../models/product.dart';
class WishlistService{
  WishlistService._();
  static final WishlistService instance=WishlistService._();
  final ValueNotifier<List<Product>> wishlist=ValueNotifier<List<Product>>([]);
  bool isInWishlist(Product product){
    return wishlist.value.any((item){
      return item.id==product.id;
    });
  }
  void toggleProduct(Product product){
    final List<Product> items=List<Product>.from(wishlist.value);
    final int index=items.indexWhere((item){
      return item.id==product.id;
    });
    if (index==-1){
      items.add(product);
    }else{
      items.removeAt(index);
    }
    wishlist.value=items;
  }
}