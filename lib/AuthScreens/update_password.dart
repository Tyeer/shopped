import 'package:flutter/material.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/main.dart';


class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool passwordVisible = true;
  void initState2(){
    super.initState();
    passwordVisible = true;
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
          context, MaterialPageRoute(builder: (context) => MyApp())),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: PrimaryBlueOcean,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          'Save Update',
          style: TextStyle(
              fontSize: textMedium,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Password',
          style: TextStyle(
            fontSize: textLarge,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Replace the password",
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
                  children: <Widget>[
                    Text(
                      'New Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: textMedium,
                      ),
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
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Confirm New Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: textMedium,
                      ),
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
              SizedBox(
                height: 128,
              ),
              _submitButton(),
            ],
          ),
        ));
  }
}
