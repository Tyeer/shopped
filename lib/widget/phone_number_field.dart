import 'package:country_code_picker/country_code_picker.dart';
import 'package:chat2/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat2/helpers/constants.dart';

class PhoneNumberWidget extends StatefulWidget {
  const PhoneNumberWidget({Key? key, required this.phoneNumberController})
      : super(key: key);
  final TextEditingController phoneNumberController;

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  CountryCode _countryCode = CountryCode(code: 'MW', dialCode: '+265');
  final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _phoneNumberFormKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: widget.phoneNumberController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Phone Number',
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
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () => {
              if (_phoneNumberFormKey.currentState!.validate())
                {
                  _sendOtp(
                      phoneNumber: widget.phoneNumberController.text,
                      context: context)
                }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: PrimaryBlueOcean,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendOtp({required String phoneNumber, required BuildContext context}) {
    final phoneNumberWithCode = "${_countryCode.dialCode}$phoneNumber";
    context.read<PhoneAuthBloc>().add(
          SendOtpToPhoneEvent(
            phoneNumber: phoneNumberWithCode,
          ),
        );
    debugPrint(phoneNumberWithCode);
    setState(() {
      widget.phoneNumberController.clear();
    });
  }
}
