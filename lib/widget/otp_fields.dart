import 'dart:async';

import 'package:chat2/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat2/helpers/constants.dart';

class OtpWidget extends StatefulWidget {
  const OtpWidget({Key? key, required this.codeController, required this.verificationId})
      : super(key: key);
  final TextEditingController codeController;
  final String verificationId;

  @override
  State<OtpWidget> createState() => _OtpWidget();
}
class _OtpWidget extends State<OtpWidget> {
  final GlobalKey<FormState> _otpFormKey = GlobalKey();
  Duration myDuration = const Duration(seconds: 60);
  late Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
            (Timer timer) => setState(() {
          if (_start == 0) {
            timer.cancel();
          } else {
            _start = _start-1;
          }
        }));
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _otpFormKey,
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () => { null },
                  child: const Text(
                    'Verification Code',
                    style: TextStyle(
                      fontSize: textMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                (_start == 0) ?
                InkWell(
                  onTap: () => {
                     //const PhoneAuthPage()
                  },
                  child: const Text(
                    'Re-send Code',
                    style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        color: PrimaryBlueOcean),
                  ),
                ) : const InkWell(
                    child: Text(
                      'Re-send Code',
                      style: TextStyle(
                          fontSize: textMedium,
                          fontWeight: FontWeight.w500,
                          color: SecondaryDarkGrey),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: widget.codeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter OTP',
            ),
            validator: (value) {
              if (value!.length != 6) {
                return 'Please enter valid OTP';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () => { null },
                  child: const Text(
                    'Resend time',
                    style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        color: SecondaryDarkGrey),
                  ),
                ),
                InkWell(
                  onTap: () => { null },
                  child: Text(
                    '0:$_start',
                    style: const TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        color: SecondaryDarkGrey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () => {
              if (_otpFormKey.currentState!.validate())
                {_verifyOtp(context: context)},
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
                'Verify OTP',
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

  void _verifyOtp({required BuildContext context}) {
    context.read<PhoneAuthBloc>().add(VerifySentOtpEvent(
        otpCode: widget.codeController.text, verificationId: widget.verificationId));
    widget.codeController.clear();
  }
}
