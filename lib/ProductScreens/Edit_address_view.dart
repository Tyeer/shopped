import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat2/data/models/address_model.dart';
import 'package:chat2/helpers/constants.dart';

class EditAddress extends StatefulWidget {
  const EditAddress({Key? key, }) : super(key: key);


  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
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



  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _addressController.dispose();
  }

 /* Future<void> updateAddress(String name, String phone, String email,
      String city, String address) async {
    await _firebaseFirestore
        ?.collection('addresses')
        .doc(widget.address.id)
        .update({
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      "userId": "TbRTDUMVlCV6FQgu67eK",
      "createdAt": Timestamp.now(),
    });
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KBgColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Address",
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        child: Text("1", style: TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Recipient Information",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
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
                        child: Text("+265", style: TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
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
                    decoration: InputDecoration(
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
                        child: Text("2", style: TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Address",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "City*",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Address*",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                           /* updateAddress(
                                _nameController.text,
                                _phoneController.text,
                                _emailController.text,
                                _cityController.text,
                                _addressController.text);*/
                            _nameController.clear();
                            _phoneController.clear();
                            _emailController.clear();
                            _cityController.clear();
                            _addressController.clear();
                            Navigator.pop(context);

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
                  )))
        ],
      ),
    );
  }
}
