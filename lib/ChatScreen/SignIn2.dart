import 'package:chat2/AuthScreens/Register_as_view.dart';
import 'package:chat2/AuthScreens/phone_auth_view.dart';
import 'package:flutter/material.dart';

class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(

          child: Opacity(
              opacity: 0.3,
              child:Container(
                child: Center(
                  child: ElevatedButton.icon(

                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => RegisterAsView()));
                    },
                    icon: Icon( // <-- Icon
                      Icons.lock_open_rounded,
                      size: 15.0,
                    ),
                    label: Text('Sign In'),
                    // <-- Text
                  ),
                ),
                color:  Colors.white38,
              )
          )
      ),
    );
  }
}
