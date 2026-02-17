import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/user_service.dart';
import '../services/session_service.dart';
class ProfilePage extends StatefulWidget{
  static const String routeName='/profile';
  final int id;
  final String username;
  final String email;
  const ProfilePage({super.key,
    required this.id,
    required this.username,
    required this.email,
  });
  @override
  State<ProfilePage> createState(){
    return _ProfilePageState();
  }
}
class _ProfilePageState extends State<ProfilePage>{
  bool _loading=true;
  String? _loadError;
  File? _profileImage;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  final TextEditingController _phoneController =TextEditingController();
  final TextEditingController _addressController =TextEditingController();
  @override
  void initState(){
    super.initState();
    _usernameController=TextEditingController(text: widget.username);
    _emailController=TextEditingController(text: widget.email);
    _phoneController.text="";
    _addressController.text="";
    _loadUser();
  }
  @override
  void dispose(){
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  Future<void> _pickImage() async{
    final ImagePicker picker=ImagePicker();
    final XFile? file=await picker.pickImage(source: ImageSource.gallery);
    if (file==null) return;
    setState(() {
      _profileImage=File(file.path);
    });
  }
  Future<void> _loadUser() async{
    setState(() {
      _loading=true;
      _loadError=null;
    });
    try{
      final data=await UserService.getUserById(widget.id);
      _usernameController.text=(data["username"]??"").toString();
      _emailController.text=(data["email"]??"").toString();
      _phoneController.text=(data["phoneNumber"]??"").toString();
      _addressController.text=(data["address"]??"").toString();
      final current =SessionService.currentUser.value;
      if (current!=null && current.id==widget.id){
        current.username=_usernameController.text;
        current.email=_emailController.text;
        current.phoneNumber=_phoneController.text;
        current.address=_addressController.text;
        SessionService.currentUser.value=current;
      }
    }catch(e){
      _loadError=e.toString();
    }setState(() {
      _loading=false;
    });
  }
  Widget _card(Widget child){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
  InputDecoration _input(String label){
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }
  Future<void> _save() async{
    final newUsername=_usernameController.text.trim();
    final newEmail=_emailController.text.trim();
    final newPhone=_phoneController.text.trim();
    final newAddress=_addressController.text.trim();
    if(newUsername.isEmpty|| newEmail.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("username and email are required")),);
      return;
    }
    if(newPhone.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("phone number is required")),);
      return;
    }
    try{
      final updated=await UserService.updateUser(id: widget.id, username: newUsername, email: newEmail,phoneNumber:newPhone,address:newAddress);
      final current=SessionService.currentUser.value;
      if (current!=null){
        current.username=updated["username"]??current.username;
        current.email=updated["email"]?? current.email;
        current.phoneNumber=updated["phoneNumber"]?? current.phoneNumber;
        current.address=updated["address"]??current.address;
        SessionService.currentUser.value=current;
        SessionService.currentUser.notifyListeners();
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("profile updated successfully")),);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("update failed:$e")),);
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: _loading
            ?const Center(child: CircularProgressIndicator())
            :(_loadError!=null ? Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text("failed to load profile:\n$_loadError"),
              const SizedBox(height: 12),
                ElevatedButton(onPressed: _loadUser, child: const Text("retry"),
                ),
              ],
            ),
          ),
        )
        :SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _card(Column(children: [GestureDetector(onTap: _pickImage,child: CircleAvatar(
                radius: 46,
                backgroundColor: const Color(0xFFF1F5F9),
                backgroundImage: _profileImage!=null?FileImage(_profileImage!):null,
                child: _profileImage==null?const Icon(Icons.camera_alt,color: Colors.black54):null,
              ),
              ),
                const SizedBox(height: 10),
                const Text('Tap to change photo',style: TextStyle(fontSize: 12,color: Colors.black54),),
                const SizedBox(height: 16),
                TextField(controller: _usernameController,decoration: _input('username'),),
                const SizedBox(height: 16),
                TextField(controller: _emailController,decoration: _input('email'),),
                const SizedBox(height:16),
                TextField(controller: _phoneController,decoration: _input('phone'),keyboardType: TextInputType.phone,),
                const SizedBox(height: 16),
                TextField(controller: _addressController,decoration: _input('address'),),
              ],
              ),
              ),
              const SizedBox(height: 14),
              SizedBox(width: double.infinity,height: 48,child: ElevatedButton(style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
              ), onPressed: _save,
                child: const Text('save'),
              ),
              ),
            ],
          ),
        )
        ),
      ),
    );
  }
}