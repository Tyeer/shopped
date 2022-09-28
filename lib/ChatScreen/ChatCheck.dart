import 'package:chat2/AuthScreens/phone_auth_view.dart';
import 'package:chat2/ChatScreen/SignIn.dart';
import 'package:chat2/HomeScreens/chat_view.dart';
import 'package:chat2/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ChatCheck extends StatefulWidget {
  const ChatCheck({Key? key}) : super(key: key);
  @override
  State<ChatCheck> createState() => _ChatCheckState();
}

class _ChatCheckState extends State<ChatCheck> {
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
                  return  ChatView();
                }
                return SignIn();
              },
            ),
          )),


    );
  }
}
