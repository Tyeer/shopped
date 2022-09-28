import 'package:chat2/Otp/OTPScreen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:chat2/helpers/constants.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}
class RegisterSellerView extends StatefulWidget {
  const RegisterSellerView({Key? key}) : super(key: key);

  @override
  _RegisterSellerViewState createState() => _RegisterSellerViewState();
}
class _RegisterSellerViewState extends State<RegisterSellerView> {

  TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLoading = false;
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
        body:


        Center(
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
      SizedBox(height: 20,),
      GestureDetector(
        onTap: () async {


          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OTPScreen(_controller.text)));

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
          ):
          Center(
            child:

            const Text(
              'Continue',
              style: TextStyle(
                  fontSize: textMedium,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),


        ),
      ),

    ],
    )
    )
        )


    );
  }
}
