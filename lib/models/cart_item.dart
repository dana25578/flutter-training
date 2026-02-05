class CartItem{
  final String name;
  final double price;
  final String image;
  final int quantity;
  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity=1,
});
  CartItem copyWith({
    String? name,
    double? price,
    String? image,
    int? quantity,
}) {
    return CartItem(name: name ?? this.name, price: price ?? this.price, image: image ?? this.image, quantity: quantity?? this.quantity);
  }
}