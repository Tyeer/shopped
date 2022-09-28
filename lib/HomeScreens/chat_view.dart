import 'package:chat2/ChatScreen/ChatDetail.dart';
import 'package:chat2/ChatScreen/ChatScreen.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  get uid => FirebaseAuth.instance.currentUser!.uid;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  var currentuser = FirebaseAuth.instance.currentUser!.uid;


void callChatDetail(String name, String uid, String image){
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => ChatDetail(

      friendName: name,
      friendUid: uid,
      friendImage: image,
    )
  ));

}


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
        title: const Center(child: Text('Chats'),),
      ),


      body: Container(
          padding: const EdgeInsets.all(kDefaultPaddin),
          child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),


                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').where('Uid', isNotEqualTo: currentuser ).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (snapshot.hasError){
                        return Center(
                          child: Text('something went wrong '),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: Text('Loading'),
                        );
                      }
                      if (snapshot.hasData){
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),

                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];
                              return  Container(
                                child: Column(
                                    children:[
                                      Slidable(
                                        key: const ValueKey(1),
                                        endActionPane: const ActionPane(
                                          motion: ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              flex: 2,
                                              onPressed: null,
                                              backgroundColor: KBgColor,
                                              foregroundColor: Colors.black,
                                              icon: Icons.more_horiz_outlined,
                                            ),
                                            SlidableAction(
                                              flex: 2,
                                              onPressed: null,
                                              backgroundColor: KBgColor,
                                              foregroundColor: Colors.red,
                                              icon: Icons.delete_outline,
                                            ),
                                          ],
                                        ),
                                        child:
                                        ListTile(
                                            onTap: () {

                                              callChatDetail(
                                                  doc['Fullname'],
                                                  doc['Uid'],
                                                  doc['userImage']
                                              )
                                              ;
                                            },
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.blue,
                                              backgroundImage: NetworkImage(doc['userImage']),
                                            ),
                                            title: Text(
                                              doc['Fullname'],
                                              style: const TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                            subtitle:  Text(
                                                doc['Password'],
                                                style: const TextStyle(
                                                    fontSize: 12, color: Colors.grey)
                                            ),


                                            trailing: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                /*CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.red,
                                                  child: Text(
                                                    "1",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),*/

                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [

                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '22/08/2022',
                                                      style: const TextStyle(color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )

                                        ),
                                      ),
                                    ]
                                ),
                              );
                            }


                        );
                      }
                      else return CircularProgressIndicator();
                    }),

              ]
          )
      ),




    );
  }


}