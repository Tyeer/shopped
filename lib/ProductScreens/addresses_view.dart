import 'package:chat2/ProductScreens/Edit_address_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/bloc/blocs.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/ProductScreens/add_address_view.dart';

import '../data/models/seller_model.dart';
import '../data/models/user_model.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({Key? key}) : super(key: key);

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  final Repository repo = Repository();
  String? _selectedValue;
  String _userId = "";
  final AddressBloc _addressBloc = AddressBloc(addressRepository: Repository());

  getSellerId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('Type');
    if(userRole != null){
      if(userRole.contains("Seller")){
        //debugPrint("seller");
        Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('Phonenumber'));
        debugPrint(logSeller!.id);
        _addressBloc.add(LoadAddress(logSeller.id));
        setState(() {
          _userId = logSeller.id;
        });

      } else {
        Customer? logCustomer = await repo.findBuyerByPhoneNumber(prefs.getString('Phonenumber'));
        _addressBloc.add(LoadAddress(logCustomer!.id));
        setState(() {
          _userId = logCustomer.id;
        });
      }
    }
  }

  @override
  void initState() {
    getSellerId();
  }

  var currentuser = FirebaseAuth.instance.currentUser!.uid;
String select = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBgColor,
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Address",
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
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: double.infinity,
            child:
            Column(
              children: [

    StreamBuilder<QuerySnapshot>  (
    stream: FirebaseFirestore.instance
        .collection('address')
    .where('Uid', isEqualTo: currentuser)
        .snapshots(),
    builder: (context, snapshot) {
    if (snapshot.hasError) {
    return Center(child: Text("Something went wrong"));
    }
    else if (!snapshot.hasData) {
    return Center(child: CircularProgressIndicator());
    }

    else {

      return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    itemCount: snapshot.data!.docs.length,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      DocumentSnapshot doc = snapshot.data!.docs[index];
      return Container(
      padding: const EdgeInsets.all(10),

      child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Radio<String>(
      activeColor: iconBlueDark,
      value: select,
      groupValue: _selectedValue,
      onChanged: (value) {
      setState(() {
      _selectedValue = value!;
      });
      },
      ),
      const SizedBox(
      width: 20,
      ),
      Column(


      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
      doc['name'],
      style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold),
      ),
      Text(
      "+265" + doc['phone'],
      style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold),
      ),
      Text(
     doc['address'],
      style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold),
      ),
      Text(
      doc['city'],
      style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold),
      ),
      ],
      ),
      const SizedBox(
      width: 20,
      ),
      Expanded(
      child: IconButton(
      onPressed: () =>
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) =>
      EditAddress(

      ),
      ),
      ),
      icon: const Icon(
      Icons.edit_outlined,
      size: 30,
      color: iconBlueDark,
      ),
      ),
      )
      ],
      ),
      );

      }
      );
    }
    })

              ],
            )
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAddressView(),
                    ),
                  ),
                  child: const Text(
                    'Create new address',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    primary: Colors.white,
                    backgroundColor: PrimaryBlueOcean,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
