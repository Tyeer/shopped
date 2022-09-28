import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/timer_builder.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:image_picker/image_picker.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({Key? key, this.friendUid, this.friendName, this.friendImage}) : super(key: key);
  final friendUid;
  final  friendName;
  final friendImage;
  @override
  State<ChatDetail> createState() => _ChatDetailState(friendUid, friendName, friendImage);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final String friendUid;
  final String friendName;
  final String friendImage;

  final currentuser = FirebaseAuth.instance.currentUser!.uid;
  var chatDocId;
  var  _textController = new TextEditingController();
  _ChatDetailState(this.friendUid, this.friendName, this.friendImage);

  void initState(){
    super.initState();
    chats.where('users', isEqualTo: {friendUid:null, currentuser:null}).limit(1).get().then((
        QuerySnapshot querySnapshot
        ) {
      if (querySnapshot.docs.isNotEmpty){
        chatDocId = querySnapshot.docs.single.id;
      }
      else{
        chats.add({
          'users':{
            currentuser:null,friendUid:null
          }
        }).then((value) => {
          chatDocId = value
        });
      }
      
    }).catchError((error){

    });
  }

  void sendMessage(String msg){
    if (msg =='') return;
    chats.doc(chatDocId).collection('messages').add({

      'createdOn': FieldValue.serverTimestamp(),
      'Uid':  currentuser,
      'msg': msg,
    }).then((value) {
      _textController.text = '';
    });

  }





  bool isSender(String friend){
    return friend == currentuser;


  }

  Alignment getAlignment(friend){
    if (friend==currentuser){
      return Alignment.topRight;

    }
    return Alignment.topLeft;
  }

  File? _image;
  Future<void> _openImagePicker() async {
    final _picker = ImagePicker();
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError){
            return Center(
              child: Text('something went wrong '),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting){
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData){
            var data;
            return Scaffold(

              appBar: AppBar(
                title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: Image.network(friendImage,
                          /*widget.imageUrl,*/
                          height: 40.0,
                          width: 40.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                          width: 15
                      ),
                      Text(friendName)
                    ]
                ),
                elevation: 0,
                backgroundColor: Colors.indigo,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document){
                        data = document.data()!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChatBubble(

                            clipper: ChatBubbleClipper6(
                              nipSize: 0,
                              radius: 0,
                              type:BubbleType.receiverBubble
                            ),
                            alignment: getAlignment(data['Uid'].toString()),
                            margin: EdgeInsets.only(top: 20),
                            backGroundColor: isSender(data['Uid'].toString())
                            ?Colors.indigo
                            :Colors.grey,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:MediaQuery.of(context).size.width*0.7,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(data['msg'],
                                      style: TextStyle(
                                        color: isSender(
                                          data['Uid'].toString()
                                        )?Colors.white
                                            :Colors.black
                                      ),
                                      maxLines: 100,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        data['createdOn'] == null
                                            ? DateTime.now().toString()
                                            :data ['createdOn'].toDate()
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isSender(
                                            data['Uid'].toString())
                                                ?Colors.white
                                                :Colors.black

                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),

                          ),
                        );
                      }).toList(),
                    )),

                    (_image != null ) ? Container(
                      width:250,
                      height: 200.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(fit: BoxFit.cover, image: Image.file(_image!, fit: BoxFit.cover,).image),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.redAccent,
                      ),
                    ) : Container(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [


                      Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () {
                              _openImagePicker();
                            },
                            icon: const Center(
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.black,
                                size: 30,
                              ),
                            )
                        )
                    ),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35.0),
                                boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.black)],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textController,
                                      enabled: _image == null,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                          hintText: "Send a message.",
                                          hintStyle: TextStyle(color: Colors.black),
                                          border: InputBorder.none),

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                         /* Expanded(
                              child: TextField(

                                controller: _textController,
                          )),*/

                          Container(
                              decoration:
                              const BoxDecoration(shape: BoxShape.circle, color: Colors.indigo),
                              child: IconButton(
                                  onPressed: () =>sendMessage(
                                    _textController.text
                                  ),
                                  icon: const Center(
                                    child: Icon(
                                      Icons.send_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  )))

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
            ;
          }
           return Container();
        });
  }
}
