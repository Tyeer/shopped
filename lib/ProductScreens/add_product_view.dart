import 'dart:io';
import 'dart:math';
import 'package:chat2/ProductScreens/MyProducts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:path/path.dart' as path;
import '../data/models/category_model.dart';
import '../data/models/seller_model.dart';
import '../data/repository/repository.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key}) : super(key: key);

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore? _firebaseFirestore = FirebaseFirestore.instance;
  final Repository repo = Repository();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryController;
  late TextEditingController _conditionController;
  late TextEditingController _sellerController;
  late TextEditingController _locationController;
  late TextEditingController _statusController;
  bool isLoading = false;
  File? _image;
  String _sellerID = "";


  String? _categorySelectedValue;
  String? _conditionSelectedValue;
  String? _statusSelectedValue;
  List<String> _categories = ["electronics", "furniture", "fashion", "baby"];
  final List<String> _condition = ["Brand New", "Second-Hand", "Damaged"];
  final List<String> _statusList = ["Active", "On-Hold"];



  @override
  void initState() {

    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _quantityController = TextEditingController();
    _imageUrlController = TextEditingController();
    _categoryController = TextEditingController();
    _conditionController = TextEditingController();
    _sellerController = TextEditingController();
    _locationController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _conditionController.dispose();
    _sellerController.dispose();
    _locationController.dispose();
    _statusController.dispose();
    super.dispose();
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
          .ref("products/$fileName")
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

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }


  Future<void> addProduct(
      String name,
      String price,
      String location,
      String category,
      String description,
      String quantity,
      String imageUrl,
      String status,
      String condition) async {
    var dateformat = DateFormat('MMM d, yyyy');
    String date = dateformat.format(DateTime.now()).toString();
    String productID = generateRandomString(15);
    await _firebaseFirestore?.collection('products').doc(productID).set({
      "name": name,
      "price": price,
      "location": location,
      "category": category,
      "description": description,
      "quantity": quantity,
      "imageUrl": imageUrl,
      "condition": condition,
      "productStatus": status,
      "productId": productID,
      "dateAdded" :date,
      "sellerId": FirebaseAuth.instance.currentUser?.uid,
      'status': 'offline'
    });
    Fluttertoast.showToast(
        msg: "Product created successfully",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,    // location
        timeInSecForIosWeb: 1               // duration
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyProducts()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "New Product",
            style: TextStyle(color: Colors.white, fontSize: appBarTitleSize),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Photo",
                    style: TextStyle(
                        fontWeight: FontWeight.w300, fontSize: textMedium + 3),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      _openImagePicker();
                    },
                    child: Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: SecondaryDarkGrey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Change photo",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    fontSize: textMedium)),
                          ],
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _openImagePicker();
                },
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey, style: BorderStyle.solid, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: _image != null
                              ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                              : const Text("No image selected"),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                  ),
                ),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Price"),
                  ),
                ),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Location"),
                  ),
                ),
              ),

              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          isEmpty: _categorySelectedValue == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Category'),
                              value: _categorySelectedValue,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _categorySelectedValue = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _categories.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    )
                ),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        isEmpty: _conditionSelectedValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text('Condition'),
                            value: _conditionSelectedValue,
                            isDense: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _conditionSelectedValue = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _condition.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  )
                ),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          isEmpty: _statusSelectedValue == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Status'),
                              value: _statusSelectedValue,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _statusSelectedValue = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _statusList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    )
                ),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        hintText: "Quantity",
                        fillColor: Colors.white,
                        filled: true,
                      )),
                ),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Description",
                        fillColor: Colors.white,
                        filled: true,
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (_nameController.text.trim() != "" &&
                      _priceController.text.trim() != "" &&
                      _locationController.text.trim() != "" &&
                      _categorySelectedValue != null &&
                      _conditionSelectedValue != null &&
                      _statusSelectedValue != null &&
                      _image != null &&
                      _quantityController.text.trim() != "") {
                    final _imageUrl =
                        await _upload(_nameController.text.trim(), _image);
                    addProduct(
                      _nameController.text.trim(),
                      _priceController.text.trim(),
                      _locationController.text,
                      _categorySelectedValue.toString(),
                      _descriptionController.text.trim(),
                      _quantityController.text.trim(),
                      _imageUrl.toString(),
                      _statusSelectedValue.toString(),
                      _conditionSelectedValue.toString(),
                    );
                    _nameController.clear();
                    _priceController.clear();
                    _locationController.clear();
                    _categorySelectedValue = null;
                    _conditionSelectedValue = null;
                    _statusSelectedValue = null;
                    _quantityController.clear();
                    _descriptionController.clear();
                    _image = null;
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "All fields are required!",
                        style: TextStyle(
                            color: Colors.white, fontSize: textMedium),
                      ),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: PrimaryBlueOcean,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Publishing...",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: textMedium,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1, color: Colors.white),
                              )
                            ],
                          )
                        : const Text(
                            "Publish",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: textMedium,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  _inputField(String label) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white54,
              filled: true,
              hintStyle: const TextStyle(fontSize: textMedium),
              hintText: label),
        ),
      ),
    );
  }
}
