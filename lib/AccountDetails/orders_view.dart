import 'package:chat2/AccountDetails/Order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:chat2/helpers/constants.dart';



class OrdersView extends StatelessWidget {
  var currentuser = FirebaseAuth.instance.currentUser!.uid;
  final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Orders"),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
              ),
            )),
        body: ListView(

            children: [


              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('sellerId',isEqualTo: currentuser )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    
                    return
                    ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
    itemCount: snapshot.data!.docs.length,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  return  GestureDetector(
                      onTap: () { Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetailsView(

                                id2: doc['Oid'],

                              )));},
                      child:
                      Card(

                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {

                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.network(
                                            "https://www.svgrepo.com/show/13663/user.svg",
                                            height: 20,

                                            color: Colors.amberAccent,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),

                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .where('Uid',isEqualTo: doc['buyerId'])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator();
                                              } else {
                                                return
                                                  ListView.builder(
                                                shrinkWrap: true,
                                                physics: ClampingScrollPhysics(),
    itemCount: snapshot.data!.docs.length,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      DocumentSnapshot doc = snapshot.data!.docs[index];
      return
        Text(
          doc['Fullname'],
          style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        );
    }
                                                  );
    }
    },
    ),



                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Details",
                                            style: TextStyle(
                                                fontSize: textMedium,
                                                color: priceColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SvgPicture.asset(
                                            "assets/icons/detail.svg",
                                            height: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: NetworkImage(doc['imageUrl']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20,),
                                            Text(
                                             doc['productName'],
                                              style: const TextStyle(
                                                  fontSize: textMedium,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  doc['price'].toString(),
                                                  style: const TextStyle(
                                                      color: priceColor,
                                                      fontSize: textMedium,
                                                      fontWeight: FontWeight.bold),
                                                ),

                                                const SizedBox(
                                                  width: 170,
                                                ),
                                                Text(
                                                  "x" + doc['quantity'].toString(),
                                                  style: const TextStyle(
                                                      fontSize: textMedium,
                                                      fontWeight: FontWeight.bold),
                                                ),

                                              ],),


                                          ],
                                        ),




                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(doc['Date Ordered'].toString(),
                                      // DateFormat.yMMMd().add_Hm().format(format.parse(order.createdAt)).toString(),
                                      style: const TextStyle(
                                          fontSize: textMedium, color: SecondaryDarkGrey),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: greenColor,
                                        ),
                                        child: Text(doc['orderStatus'],
                                          //order.orderStatus,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: textSmall,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      //order.quantity +
                                      doc['quantity'].toString() + " items",
                                      style: const TextStyle(fontSize: textMedium),
                                    ),
                                    Text(
                                      "K " + doc['totalAmount'].toString() + '.00',

                                      style: const TextStyle(
                                          color: priceColor,
                                          fontSize: textMedium,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                      )
                  );
                  })

    ;
                  }
                },
              ),


             




            ],



        ));
  }
}

