import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/helpers/constants.dart';

import '../bottom_nav.dart';
import '../data/repository/repository.dart';



class UserInfoView extends StatefulWidget {
  UserInfoView({Key? key,
    this.Fullname,
    this.Uid,
    this.userImage,
    this.Phonenumber,

  }) : super(key: key);

  final Fullname;
  final  Uid;
  final userImage;

  final Phonenumber;

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  String? _currentSelectedValue;
  final _gender = ["Male", "Female", "Other"];
  final Repository repo = Repository();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isLoading = false;
  File? _image;
  String _userId = "";
  String _imageUrl = "";
  TextEditingController _fullNameController = TextEditingController();
  CountryCode _countryCode = CountryCode(code: 'MW', dialCode: '+265');

  final TextEditingController startdate = TextEditingController();
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
          .ref("users/$userId")
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

  String? _conditionSelectedValue;
  final List<String> _condition = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
            centerTitle: true,
            title: const Text("User info"),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
              ),
            )),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                       NetworkImage(widget.userImage)),

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
                  child: TextFormField(
                  initialValue: widget.Fullname,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Enter full name"),
                  ),
                ),
              ),

              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),

                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: TextFormField(
                  initialValue: widget.Phonenumber,
                  keyboardType: TextInputType.phone,
                  // controller: widget.phoneNumberController,
                  decoration: InputDecoration(

                    hintText: 'Phone Number',
                    fillColor: const Color(0xfff3f3f4),
                    prefixIcon: CountryCodePicker(
                      onChanged: (CountryCode countryCode) {
                        setState(() {
                          _countryCode = countryCode;
                        });
                      },
                      initialSelection: 'MW',
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: true,
                      alignLeft: false,
                    ),
                  ),
                  validator: (value) {
                    if (value!.length != 9) {
                      return 'Please enter valid phone number';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                )
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),

                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "What is your Email"),
                  ),
                ),
              ),
              Container(
                height: 45,
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
                              hint: const Text('Gender'),
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
              SizedBox(height: 10,),
              Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                ),

                  child: Center(
                      child: TextField(
                        controller:startdate,
                        decoration: InputDecoration(

                          suffixIcon: Icon(Icons.calendar_month_rounded),
                            //icon of text field
                            labelText: "What is your date of birth" //label text of field
                        ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              startdate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ))),
SizedBox(height: 10,),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  final prefs = await SharedPreferences.getInstance();
                  final name = _fullNameController.text.trim();
                  final imageUrl = _image != null ? await _upload(_userId, name, _image) : _imageUrl;

                  debugPrint(imageUrl);
                  debugPrint(name);
                  debugPrint(_userId.trim());

                  await prefs.setString('imageUrl', imageUrl ?? "");
                    await prefs.setString('FullName', name);
                    await repo.updateUserInfo(_userId.trim(), name, imageUrl!);

                    setState(() {
                      _isLoading = false;
                    });
                    Fluttertoast.showToast(
                        msg: "User info updated successfully",  // message
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
                    child: (_isLoading == false) ? const Text(
                      "Update Profile",
                      style:
                          TextStyle(fontSize: textMedium, color: Colors.white),
                    ) :
                    Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                    )
                    ,
                  ),
                ),
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
