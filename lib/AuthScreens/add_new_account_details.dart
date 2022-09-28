import 'dart:io';
import 'package:chat2/bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shopped/bottom_nav.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:path/path.dart' as path;

class AddNewAccountDetails extends StatefulWidget {
  const AddNewAccountDetails({Key? key}) : super(key: key);

  @override
  State<AddNewAccountDetails> createState() => _AddNewAccountDetailsState();
}

class _AddNewAccountDetailsState extends State<AddNewAccountDetails> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore? _firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController _fullName;
  bool _isLoading = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController();
  }

  Future<void> _openImagePicker() async {
    final _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String?> _upload(String fileName, File? imageFile) async {
    try {
      // Uploading the selected image with some custom meta data
      final uploadTask = await _storage
          .ref("profiles/$fileName")
          .child(fileName)
          .putFile(
              imageFile ?? File(''),
              SettableMetadata(customMetadata: {
                'uploaded_by': 'user',
                'description': 'Some description...'
              }));
      var downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Text("Looks like it's your first time here... ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: textLarge,
                    fontWeight: FontWeight.w700,
                    color: SecondaryDarkGrey)),
            const SizedBox(height: 50),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: (_image != null) ?
                    Image.file(_image!, fit: BoxFit.cover,).image
                        :
                    const AssetImage("assets/profile.jpg"),
                  ),
                  Positioned(
                      right: -10,
                      bottom: -15,
                      child: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 26,
                            color: PrimaryBlueOcean,
                          ),
                          onPressed: () => _openImagePicker(),
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _fullName,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your full name";
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  label: Text("Full name"),
                  hintText: "Full name"),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getString('userId') ?? '';
                final phone = prefs.getString('phoneNumber') ?? '';
                final name = _fullName.text.trim();
                final imageUrl = await _upload(userId, _image);
                await prefs.setString('imageUrl', imageUrl ?? "");
                await prefs.setString('fullName', name);

                await Repository().createBuyer(userId, phone, name, imageUrl!);
                setState(() {
                  _isLoading = false;
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>  BottomNav()));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: PrimaryBlueOcean,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: (_isLoading == false) ?
                  const Text(
                    "Continue",
                    style: TextStyle(fontSize: textMedium, color: Colors.white)
                  ) :
                  Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
