import 'package:chat2/AuthScreens/phone_auth_view.dart';
import 'package:chat2/HomeScreens/SplashScreen.dart';
import 'package:chat2/bottom_nav.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/blocs.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopped',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'DMsans',
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: KBgColor,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home:
      RepositoryProvider(
          create: (context) => Repository(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => PhoneAuthBloc(
                  phoneAuthRepository:
                  RepositoryProvider.of<Repository>(context),
                ),
              ),
            ],
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                if (!snapshot.hasData) {
                  return  SplashScreen();
                }
                return const SplashScreen();
              },
            ),
          )),
    );
  }
}



