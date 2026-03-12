class OrderItemModel{
  final int productId;
  final String productName;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
  });
  factory OrderItemModel.fromJson(Map<String,dynamic> json){
    return OrderItemModel(
      productId:(json["productId"]??0) as int,
      productName:(json["productName"]??"").toString(),
      imageUrl:json["imageUrl"] as String?,
      quantity:(json["quantity"]??0) as int,
      unitPrice:((json["unitPrice"]??0) as num).toDouble(),
    );
  }
}
class OrderModel{
  final int id;
  final int userId;
  final String address;
  final double total;
  final String createdAt;
  final List<OrderItemModel> items;
  OrderModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.total,
    required this.createdAt,
    required this.items,
  });
  factory OrderModel.fromJson(Map<String,dynamic> json){
    final List<dynamic> rawItems=(json["items"]??[]) as List<dynamic>;
    return OrderModel(
      id:(json["id"]??0) as int,
      userId:(json["userId"]??0) as int,
      address:(json["address"]??"").toString(),
      total:((json["total"]??0) as num).toDouble(),
      createdAt:(json["createdAt"]??"").toString(),
      items:rawItems.map((item){
        return OrderItemModel.fromJson(item as Map<String,dynamic>);
      }).toList(),
    );
  }
}