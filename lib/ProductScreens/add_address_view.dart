import 'dart:math';

import 'package:chat2/ProductScreens/addresses_view.dart';
import 'package:chat2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/helpers/constants.dart';

import '../data/models/seller_model.dart';
import '../data/models/user_model.dart';
import '../data/repository/repository.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({Key? key}) : super(key: key);

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final FirebaseFirestore? _firebaseFirestore = FirebaseFirestore.instance;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  bool isLoading = false;

  String? _selectedValue;
  final List<String> _cities = [
    "Blantyre",
    "Lilongwe",
    "Mzuzu",
  ];
  final Repository repo = Repository();
  String _userId = "";
  String _userRole = "";
  final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final currentuser = FirebaseAuth.instance.currentUser!.uid;
  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('userRole');
    if(userRole != null){
      if(userRole.contains("seller")){
        //debugPrint("seller");
        Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('phoneNumber'));
        debugPrint("user : " + logSeller!.id);
        setState(() {
          _userId = logSeller.id;
          _userRole = userRole;
        });

      }
      else {
        Customer? logCustomer = await repo.findBuyerByPhoneNumber(prefs.getString('phoneNumber'));
        setState(() {
          _userId = logCustomer!.id;
          _userRole = prefs.getString('userRole') ?? '';
        });


      }
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _cityController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _addressController.dispose();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  Future<void> addAddress(String name, String phone, String email, String city,
      String address) async {
    String addressId = generateRandomString(15);
    await _firebaseFirestore?.collection('address').doc(addressId).set({
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      "Uid": currentuser,
      "Aid" : addressId,
      "createdAt": DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
    }).then((value) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return  AddressesView();
    })
      ); }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBgColor,
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Add Address",
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),

      body: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(

                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "*Required fields.",
                          style: TextStyle(fontSize: 18, color: SecondaryDarkGrey),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: iconBlueDark,
                                  width: 3,
                                ),
                              ),
                              child: const Text("1", style: TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              "Recipient Information",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Name and Surname*",
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: SecondaryDarkGrey,
                                  width: 1,
                                ),
                              ),
                              child: const Text("+265", style: TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.length != 9) {
                                    return 'Please enter valid phone number';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Phone Number*",
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email Address*",
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: iconBlueDark,
                                  width: 3,
                                ),
                              ),
                              child: const Text("2", style: TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              "Address",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "City*",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Address*",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100,),

                Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddressesView(),
                                ),
                              );
                            },
                            child: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              if (_nameController.text.trim() == "" &&
                                  _phoneController.text.trim() == "" &&
                                  _emailController.text.trim() == "" &&
                                  _cityController.text.trim() == "" &&
                                  _addressController.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    "Please all fields are required",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: textMedium),
                                  ),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                              addAddress(
                                  _nameController.text,
                                  '+265'+_phoneController.text,
                                  _emailController.text,
                                  _cityController.text,
                                  _addressController.text);
                              _nameController.clear();
                              _phoneController.clear();
                              _emailController.clear();
                              _cityController.clear();
                              _addressController.clear();
                              Fluttertoast.showToast(
                                  msg: "Address added successfully",  // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.CENTER,    // location
                                  timeInSecForIosWeb: 1               // duration
                              );
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: isLoading
                                ? const Text(
                              'Saving...',
                            )
                                : const Text('Save'),
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: PrimaryBlueOcean,
                            ),
                          ),
                        )
                      ],
                    ))

              ]))








    /*  Container(
        child: ListView(
          children: [

          ],
        ),
      ),*/
    );
  }
}
