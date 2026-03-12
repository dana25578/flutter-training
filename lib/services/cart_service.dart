import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import 'cart_api_service.dart';
import 'session_service.dart';
class CartService{
  CartService._();
  static final CartService instance =CartService._();
  final ValueNotifier<List<CartItem>> cart = ValueNotifier([]);
  int get totalItems{
    int count=0;
    for (final item in cart.value){
      count +=item.quantity;
    }
    return count;
  }
  double get totalPrice{
    double total=0;
    for (final item in cart.value){
      total+=item.price*item.quantity;
    }
    return total;
  }
  Future<void> loadCartFromBackend() async{
    if (!SessionService.isLoggedIn){
      return;
    }
    final List<CartItem> items=await CartApiService.getMyCart();
    cart.value=items;
  }
  Future<void> addProduct(Map<String,dynamic> product) async{
    final int pid=product["id"] as int;
    if (SessionService.isLoggedIn){
      final List<CartItem> existingItems=cart.value.where((item){
        return item.productId==pid;
      }).toList();
      int newQuantity=1;
      if (existingItems.isNotEmpty){
        newQuantity=existingItems.first.quantity+1;
      }
      final List<CartItem> items=await CartApiService.updateCartItem(productId:pid,quantity:newQuantity,);
      cart.value=items;
      return;
    }
    final List<CartItem> items=List<CartItem>.from(cart.value);
    final int index=items.indexWhere((item){
      return item.productId==pid;
    });
    if (index==-1){
      items.add(CartItem(productId:pid,name:product['name'],price:(product['price'] as num).toDouble(),image:product['image'],quantity:1,),);
    }else{
      items[index]=items[index].copyWith(quantity:items[index].quantity+1,);
    }
    cart.value=items;
  }
  Future<void> removeItem(CartItem item) async{
    if (SessionService.isLoggedIn){
      final List<CartItem> items=await CartApiService.updateCartItem(productId:item.productId,quantity:0,);
      cart.value=items;
      return;
    }
    final List<CartItem> items=List<CartItem>.from(cart.value);
    items.remove(item);
    cart.value=items;
  }
  Future<void> increase(CartItem item) async{
    if (SessionService.isLoggedIn){
      final List<CartItem> items=await CartApiService.updateCartItem(productId:item.productId,quantity:item.quantity+1,);
      cart.value=items;
      return;
    }
    final List<CartItem> items=List<CartItem>.from(cart.value);
    final int index=items.indexOf(item);
    items[index]=items[index].copyWith(quantity:items[index].quantity+1,);
    cart.value=items;
  }
  Future<void> decrease(CartItem item) async{
    if (SessionService.isLoggedIn){
      final int newQuantity=item.quantity-1;
      final List<CartItem> items=await CartApiService.updateCartItem(productId:item.productId,quantity:newQuantity,);
      cart.value=items;
      return;
    }
    final List<CartItem> items=List<CartItem>.from(cart.value);
    final int index=items.indexOf(item);
    if (items[index].quantity>1){items[index]=items[index].copyWith(quantity:items[index].quantity-1,);
    }else{
      items.removeAt(index);
    }
    cart.value=items;
  }
  Future<void> clearAll() async{
    if (SessionService.isLoggedIn){
      await CartApiService.clearCart();
    }
    cart.value=[];
  }
}