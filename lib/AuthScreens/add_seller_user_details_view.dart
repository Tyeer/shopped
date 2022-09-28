import 'dart:math';
import 'package:chat2/bottom_nav.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UserSellerDetail extends StatefulWidget {
  const UserSellerDetail({Key? key, required this.id}) : super(key: key);

  final id;
  @override
  State<UserSellerDetail> createState() => _UserSellerDetailState();
}

class _UserSellerDetailState extends State<UserSellerDetail> {



  bool isLoading = false;
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  @override


  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore? _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> add() async {
    String userid = generateRandomString(15);
    var format = DateFormat('MMM d, yyyy');
    String date = format.format(DateTime.now()).toString();
    await _firebaseFirestore?.collection('users').doc(userid).set({
      'Fullname': username.text,
      'Password': password.text,
      'Email': FirebaseAuth.instance.currentUser?.email,
      'Uid':FirebaseAuth.instance.currentUser?.uid,
      'Phonenumber': widget.id,
      'Type': 'Seller',
      'DateJoined': date,
      'followers': 0,
      'userImage': 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
      'items': 0,
      'Location': 'Not Available',
      'Method':'Not Available',
      'ShopNumber':FirebaseAuth.instance.currentUser?.phoneNumber,
      'ShopName':username.text,
      'ShopLocation': 'Not Available',
      'aboutshop': 'Not available at moment',
      'coverImage': 'https://images.pexels.com/photos/626986/pexels-photo-626986.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',

    });
    Fluttertoast.showToast(
        msg: "Account created successfully",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,    // location
        timeInSecForIosWeb: 1               // duration
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return  BottomNav(

      );
      //MyApp()
    }));


  }


  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void adssd(){



    users.where('Uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
            (QuerySnapshot querySnapshot){
          if(querySnapshot.docs.isEmpty){
            users.add({

            }
            ).then((value){
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg:'Successfully Registered User Details',
              );

            });
          }
        });
  }

  @override
  late TextEditingController _phoneNumberController;
  late TextEditingController _codeController;
  final TextEditingController password = TextEditingController();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController number = TextEditingController();
  CountryCode _countryCode = CountryCode(code: 'MW', dialCode: '+265');
  bool passwordVisible = true;
  void initState2(){
    super.initState();
    passwordVisible = true;
  }
  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  final TextEditingController email = TextEditingController();
  final TextEditingController pasword = TextEditingController();
  final TextEditingController username = TextEditingController();


  void validator (){
    if (email.text.isEmpty && pasword.text.isEmpty && username.text.isEmpty ){

      Fluttertoast.showToast(
          msg:'Please Enter Username, Email and Password '
      );
    }
    else if(email.text.isEmpty){

      Fluttertoast.showToast(
          msg:'Please Enter Email '
      );
    }
    else if(pasword.text.isEmpty){
      Fluttertoast.showToast(
          msg:'Please Enter Password '
      );

    }
    else if(username.text.isEmpty){
      Fluttertoast.showToast(
          msg:'Please Enter Username '
      );

    }
    else{
      setState(() {
        loading = true;
      });
      register();
    }
  }

  bool loading =false;
  void register(){
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: pasword.text).then((UserCredential userCredetial){

      //move to home screen

      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg:'Registered Successfully ',
      );
      add();
    }).catchError((error){
      //show error

      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg:error.toString(),
      );
    });

  }






  Widget _submitButton(String label) {
    return InkWell(
        onTap:(){
          validator();
        },
      child:

      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: PrimaryBlueOcean,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: isLoading ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Processing...",
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
        ) :
        Center(
          child:
          Text(
            label,
            style: TextStyle(
                fontSize: textMedium,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),


      ),
    );
  }



  Widget _title() {
    return Text("Seller User Details",
        style: TextStyle(
          fontSize: textLarge,
          fontWeight: FontWeight.w700,
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),

        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,

        body:  Center(
    // Center is a layout widget. It takes a single child and positions it
    // in the middle of the parent.
    child: Padding(
    padding:   const EdgeInsets.symmetric(horizontal: paddingHorizontal),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[

      Spacer(),
      _title(),
      SizedBox(
        height: 100,
      ),

      SizedBox(
        height: 20,
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Enter Fullname",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: textMedium),
            ),
            SizedBox(
              height: 10,
            ),

            Container(
              height: 45,
              padding: const EdgeInsets.all(5),

              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
                border: Border.all(
                  color: Color(0xfff2f2f2),
                  width: 1,
                ),

                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(


                controller: username,
                textInputAction: TextInputAction.next,
                cursorColor: const Color(0xFFffffff),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,

                  fillColor: Color(0xfff2f2f2),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Enter Email",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: textMedium),
            ),
            SizedBox(
              height: 10,
            ),

            Container(
              height: 45,
              padding: const EdgeInsets.all(5),

              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
                border: Border.all(
                  color: Color(0xfff2f2f2),
                  width: 1,
                ),

                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(


                controller: email,
                textInputAction: TextInputAction.next,
                cursorColor: const Color(0xFFffffff),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,

                  fillColor: Color(0xfff2f2f2),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Enter Password",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: textMedium),
            ),
            SizedBox(
              height: 10,
            ),


            Container(
              height: 45,
              padding: const EdgeInsets.all(5),


              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
                border: Border.all(
                  color: Color(0xfff2f2f2),
                  width: 1,
                ),

                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(

                controller: pasword,
                obscureText: passwordVisible,
                textInputAction: TextInputAction.done,
                cursorColor: const Color(0xFFffffff),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  suffixIcon: IconButton(
                    iconSize: 15,
                    icon: Icon(

                      passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  fillColor: Color(0xfff2f2f2),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      _submitButton("Continue"),
      Spacer()


    ]))),




    );
  }
}
