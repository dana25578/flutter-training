class AppUser{
  final int id;
  String username;
  String email;
  String? phoneNumber;
  String? address;
  AppUser({required this.id, required this.username, required this.email,required this.phoneNumber,required this.address});
  factory AppUser.fromJson(Map<String,dynamic>json){
    return AppUser(id: (json['id']), username: (json['username']??'')as String, email: (json['email']??'')as String,phoneNumber: json['phoneNumber'] as String?,address: json['address']as String?,);
  }
}