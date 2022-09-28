import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTextFied extends StatefulWidget {
   MessageTextFied( {Key? key, required this.currentid, required this.friendid}) : super(key: key);

   final String currentid;
  final  String friendid;
  @override
  State<MessageTextFied> createState() => _MessageTextFiedState();
}

class _MessageTextFiedState extends State<MessageTextFied> {
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return

      Container(
      child: Row(
        children: [
          Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: IconButton(
                  onPressed: () {
                   // _openImagePicker();
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
                      controller: message,
                    //  enabled: _image == null,
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

          Container(
              decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.indigo),
              child: IconButton(
                  onPressed: () async{
               var text = message.text;
               message.clear();
               await FirebaseFirestore.instance
                    .collection('users')
               .doc(widget.currentid)
               .collection('message')
               .doc(widget.friendid)
               .collection('chats').add({
                 'senderid': widget.currentid,
                 'recieverid': widget.friendid,
                 'message': message,
                 'type' : 'Text',
                 'date' : DateTime.now(),
               }).then((value) {

                 FirebaseFirestore.instance
                     .collection('users')
                     .doc(widget.currentid)
                     .collection('message')
                     .doc(widget.friendid)
                     .set({
                   'last_message' : message,
                   'date': DateTime.now(),
                 });
               });

               await FirebaseFirestore.instance
                   .collection('users')
                    .doc(widget.friendid)
                    .collection('message')
                    .doc(widget.currentid)
                    .collection('chats')
                    .add({
                 'senderid': widget.currentid,
                 'recieverid': widget.friendid,
                 'message': message,
                 'type' : 'Text',
                 'date' : DateTime.now(),
               }).then((value) {
                 FirebaseFirestore.instance
                     .collection('users')
                     .doc(widget.friendid)
                     .collection('message')
                     .doc(widget.currentid)
                     .set({
                   'last_message' : message,
                   'date': DateTime.now(),
                 });
               });
                  },
                  icon: const Center(
                    child: Icon(
                      Icons.send_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  )))
        ],
      ),
    );
  }
}
