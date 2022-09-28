import 'package:chat2/bottom_nav.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState(){
 super.initState();
 Future.delayed(const Duration(seconds: 5), (){
   Navigator.pushReplacement(context, MaterialPageRoute
     (builder: (context)=>BottomNav()
   ));
 } );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Image.asset(
              'assets/icons/logo.png',
              height: 82,
              width: 263,
            ),
            const SizedBox(height: 20,),
          const  CircularProgressIndicator(
              color: Color(0xff016DD1),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
