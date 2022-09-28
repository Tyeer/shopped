import 'package:chat2/AccountDetails/change_number.dart';
import 'package:chat2/AccountDetails/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat2/helpers/constants.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Security"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Security",
              style:
                  TextStyle(fontWeight: FontWeight.w700, fontSize: textMedium),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OfficialListWidget(
                        leftIcon: "assets/icons/account.svg",
                        label: "My Account",
                        detail: "Make change to your account",
                        icon: true,
                        press: null),
                    SizedBox(
                      height: 20,
                    ),
                    OfficialListWidget(
                      leftIcon: "assets/icons/sign-out.svg",
                      label: "Change Password",
                      detail: "Put new password",
                      icon: true,
                      press: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordView()));
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OfficialListWidget(
                      leftIcon: "assets/icons/flag.svg",
                      label: "+265 888 484 921",
                      detail: "Change number",
                      icon: true,
                      press: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNumber()));
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),OfficialListWidget(
                      leftIcon: "assets/icons/lock.svg",
                      label: "Face ID / Touch ID",
                      detail: "Manage your device security",
                      icon: true,
                      press: null,
                    ),
                    SizedBox(
                      height: 20,
                    ),OfficialListWidget(
                      leftIcon: "assets/icons/safety.svg",
                      label: "Two-Factor Authentication",
                      detail: "Further secure your account for safety",
                      icon: true,
                      press: null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OfficialListWidget(
                      leftIcon: "assets/icons/sign-out.svg",
                      label: "Diactivate Account  ",
                      detail: "",
                      icon: true,
                      press: null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OfficialListWidget extends StatelessWidget {
  String leftIcon;
  String label;
  String detail;
  bool icon;
  VoidCallback? press;
  OfficialListWidget(
      {required this.leftIcon,
      required this.label,
      required this.icon,
      required this.detail,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: SecondaryDarkGrey.withOpacity(.3),
                  shape: BoxShape.circle),
              child: SvgPicture.asset(
                "${leftIcon}",
                color: PrimaryBlueOcean,
                height: 15,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${label}",
                    style: TextStyle(
                        fontSize: textMedium, fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${detail}",
                  style:
                      TextStyle(fontSize: textSmall, color: SecondaryDarkGrey),
                )
              ],
            )
          ],
        ),
        if (icon != false)
          IconButton(
            onPressed: press,
            icon: SvgPicture.asset(
              "assets/icons/right.svg",
              color: SecondaryDarkGrey,
            ),
          )
      ],
    );
  }
}
