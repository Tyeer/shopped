import 'package:chat2/AuthScreens/add_buyer_user_details_view.dart';
import 'package:chat2/Otp/OTPBuyer.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/main.dart';
import 'package:chat2/AuthScreens/Register_as_view.dart';
import 'package:chat2/AuthScreens/verification_as_buyer_view.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';



class RegisterBuyerView extends StatefulWidget {
  const RegisterBuyerView({Key? key}) : super(key: key);

  @override
  State<RegisterBuyerView> createState() => _RegisterBuyerViewState();
}

class _RegisterBuyerViewState extends State<RegisterBuyerView> {

  TextEditingController _controller = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Center(
    child: Padding(
    padding:   const EdgeInsets.symmetric(horizontal: paddingHorizontal),
    child: Column(

      crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[

      Text("Enter Phonenumber",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          )),
      SizedBox(height: 15,),


      TextFormField(
        keyboardType: TextInputType.phone,
        controller: _controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Phone Number',
          fillColor: const Color(0xfff3f3f4),
          prefixIcon: CountryCodePicker(
            initialSelection: 'MW',
            showCountryOnly: true,
            showOnlyCountryWhenClosed: false,
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
    SizedBox(height: 30,),

    GestureDetector(
    onTap: () async {


    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => OTPBuyer(_controller.text)));

    },
    child: Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(vertical: 16),
    alignment: Alignment.center,
    decoration: BoxDecoration(
    color: PrimaryBlueOcean,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Text(
    'Continue',
    style: TextStyle(
    fontSize: textMedium,
    color: Colors.white,
    fontWeight: FontWeight.w500),
    ),
    ),
    ),

    ],
    ),
    ),
    ),


    );
  }
}
