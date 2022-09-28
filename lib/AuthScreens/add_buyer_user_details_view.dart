import 'package:chat2/ProductScreens/add_address_view.dart';
import 'package:chat2/bottom_nav.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
 class UserBuyerDeatils extends StatefulWidget {
   const UserBuyerDeatils({Key? key, required this.id}) : super(key: key);
final id;
   @override
   State<UserBuyerDeatils> createState() => _UserBuyerDeatilsState();
 }

 class _UserBuyerDeatilsState extends State<UserBuyerDeatils> {

   bool loading = false;


   final userNameController = TextEditingController();
   final passWordController = TextEditingController();
   @override

CollectionReference users = FirebaseFirestore.instance.collection('users');
   void add(){

     var format = DateFormat('MMM d, yyyy');
     String date = format.format(DateTime.now()).toString();
     users.where('Uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
         .limit(1)
         .get()
         .then(
         (QuerySnapshot querySnapshot){
           if(querySnapshot.docs.isEmpty){
             users.add({
               'Fullname': username.text,
               'Password': pasword.text,
               'Email': FirebaseAuth.instance.currentUser?.email,
               'Uid':FirebaseAuth.instance.currentUser?.uid,
               'Phonenumber': widget.id,
               'Type': 'Buyer',
               'DateJoined': date,
               'userImage': 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
               'Location': 'Not Available',
             }
             ).then((value){
               Navigator.pop(context);
               Fluttertoast.showToast(
                 msg:'Successfully Registered User Details',
               );

               setState(() {
                 loading = false;
               });
               Navigator.of(context).push(MaterialPageRoute(builder: (context){
                 return BottomNav();
                 ///MyApp()
               }));
             });
           }
         });
   }
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

   void HomeScreen(){
     Navigator.of(context).pushReplacement(

       MaterialPageRoute(builder: (context)=>BottomNav()),
     );
   }


   Widget _entryField(String title, {bool isPassword = false}) {
     return Container(
       margin: EdgeInsets.symmetric(vertical: 10),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Text(
             title,
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
           ),
           SizedBox(
             height: 10,
           ),
           TextField(
               obscureText: isPassword,
               decoration: InputDecoration(
                   border: InputBorder.none,
                   fillColor: Color(0xfff3f3f4),
                   filled: true))
         ],
       ),
     );
   }

   Widget _submitButton(String label) {
     return GestureDetector(
       onTap:(){

         validator();
         // validator();

       },
       child: loading ? Center(
         child: CircularProgressIndicator(),
       ) : Container(
         width: MediaQuery.of(context).size.width,
         padding: EdgeInsets.symmetric(vertical: 16),
         alignment: Alignment.center,
         decoration: BoxDecoration(
           color: PrimaryBlueOcean,
           borderRadius: BorderRadius.all(Radius.circular(10)),
         ),
         child: Text(
           label,
           style: TextStyle(
               fontSize: textMedium,
               color: Colors.white,
               fontWeight: FontWeight.w500),
         ),
       ),
     );
   }

   Widget _createAccountLabel() {
     return Container(
       padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           InkWell(
             onTap: () {/*Navigator.push(context,
                 MaterialPageRoute(builder: (context) => RegisterAsView()));*/},
             child: Text(
               'Terms and conditions',
               style: TextStyle(
                   fontSize: textMedium,
                   fontWeight: FontWeight.w500,
                   color: PrimaryBlueOcean),
             ),
           ),
           SizedBox(height: 14),

         ],
       ),
     );
   }

   Widget _title() {
     return Text("Add User Details",
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
         body: Stack(
           children: <Widget>[
              Positioned(
                 top: 21,
                 left: 0,
                 right: 0,

                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       _title(),
                       SizedBox(
                         height: 108,
                       ),

                       SizedBox(
                         height: 20,
                       ),
                       Container(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Text(
                               "Full Name",
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
                               "Password",
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
                       SizedBox(height: 100),
                       _submitButton("Continue"),

                     ],
                   ),
                 ),
               ),

             Positioned(
                 bottom: 30, left: 0, right: 0, child: _createAccountLabel()),
           ],
         )
     );
   }
 }
