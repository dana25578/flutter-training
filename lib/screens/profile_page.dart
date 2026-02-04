import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ProfilePage extends StatefulWidget{
  static const String routeName='/profile';
  final String username;
  final String email;
  const ProfilePage({super.key,
    required this.username,
    required this.email,
  });
  @override
  State<ProfilePage> createState(){
    return _ProfilePageState();
  }
}
class _ProfilePageState extends State<ProfilePage>{
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
  void _save(){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved (local)')),
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _card(Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage, child: CircleAvatar(
                    radius: 46,
                    backgroundColor: const Color(0xFFF1F5F9),
                    backgroundImage: _profileImage!=null? FileImage(_profileImage!):null,
                    child: _profileImage==null?const Icon(Icons.camera_alt,color:Colors.black54):null,
                  ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Tap to change photo', style: TextStyle(fontSize: 12,color: Colors.black54),),
                  const SizedBox(height: 16),
                  TextField(
                    controller:_usernameController,
                    decoration: _input('Username'),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: _emailController,decoration: _input('Email'),readOnly: true,),
                ],
              ),
              ),
              const SizedBox(height: 14),
              _card(Column(
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: _input('Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    decoration: _input('Adress'),
                  ),
                ],
              ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _save,
                  child: const Text ('Save'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}