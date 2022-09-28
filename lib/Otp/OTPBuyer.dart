import 'package:chat2/AuthScreens/add_buyer_user_details_view.dart';
import 'package:chat2/AuthScreens/register_account_as_buyer_view.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPBuyer extends StatefulWidget {


  final String phone;
  OTPBuyer(this.phone);

  @override
  State<OTPBuyer> createState() => _OTPBuyerState();
}

class _OTPBuyerState extends State<OTPBuyer> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();


  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Column(
            children: [

              SizedBox(
                height: 21,
              ),
              SizedBox(height: 88),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: textLarge,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Provide received code sent to +265-${widget.phone}",
                      style: TextStyle(
                          fontSize: textMedium,
                          fontWeight: FontWeight.w400,
                          color: SecondaryDarkGrey)),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,

                  controller: _pinPutController,

                  pinAnimationType: PinAnimationType.fade,
                  onSubmitted: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode!, smsCode: pin))
                          .then((value) async {
                        if (value.user != null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => UserBuyerDeatils(
                                  id: widget.phone
                              )),
                                  (route) => false);
                        }
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

                    }
                  },
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Wrong Number?',
                          style: TextStyle(
                            fontSize: textMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterBuyerView())),
                        child: Text(
                          'Re-send Code',
                          style: TextStyle(
                              fontSize: textMedium,
                              fontWeight: FontWeight.w500,
                              color: PrimaryBlueOcean),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: () async {

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20.0),
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

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+265${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserBuyerDeatils(
                    id: widget.phone
                  )),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
