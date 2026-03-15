import 'package:flutter/foundation.dart';
import '../models/product.dart';
import 'wishlist_api_service.dart';
import 'session_service.dart';
class WishlistService{
  WishlistService._();
  static final WishlistService instance=WishlistService._();
  final ValueNotifier<List<Product>> wishlist=ValueNotifier<List<Product>>([]);
  bool isInWishlist(Product product){
    return wishlist.value.any((item){
      return item.id==product.id;
    });
  }
  Future<void> loadWishlistFromBackend() async{
    if (!SessionService.isLoggedIn) return;
    final items=await WishlistApiService.getMyWishlist();
    wishlist.value=items;
  }
  Future<void> toggleProduct(Product product)async{
    if (SessionService.isLoggedIn){
      final items=await WishlistApiService.toggleProduct(product.id);
      wishlist.value=items;
      return;
    }
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
  Future<void> clearAll() async{
    if (SessionService.isLoggedIn){
      await WishlistApiService.clearWishlist();
    }
    wishlist.value=[];
  }
}