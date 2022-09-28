import 'package:chat2/bottom_nav.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat2/AuthScreens/Register_as_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _codeController;
  final TextEditingController password = TextEditingController();
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
  bool loading =false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUID() async{
    return (_auth.currentUser)!.uid;
  }


  final TextEditingController email = TextEditingController();
  final TextEditingController pasword = TextEditingController();

  void validator (){
    if (email.text.isEmpty && pasword.text.isEmpty ){

      Fluttertoast.showToast(
          msg:'Please Enter Email and Password'
      );
    }
    else if(email.text.isEmpty){
      Fluttertoast.showToast(
          msg:'Please Enter Email '
      );
    }
    else if(pasword.text.isEmpty){
      Fluttertoast.showToast(
          msg:'Please Enter Password'
      );
    }
    else{
      setState(() {
        loading = true  ;
      });
      login();
    }
  }
  void login(){
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: pasword.text).then((UserCredential userCredetial){

      //move to home screen

      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg:'Login Successfully ',
      );
      HomeScreen();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body:

      Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding:   const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Spacer(),
              _logo(),


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




              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  validator();
                },
                child:



                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: PrimaryBlueOcean,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child:


                  loading ?
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

                  Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              Spacer(),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          /*Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotScreen()));*/
                        },

                        child: Text('Forgot password', style: TextStyle(fontFamily: 'DMsans',fontSize: 15,fontWeight: FontWeight.bold,),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterAsView()));
                        },

                        child: Text('Sign Up', style: TextStyle(fontFamily: 'DMsans',
                            color: PrimaryBlueOcean,fontSize: 15, fontWeight: FontWeight.bold),)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),

    );
  }

  Widget _logo() {
    return Column(
      children: [
        Image.asset(
          'assets/icons/logo.png',
          height: 82,
          width: 263,
        ),
        const Text("Welcome to convenience",
            style: TextStyle(
                fontSize: textMedium,
                fontWeight: FontWeight.w400,
                color: SecondaryDarkGrey)),
      ],
    );
  }
}
