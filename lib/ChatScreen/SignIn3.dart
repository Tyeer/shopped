import 'package:chat2/AuthScreens/Register_as_view.dart';
import 'package:chat2/AuthScreens/phone_auth_view.dart';
import 'package:flutter/material.dart';

class SignInt extends StatefulWidget {
  const SignInt({Key? key}) : super(key: key);

  @override
  State<SignInt> createState() => _SignIntState();
}

class _SignIntState extends State<SignInt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
        title: const Center(child: Text('Product Details'),),
      ),*/
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
