import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat2/helpers/constants.dart';

class FollowsView extends StatefulWidget {


  @override
  State<FollowsView> createState() => _FollowsViewState();
}

class _FollowsViewState extends State<FollowsView> {


  @override
  void initState() {
    super.initState();
  }

  CollectionReference products = FirebaseFirestore.instance.collection('followers');
  Future<void> deleteproducts(id){


    return products
        .doc(id)
        .delete()
        .then((value) =>
        print(
            'Product details deleted successfully'
        ))
        .catchError((error)=>
        print(
            'Failed to delete Product : $error'
        ));

  }
  var currentuser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBgColor,
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Follows"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),
      body:Container(
        child: ListView(
          children: [

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('followers')
                  .where('Uid',isEqualTo: currentuser )
                  .snapshots(),
              builder: (context, snapshot) {

                return
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20 ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Text(snapshot.data!.docs.length .toString() + ' Shops',
                    style: TextStyle(color: Colors.grey,
                      fontFamily: 'Quickand',

                    ),
                  ),
                ],
              ),

    );

  },
  ),
            StreamBuilder<QuerySnapshot>  (
                stream: FirebaseFirestore.instance
                    .collection('followers')
                    .where('Uid',isEqualTo: currentuser )

                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  else {

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];

                          return

    Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            CircleAvatar(
                              backgroundColor: Colors.blueAccent[100],
                              backgroundImage: NetworkImage(doc['userImage']),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc['shopName'],
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: SecondaryDarkGrey,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      doc['location'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      width: 130,
                                    ),

                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                              ],
                            ),


                          ],
                        ),
SizedBox(height: 10,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap:(){

                                deleteproducts(doc['follwid']);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),

                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.red,
                                          Colors.red,
                                          Colors.red,
                                        ])

                                ),

                                child: Text('Unfollow',

                                  style: TextStyle(color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),

                              ),
                            ),
                            SizedBox(width: 170,),




                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),

                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xff016DD1),
                                        Color(0xff016DD1),
                                        Color(0xff016DD1),
                                      ])

                              ),

                              child: Text('Go to Shop',

                                style: TextStyle(color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Quicksand',
                                ),
                              ),

                            ),




                          ],
                        )
                      ],
                    )
                )
            )


    ;

  }



  );
}})


          ],
        ),
      ),
    );
  }
}
