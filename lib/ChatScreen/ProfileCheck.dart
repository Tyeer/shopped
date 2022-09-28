import 'package:chat2/AuthScreens/phone_auth_view.dart';
import 'package:chat2/ChatScreen/SignIn.dart';
import 'package:chat2/ChatScreen/SignIn2.dart';
import 'package:chat2/HomeScreens/account_view.dart';
import 'package:chat2/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCheck extends StatefulWidget {
  const ProfileCheck({Key? key}) : super(key: key);

  @override
  State<ProfileCheck> createState() => _ProfileCheckState();
}

class _ProfileCheckState extends State<ProfileCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
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
                if (snapshot.hasData) {
                  return  AccountView();
                }
                return Sign();
              },
            ),
          )),
    );
  }
}
