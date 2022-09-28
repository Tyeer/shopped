import 'package:chat2/AuthScreens/phone_auth_view.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/data/models/seller_model.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';


class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final Repository repo = Repository();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  String _id = "";
  String _userRole = "";
  CountryCode _countryCode = CountryCode(code: 'MW', dialCode: '+265');
  final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey();

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('phoneNumber'));
    if(logSeller != null){
      setState(() {
        _id = logSeller.id;
        _userRole = prefs.getString('userRole')!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBgColor,
      appBar: AppBar(
          title: const Text("Change Password"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),
        body:
        SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    children : [
                      Form(
                        key: _phoneNumberFormKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Old Password',
                                fillColor: const Color(0xfff3f3f4),
                                prefixIcon: Icon(
                                  Icons.lock
                                ),
                              ),

                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'New Password',
                                fillColor: const Color(0xfff3f3f4),
                                prefixIcon: Icon(
                                  Icons.lock
                                ),
                              ),

                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Confirm Password',
                                fillColor: const Color(0xfff3f3f4),
                                prefixIcon: Icon(
                                  Icons.lock
                                ),
                              ),

                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                if (_phoneNumberFormKey.currentState!.validate()){
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  final prefs = await SharedPreferences.getInstance();
                                  final number = _phoneNumberController.text.trim();
                                  final phoneNumberWithCode = "${_countryCode.dialCode}$number";

                                  //debugPrint(url);
                                  debugPrint(phoneNumberWithCode);
                                  debugPrint(_id.trim());
                                  await prefs.setString('phoneNumber', phoneNumberWithCode);
                                  _userRole.contains("seller") ? await repo.updateSellerPhoneNumber(_id.trim(), phoneNumberWithCode)
                                      :
                                  await repo.updateBuyerPhoneNumber(_id.trim(), phoneNumberWithCode);

                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PhoneAuthPage()));
                                }

                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: PrimaryBlueOcean,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: (_isLoading == false) ?  const Text(
                                    "Change Number",
                                    style: TextStyle(
                                        fontSize: textMedium, color: Colors.white),
                                  ):
                                  Container(
                                      width: 24,
                                      height: 24,
                                      padding: const EdgeInsets.all(2.0),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                )
            )
        )
    );
  }
}
