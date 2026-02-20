import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
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
  void addProduct(Map<String,dynamic>product){
    final List<CartItem> items=List.from(cart.value);
    final int pid=product["id"]as int;
    final int index=items.indexWhere((item) =>item.productId==pid );
    if(index==-1){
      items.add(CartItem(productId: pid, name: product['name'], price: (product['price']as num).toDouble(), image: product['image'],));
    }else{
      items[index]=items[index].copyWith(
        quantity:items[index].quantity+1,
      );
    }
    cart.value=items;
  }
  void removeItem(CartItem item){
    final List<CartItem> items =List.from(cart.value);
    items.remove(item);
    cart.value=items;
  }
  void increase (CartItem item){
    final List<CartItem> items=List.from(cart.value);
    final int index =items.indexOf(item);
    items[index]=items[index].copyWith(quantity: items[index].quantity+1);
    cart.value=items;
  }
  void decrease(CartItem item){
    final List<CartItem> items=List.from(cart.value);
    final int index=items.indexOf(item);
    if (items[index].quantity>1){
      items[index]=items[index].copyWith(quantity: items[index].quantity-1);
    }else{
      items.removeAt(index);
    }
    cart.value=items;
  }
}