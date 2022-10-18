import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/widget/transactions_view_tab.dart';

import '../bloc/order/order_bloc.dart';
import '../data/models/order_model.dart';
import '../data/models/seller_model.dart';
import '../data/models/user_model.dart';
import '../data/repository/repository.dart';

class TransactionsView extends StatefulWidget {
  /*const TransactionsView({Key? key, required this.orders}) : super(key: key);
  final List<Order> orders;*/


  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  int _currentIndex = 0;
  final List _screens = [
    Transactions(),
    Summary(),
  ];
  var currentuser = FirebaseAuth.instance.currentUser!.uid;
  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Transactions"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),

      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                "assets/icons/dollar.svg",
                color: PrimaryBlueOcean,
              ),
              icon: SvgPicture.asset("assets/icons/dollar.svg",
                color: SecondaryDarkGrey,),
              label: "Transaction"),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              "assets/icons/chart.svg",
              color: PrimaryBlueOcean,
            ),
            icon: SvgPicture.asset("assets/icons/chart.svg"),
            label: "Summary",
          ),
        ],
      ),
    );
  }
}

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  List<String> categories = [
    "All",
    "Completed",
    "Pending",
    "Refunded",

  ];
  int current = 0;
  // By default our first item will be selected
  int selectedIndex = 0;

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: const EdgeInsets.only(right: 5, left: 5),
        decoration: BoxDecoration(
            color: selectedIndex == index ? activeTabColor : Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            categories[index],
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: selectedIndex == index ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  var currentuser = FirebaseAuth.instance.currentUser!.uid;

  List<String> itmes = [
    "All",
    "Completed",
    "Pending",
    "Refunded",

  ];


  List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.feed,
    Icons.person,
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body:


        Container(
          color: Colors.white,
          child: Column(
            children: [

              SizedBox(height: 20,),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                   /* IconButton(onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Search()));
                    }, icon: Icon(Icons.search)),*/
                    Expanded(
                      child: SizedBox(
                        height: 25,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) => buildCategory(index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              selectedIndex == 0
                  ?
                  ///all
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('buyerId',isEqualTo: FirebaseAuth.instance.currentUser!.uid )
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
                              Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0 ),
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children:[
                                          Text(doc['Date Ordered'],
                                            style: TextStyle(color: Colors.grey,
                                              fontFamily: 'Quickand',

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                CircleAvatar(
                                                  backgroundColor: Colors.blueAccent[100],
                                                  backgroundImage: NetworkImage(doc['imageUrl']),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Column(

                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      doc['productName'].toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: SecondaryDarkGrey,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          doc['Date Ordered'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        const SizedBox(
                                                          width: 90,
                                                        ),
                                                        Text("K" + doc['price'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:  Colors.green,
                                                              fontWeight: FontWeight.w700),)
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),




                                                    Container(
                                                      alignment: Alignment.center,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),

                                                          gradient: LinearGradient(
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                              colors: [
                                                                Colors.green,
                                                                Colors.green,
                                                                Colors.green,
                                                              ])

                                                      ),

                                                      child: Text(doc['orderStatus'],

                                                        style: TextStyle(color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily: 'Quicksand',
                                                        ),
                                                      ),

                                                    ),
                                                  ],
                                                ),


                                              ],
                                            )
                                        )
                                    ),

                                  ]
                              );




                          })

                    ;
                  }
                },
              )
                  : selectedIndex == 2
                  ?
                  ///rejected
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('buyerId',isEqualTo:FirebaseAuth.instance.currentUser!.uid )
                    .where('orderStatus', isEqualTo: "Pending")
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
                              Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0 ),
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children:[
                                          Text(doc['Date Ordered'],
                                            style: TextStyle(color: Colors.grey,
                                              fontFamily: 'Quickand',

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                CircleAvatar(
                                                  backgroundColor: Colors.blueAccent[100],
                                                  backgroundImage: NetworkImage(doc['imageUrl']),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Column(

                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      doc['productName'].toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: SecondaryDarkGrey,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          doc['Date Ordered'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        const SizedBox(
                                                          width: 90,
                                                        ),
                                                        Text("+K " + doc['price'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:  Colors.amber,
                                                              fontWeight: FontWeight.w700),)
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),

                                                          gradient: LinearGradient(
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                              colors: [
                                                                Colors.amber,
                                                                Colors.amber,
                                                                Colors.amber,
                                                              ])

                                                      ),

                                                      child: Text(doc['orderStatus'],

                                                        style: TextStyle(color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily: 'Quicksand',
                                                        ),
                                                      ),

                                                    ),
                                                  ],
                                                ),


                                              ],
                                            )
                                        )
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ]
                              );
                          })

                    ;
                  }
                },
              )
                  : selectedIndex == 1
                  ?

                  ///completed
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('buyerId',isEqualTo: FirebaseAuth.instance.currentUser!.uid )
                    .where('orderStatus', isEqualTo: "Confirmed")
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
                              Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0 ),
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children:[
                                          Text(doc['Date Ordered'],
                                            style: TextStyle(color: Colors.grey,
                                              fontFamily: 'Quickand',

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                CircleAvatar(
                                                  backgroundColor: Colors.blueAccent[100],
                                                  backgroundImage: NetworkImage(doc['imageUrl']),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Column(

                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      doc['productName'].toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: SecondaryDarkGrey,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          doc['Date Ordered'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        const SizedBox(
                                                          width: 90,
                                                        ),
                                                        Text("+K " + doc['price'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:  Colors.green,
                                                              fontWeight: FontWeight.w700),)
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),

                                                          gradient: LinearGradient(
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                              colors: [
                                                                Colors.green,
                                                                Colors.green,
                                                                Colors.green,
                                                              ])

                                                      ),

                                                      child: Text(doc['orderStatus'],

                                                        style: TextStyle(color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily: 'Quicksand',
                                                        ),
                                                      ),

                                                    ),
                                                  ],
                                                ),


                                              ],
                                            )
                                        )
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ]
                              );
                          })

                    ;
                  }
                },
              )
                  : selectedIndex == 3 ?
/// refunded
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('buyerId',isEqualTo: FirebaseAuth.instance.currentUser!.uid )
                    .where('orderStatus', isEqualTo: "Cancelled")
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
                              Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0 ),
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children:[
                                          Text(doc['Date Ordered'],
                                            style: TextStyle(color: Colors.grey,
                                              fontFamily: 'Quickand',

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                CircleAvatar(
                                                  backgroundColor: Colors.blueAccent[100],
                                                  backgroundImage: NetworkImage(doc['imageUrl']),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Column(

                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      doc['productName'].toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: SecondaryDarkGrey,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          doc['Date Ordered'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        const SizedBox(
                                                          width: 90,
                                                        ),
                                                        Text("-K " + doc['price'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:  Colors.red,
                                                              fontWeight: FontWeight.w700),)
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
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

                                                      child: Text(doc['orderStatus'],

                                                        style: TextStyle(color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily: 'Quicksand',
                                                        ),
                                                      ),

                                                    ),
                                                  ],
                                                ),


                                              ],
                                            )
                                        )
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ]
                              );
                          })

                    ;
                  }
                },
              )
                  : SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    50,

              ),
            ],
          ),
        )


      ,/* Container(
            child: new ListView(
                children: <Widget>[
                  Column(
                      children: <Widget>[

                        BottomSection()

                      ])])),*/

    );

   /*Container(

      margin: const EdgeInsets.all(5),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [




          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                children: [
                  Expanded(
                      child:


                      ListView(
                          children: [

                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      child: Row(
                                        children: [

                                          Expanded(
                                            child: SizedBox(
                                              height: 25,
                                              child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: categories.length,
                                                itemBuilder: (context, index) => buildCategory(index),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    current == 0
                                        ?///all for products and orders

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
                                                  return
                                                    Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0 ),
                                                            child:Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children:[
                                                                Text(doc['Date Ordered'],
                                                                  style: TextStyle(color: Colors.grey,
                                                                    fontFamily: 'Quickand',

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              child: Padding(
                                                                  padding: const EdgeInsets.all(20),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [

                                                                      CircleAvatar(
                                                                        backgroundColor: Colors.blueAccent[100],
                                                                        backgroundImage: NetworkImage(doc['imageUrl']),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      Column(

                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            doc['productName'].toUpperCase(),
                                                                            style: const TextStyle(
                                                                                fontSize: 12,
                                                                                color: SecondaryDarkGrey,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                doc['Date Ordered'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    color: Colors.grey,
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 90,
                                                                              ),
                                                                              Text("K" + doc['price'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    color:  Colors.green,
                                                                                    fontWeight: FontWeight.w700),)
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Container(
                                                                            alignment: Alignment.center,
                                                                            width: 100,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),

                                                                                gradient: LinearGradient(
                                                                                    begin: Alignment.centerLeft,
                                                                                    end: Alignment.centerRight,
                                                                                    colors: [
                                                                                      Colors.green,
                                                                                      Colors.green,
                                                                                      Colors.green,
                                                                                    ])

                                                                            ),

                                                                            child: Text(doc['orderStatus'],

                                                                              style: TextStyle(color: Colors.white,
                                                                                fontSize: 20,
                                                                                fontFamily: 'Quicksand',
                                                                              ),
                                                                            ),

                                                                          ),
                                                                        ],
                                                                      ),


                                                                    ],
                                                                  )
                                                              )
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ]
                                                    );
                                                })

                                          ;
                                        }
                                      },
                                    )




                                        : current == 2
                                        ?
                                    ///all for pending transactions
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('orders')
                                          .where('sellerId',isEqualTo: currentuser )
                                          .where('orderStatus', isEqualTo: "pending")
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
                                                    Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0 ),
                                                            child:Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children:[
                                                                Text(doc['Date Ordered'],
                                                                  style: TextStyle(color: Colors.grey,
                                                                    fontFamily: 'Quickand',

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              child: Padding(
                                                                  padding: const EdgeInsets.all(20),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [

                                                                      CircleAvatar(
                                                                        backgroundColor: Colors.blueAccent[100],
                                                                        backgroundImage: NetworkImage(doc['imageUrl']),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      Column(

                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            doc['productName'].toUpperCase(),
                                                                            style: const TextStyle(
                                                                                fontSize: 12,
                                                                                color: SecondaryDarkGrey,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                doc['Date Ordered'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    color: Colors.grey,
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 90,
                                                                              ),
                                                                              Text("+K " + doc['price'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    color:  Colors.amber,
                                                                                    fontWeight: FontWeight.w700),)
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Container(
                                                                            alignment: Alignment.center,
                                                                            width: 100,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),

                                                                                gradient: LinearGradient(
                                                                                    begin: Alignment.centerLeft,
                                                                                    end: Alignment.centerRight,
                                                                                    colors: [
                                                                                      Colors.amber,
                                                                                      Colors.amber,
                                                                                      Colors.amber,
                                                                                    ])

                                                                            ),

                                                                            child: Text(doc['orderStatus'],

                                                                              style: TextStyle(color: Colors.white,
                                                                                fontSize: 20,
                                                                                fontFamily: 'Quicksand',
                                                                              ),
                                                                            ),

                                                                          ),
                                                                        ],
                                                                      ),


                                                                    ],
                                                                  )
                                                              )
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ]
                                                    );
                                                })

                                          ;
                                        }
                                      },
                                    )
                                        : current == 1
                                        ?

                                    ///completed
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('orders')
                                          .where('sellerId',isEqualTo: currentuser )
                                          .where('orderStatus', isEqualTo: "confirmed")
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
                                                    Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0 ),
                                                            child:Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children:[
                                                                Text(doc['Date Ordered'],
                                                                  style: TextStyle(color: Colors.grey,
                                                                    fontFamily: 'Quickand',

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              child: Padding(
                                                                  padding: const EdgeInsets.all(20),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [

                                                                      CircleAvatar(
                                                                        backgroundColor: Colors.blueAccent[100],
                                                                        backgroundImage: NetworkImage(doc['imageUrl']),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      Column(

                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            doc['productName'].toUpperCase(),
                                                                            style: const TextStyle(
                                                                                fontSize: 12,
                                                                                color: SecondaryDarkGrey,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                doc['Date Ordered'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    color: Colors.grey,
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 90,
                                                                              ),
                                                                              Text("+K " + doc['price'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    color:  Colors.green,
                                                                                    fontWeight: FontWeight.w700),)
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Container(
                                                                            alignment: Alignment.center,
                                                                            width: 100,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),

                                                                                gradient: LinearGradient(
                                                                                    begin: Alignment.centerLeft,
                                                                                    end: Alignment.centerRight,
                                                                                    colors: [
                                                                                      Colors.green,
                                                                                      Colors.green,
                                                                                      Colors.green,
                                                                                    ])

                                                                            ),

                                                                            child: Text(doc['orderStatus'],

                                                                              style: TextStyle(color: Colors.white,
                                                                                fontSize: 20,
                                                                                fontFamily: 'Quicksand',
                                                                              ),
                                                                            ),

                                                                          ),
                                                                        ],
                                                                      ),


                                                                    ],
                                                                  )
                                                              )
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ]
                                                    );
                                                })

                                          ;
                                        }
                                      },
                                    )
                                        :
                                    current == 3 ?
                                    ///all for refunded transactions
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('orders')
                                          .where('sellerId',isEqualTo: currentuser )
                                          .where('orderStatus', isEqualTo: "cancelled")
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
                                                    Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0 ),
                                                            child:Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children:[
                                                                Text(doc['Date Ordered'],
                                                                  style: TextStyle(color: Colors.grey,
                                                                    fontFamily: 'Quickand',

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                              child: Padding(
                                                                  padding: const EdgeInsets.all(20),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [

                                                                      CircleAvatar(
                                                                        backgroundColor: Colors.blueAccent[100],
                                                                        backgroundImage: NetworkImage(doc['imageUrl']),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      Column(

                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            doc['productName'].toUpperCase(),
                                                                            style: const TextStyle(
                                                                                fontSize: 12,
                                                                                color: SecondaryDarkGrey,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                doc['Date Ordered'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    color: Colors.grey,
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 90,
                                                                              ),
                                                                              Text("-K " + doc['price'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    color:  Colors.red,
                                                                                    fontWeight: FontWeight.w700),)
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          Container(
                                                                            alignment: Alignment.center,
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

                                                                            child: Text(doc['orderStatus'],

                                                                              style: TextStyle(color: Colors.white,
                                                                                fontSize: 20,
                                                                                fontFamily: 'Quicksand',
                                                                              ),
                                                                            ),

                                                                          ),
                                                                        ],
                                                                      ),


                                                                    ],
                                                                  )
                                                              )
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ]
                                                    );
                                                })

                                          ;
                                        }
                                      },
                                    )
                                        :
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height -
                                          MediaQuery.of(context).padding.top -
                                          MediaQuery.of(context).padding.bottom -
                                          50,

                                    ),
                                  ],
                                ),
                              ),
                            ),


                          ]))]),
          )

        ],
      ),
    );*/



  }
}

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _Summary();
}



class _Summary extends State<Summary> {

  final Repository repo = Repository();
  final OrderBloc _allOrdersBloc = OrderBloc(orderRepository: Repository());
  @override
  void initState() {
    super.initState();
  }
  var sumTotal ;
  var total ;
  var total2 ;
  var total3 ;
  var sumTotal2 ;
  var sumTotal3 ;
  var currentuser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return

              Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Completed ",
                          style: const TextStyle(
                              fontSize: textMedium, fontWeight: FontWeight.bold),
                        ),
                         SizedBox(
                          height: 10,
                        ),

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('buyerId',isEqualTo: currentuser )
                              .where('orderStatus', isEqualTo: "Confirmed")
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {

                            if (snapshots.hasError) {
                              return Text("Something went wrong");
                            }


                            if (snapshots.hasData) {
                              snapshots.data!.docs.forEach((doc) {

                                sumTotal = int.tryParse(doc['price']);
                               total = sumTotal + sumTotal;
                                // make sure you create the variable sumTotal somewhere
                              });
                              return Text("K ${total}.00",
                                  style: const TextStyle(
                                      fontSize: textLarge, fontWeight: FontWeight.bold));
                            }

                            return Text("loading");
                          },
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: .1,
                        ),
                        Text(
                          "Pending",
                          style: const TextStyle(
                              fontSize: textMedium, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('buyerId',isEqualTo: currentuser )
                              .where('orderStatus', isEqualTo: "Pending")
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {

                            if (snapshots.hasError) {
                              return Text("Something went wrong");
                            }


                            if (snapshots.hasData) {
                              snapshots.data!.docs.forEach((doc) {

                                sumTotal2 = int.tryParse(doc['price']);
                                total2 = sumTotal2 + sumTotal2;
                                // make sure you create the variable sumTotal somewhere
                              });
                              return Text("K ${total2}.00",
                                  style: const TextStyle(
                                      fontSize: textLarge, fontWeight: FontWeight.bold));
                            }

                            return Text("loading");
                          },
                        ),

                        const Divider(
                          color: Colors.grey,
                          thickness: .1,
                        ),
                        Text(
                          "Refunded",
                          style: const TextStyle(
                              fontSize: textMedium, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('buyerId',isEqualTo: currentuser )
                              .where('orderStatus', isEqualTo: "Cancelled")
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {

                            if (snapshots.hasError) {
                              return Text("Something went wrong");
                            }


                            if (snapshots.hasData) {
                              snapshots.data!.docs.forEach((doc) {

                                sumTotal3 = int.tryParse(doc['price']);
                                total3 = sumTotal3 + sumTotal3;

//${total3}
                                // make sure you create the variable sumTotal somewhere
                              });
                              return Text("K 0.00",
                                  style: const TextStyle(
                                      fontSize: textLarge, fontWeight: FontWeight.bold));
                            }

                            return Text("loading");
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );



  }
}
