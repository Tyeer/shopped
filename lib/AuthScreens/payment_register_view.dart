import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/select_form_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/main.dart';
import 'package:chat2/AuthScreens/Register_as_view.dart';


class PaymentRegister extends StatefulWidget {
  const PaymentRegister({Key? key}) : super(key: key);

  @override
  _PaymentRegisterState createState() => _PaymentRegisterState();
}

class _PaymentRegisterState extends State<PaymentRegister> {
  var currentuser = FirebaseAuth.instance.currentUser!.uid;
  late TextEditingController _phoneNumberController;
  late TextEditingController _codeController;
  final TextEditingController shopname = TextEditingController();
  final TextEditingController payment = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  CountryCode _countryCode = CountryCode(code: 'MW', dialCode: '+265');
  bool passwordVisible = true;
  void validator (){
    if (phoneNumberController.text.isEmpty && shopname.text.isEmpty ){
      Fluttertoast.showToast(
          msg:'Please Enter Phone Number, Fullname and Password '
      );
    }
    else if(phoneNumberController.text.isEmpty){
      Fluttertoast.showToast(
          msg:'Please Enter Fullname '
      );
    }
    else if(shopname.text.isEmpty){
      Fluttertoast.showToast(
          msg:'Please Enter Shop name '
      );

    }
    else{

      register();
    }

  }
  bool loading =false;
  String? verificationId;

  CollectionReference shops = FirebaseFirestore.instance.collection('users');
  Future<void> UserShopDetails(id, method, phonenumber, nameshop ){
    return shops.doc(id).update({
      'Method':method,
      'ShopNumber':phonenumber,
      'ShopName':nameshop,
      'CorrectAnswer':phonenumber,
      'aboutshop': 'Not available at moment',


    }).then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg:'Successfully Registered User Details',
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return MyApp();
      }));
    }).catchError((error)=>print("Details failed to updated: $error"));
  }


  void register()async {

    shops.where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
            (QuerySnapshot querySnapshot){
          if(querySnapshot.docs.isEmpty){
            shops.add({

              'Method': payment.text,
              'ShopName': shopname.text,
              'ShopNumber': phoneNumberController.text,
              'aboutshop': 'Not available at moment',
              'Location': 'Blantyre',
            }
            ).then((value){

            });
          }
        });

  /*  Navigator.push(context,
        MaterialPageRoute(
            builder: (context) =>MyApp()));*/

  }
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


  final List<String> _statusList = ["Tnm Mpamba", "Airtel Money", 'National Bank', 'Standard Bank'];
  String? _statusSelectedValue;
  late TextEditingController _statusController;
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Widget _createAccountLabel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Payment",
            style: TextStyle(
              fontSize: textLarge,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(height: 24),
        Text("This account will be used for receiving your money",
            style: TextStyle(
              fontSize: textMedium,
              color: SecondaryDarkGrey,
              fontWeight: FontWeight.w500,
            )),
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
        body:

        Form(
          key: _formKey,
          child: Container(
            child: Stack(
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

                        SizedBox(height: 50,),
                        _title(),
                        SizedBox(
                          height: 45,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Choose Payment Method',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: textMedium),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 45,
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Center(
                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: const InputDecoration(
                                          errorStyle: TextStyle(
                                              color: Colors.redAccent, fontSize: 16.0),
                                          hintStyle: TextStyle(color: Colors.black),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        isEmpty: _statusSelectedValue == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            hint: const Text('Payment Method'),
                                            value: _statusSelectedValue,
                                            isDense: true,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _statusSelectedValue = newValue;
                                                state.didChange(newValue);
                                              });
                                            },
                                            items: _statusList.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                              ),
                            ),
                          ],
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
                          height: 20,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Shop Display name",
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


                                  controller: shopname,
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

                        SizedBox(height: 20),

                        InkWell(
                          onTap: () {


    if (_formKey.currentState!.validate()){
      UserShopDetails(currentuser, _statusSelectedValue, phoneNumberController, shopname);
      Navigator.pop(context);
    }
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
                                'Continue',
                                style: TextStyle(
                                    fontSize: textMedium,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),


                          ),
                        )


                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
