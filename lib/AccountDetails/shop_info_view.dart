import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:path/path.dart' as path;

import '../bottom_nav.dart';
import '../data/models/seller_model.dart';
import '../data/repository/repository.dart';

class ShopInfoView extends StatefulWidget {
  ShopInfoView({Key? key,
    required this.ShopName,
    required this.Uid,
    required this.ShopImage,
    required this.Location,
    required this.AboutShop}) : super(key: key);


  String ShopName;
  String  Uid;
  String ShopImage;
  String Location;
  String AboutShop;

  @override
  State<ShopInfoView> createState() => _ShopInfoViewState();
}

CollectionReference question = FirebaseFirestore.instance.collection('Quiz');
//final currentuser = FirebaseAuth.instance.currentUser!.uid;


class _ShopInfoViewState extends State<ShopInfoView> {
  final _formKey = GlobalKey<FormState>();
  final Repository repo = Repository();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController _fullName = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _paymentMethod = TextEditingController();
  bool _isLoading = false;
  File? _image;
  String _id = "";
  String _imageUrl = "";



  @override
  void initState() {
    super.initState();

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

  Future<String?> _upload(String userId, String fileName, File? imageFile) async {
    try {
      // Uploading the selected image with some custom meta data
      final uploadTask = await _storage
          .ref("sellers/$userId")
          .child(fileName)
          .putFile(
              imageFile ?? File(''),
              SettableMetadata(customMetadata: {
                'uploaded_by': userId,
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
  Future<void> updateShopInfo(String id, String name, String location, String paymentMethod, String imageUrl) async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'ShopName': name,
      'coverImage': imageUrl,
      'ShopLocation' : location,
      'aboutshop': paymentMethod
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KBgColor,
        appBar: AppBar(
            title: const Text("Shop profile"),
            centerTitle:true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
              ),
            )),
        body:
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,

                          backgroundImage: (_image != null) ?
                          Image.file(_image!, fit: BoxFit.cover,).image
                              :
                          (_imageUrl.isNotEmpty ?
                              NetworkImage(_imageUrl)
                                :
                              NetworkImage(widget.ShopImage) as ImageProvider),
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
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(

                     // onChanged: (value)=> widget.ShopName = value,
                    //  initialValue: widget.ShopName,
                      controller: _fullName,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Username"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                     // onChanged: (value)=> widget.Location = value,
                     //initialValue: widget.Location,
                      controller: _location,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Location"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                     // onChanged: (value)=> widget.AboutShop = value,
                     // initialValue: widget.AboutShop.toString(),
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      controller: _paymentMethod,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "About shop"),
                    ),
                  ),


                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {



                      setState(() {
                        _isLoading = true;
                      });
                      final prefs = await SharedPreferences.getInstance();
                      final name = _fullName.text.trim();
                      final location = _location.text.trim();
                      final method = _paymentMethod.text.trim();
                      final imageUrl = _image != null ? await _upload(_id, name, _image) : _imageUrl;

                    ///  debugPrint(url);
                      debugPrint(imageUrl);
                      debugPrint(name);
                      debugPrint(_id.trim());
                      await prefs.setString('coverImage', imageUrl ?? "");
                      await prefs.setString('ShopName', name);
                      await updateShopInfo(FirebaseAuth.instance.currentUser!.uid, name, location, method, imageUrl!);

                      setState(() {
                        _isLoading = false;
                      });
                      Fluttertoast.showToast(
                          msg: "Shop info updated successfully",  // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.CENTER,    // location
                          timeInSecForIosWeb: 1               // duration
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNav()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: PrimaryBlueOcean,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: (_isLoading == false) ?  const Text(
                          "Update Profile",
                          style: TextStyle(
                              fontSize: textMedium, color: Colors.white),
                        ):
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
          ),
        );
  }

  _inputField(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white54,
              filled: true,
              hintText: label),
        ),
      ),
    );
  }
}
