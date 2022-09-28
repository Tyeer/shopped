import 'dart:io';
import 'dart:math';

import 'package:chat2/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    required this.currentUser,
    required this.friendId,
    required this.friendimage,
    required this.friendName,
    required this.currentid,
    required this.friendid}) :
        super(key: key);


  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendimage;
  var currentuser2 = FirebaseAuth.instance.currentUser!.uid;

  final String currentid;
  final  String friendid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.network(widget.friendimage,
                  /*widget.imageUrl,*/
                  height: 40.0,
                  width: 40.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                  width: 15
              ),
              Text(widget.friendName)
            ]
        ),
        elevation: 0,
        backgroundColor: Colors.indigo,
      ),

    );
  }
}


