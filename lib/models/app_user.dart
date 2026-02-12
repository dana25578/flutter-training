class AppUser{
  final int id;
  String username;
  String email;
  AppUser({required this.id, required this.username, required this.email});
  factory AppUser.fromJson(Map<String,dynamic>json){
    return AppUser(id: (json['id']), username: (json['username']??'')as String, email: (json['email']??'')as String,);
  }
}