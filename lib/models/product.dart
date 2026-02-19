class Product{
  final int id;
  final String name;
  final String?description;
  final double price;
  final String?imageUrl;
  final int categoryId;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
  });
  factory Product.fromJson(Map<String,dynamic> json){
    final num p =json["price"] as num;
    return Product(id: (json["id"]??0) as int, name:(json["name"]??"").toString(), description:json["description"]?.toString(), price: p.toDouble(), imageUrl: json["imageUrl"] as String?, categoryId:(json["categoryId"]??0)as int, );
  }
}