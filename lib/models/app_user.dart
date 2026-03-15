class AppUser{
  final int id;
  String username;
  String email;
  String? phoneNumber;
  String? address;
  String? profileImage;
  AppUser({required this.id, required this.username, required this.email,required this.phoneNumber,required this.address,this.profileImage,});
  factory AppUser.fromJson(Map<String,dynamic>json){
    return AppUser(id: (json['id']), username: (json['username']??'')as String, email: (json['email']??'')as String,phoneNumber: json['phoneNumber'] as String?,address: json['address']as String?,profileImage:json["profileImage"] as String?,);
  }
  Map<String,dynamic> toJson(){
    return {"id":id,"username":username,"email":email,"phoneNumber":phoneNumber,"address":address,"profileImage":profileImage,};
  }
}