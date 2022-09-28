import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
//import 'package:shopped/bottom_nav.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/AuthScreens/Register_as_view.dart';
import 'package:chat2/AuthScreens/verification_view.dart';

class ResertPassword extends StatefulWidget {
  const ResertPassword({Key? key}) : super(key: key);

  @override
  _ResertPasswordState createState() => _ResertPasswordState();
}

class _ResertPasswordState extends State<ResertPassword> {

  late TextEditingController _phoneNumberController;
  late TextEditingController _codeController;
  final TextEditingController password = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
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

  Widget _submitButton() {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerificationView())),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: PrimaryBlueOcean,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          'Reset',
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
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResertPassword())),
            child: Text(
              'Forgot Passoword',
              style: TextStyle(
                fontSize: textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterAsView())),
            child: Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: textMedium,
                  fontWeight: FontWeight.w500,
                  color: PrimaryBlueOcean),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reset Password',
          style: TextStyle(
            fontSize: textLarge,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Provide your phone number",
            style: TextStyle(
                fontSize: textMedium,
                fontWeight: FontWeight.w400,
                color: SecondaryDarkGrey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 21,
              ),
              _title(),
              SizedBox(height: 88),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Mobile Phone',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: textMedium),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      decoration: InputDecoration(

                        fillColor: const Color(0xfff3f3f4),
                        prefixIcon: CountryCodePicker(

                          onChanged: (CountryCode countryCode) {
                            setState(() {
                              _countryCode = countryCode;
                            });
                          },
                          initialSelection: 'MW',
                          showCountryOnly: false,
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
                  ],
                ),
              ),
              SizedBox(
                height: 128,
              ),
              _submitButton(),
            ],
          ),
        ));
  }
}
