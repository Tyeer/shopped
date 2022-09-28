import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
//import 'package:chat2/bottom_nav.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/AuthScreens/Register_as_view.dart';
import 'package:chat2/AuthScreens/verification_as_buyer_view.dart';


class RegisterAccount extends StatefulWidget {
  const RegisterAccount({Key? key}) : super(key: key);

  @override
  _RegisterAccountState createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
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
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => VerificationAsBuyerView())),
      child: Container(
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
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterAsView())),
            child: Text(
              'Terms and conditions',
              style: TextStyle(
                  fontSize: textMedium,
                  fontWeight: FontWeight.w500,
                  color: PrimaryBlueOcean),
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Have an Account?',
                style: TextStyle(
                  fontSize: textMedium,
                  color: SecondaryDarkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterAsView())),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: textMedium,
                      fontWeight: FontWeight.w500,
                      color: PrimaryBlueOcean),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Text("Register Account",
        style: TextStyle(
          fontSize: textLarge,
          fontWeight: FontWeight.w700,
        ));
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
                      height: 68,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Mobile Phone',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: textMedium),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          IntlPhoneField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            initialCountryCode: 'MW',
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
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
                            "Full Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: textMedium),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
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
                          TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))
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
        ));
  }
}
