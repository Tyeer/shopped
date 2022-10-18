import 'package:chat2/AccountDetails/shop_info_view.dart';
import 'package:chat2/HomeScreens/Search.dart';
import 'package:chat2/ProductScreens/ProductDetails.dart';
import 'package:chat2/ProductScreens/ShopDetails.dart';
import 'package:chat2/bloc/seller/seller_bloc.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellersView extends StatefulWidget {
  const SellersView({Key? key}) : super(key: key);

  @override
  State<SellersView> createState() => _SellersViewState();
}

class _SellersViewState extends State<SellersView> {


  void callShopDetail(String Fullname, String Uid, String userImage, String items, String followers, String DateJoined){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ShopDetails(

          Fullname: Fullname,
          Uid: Uid,
          userImage: userImage,
          items: items,
          followers: followers,
          DateJoined: DateJoined,
        )
    ));

  }

  String sellerid = "";

  CollectionReference products = FirebaseFirestore.instance.collection('follower');
  Future<void> deleteproducts(id){


    return FirebaseFirestore.instance.collection('follower')
        .doc(id)
        .delete()
        .then((value) =>
        print(
            'Unfollowing user'
        ))
        .catchError((error)=>
        print(
            'Failed : $error'
        ));

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBgColor,
      appBar: PreferredSize(
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, colors: [Color(0xff016DD1), Color(0xff17259C)])),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>Search()));
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(

                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: "    What are you looking for?",
                              suffixIcon: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(0xff17259C),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>Search()));
                                  },
                                ),
                              ),


                            ),
                          ),
                        ),
                      ),),



                  ],
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(90)),

      body:ListView(
          children: [
          const SizedBox(height: 20),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: Text("Featured",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: SecondaryDarkGrey)),
      ),

        StreamBuilder<QuerySnapshot>  (
        stream: FirebaseFirestore.instance
            .collection('users').
        where('Type', isEqualTo: 'Seller')

        .snapshots(),
    builder: (context, snapshot) {

      if (snapshot.hasError) {
        return Center(child: Text("Something went wrong"));
      }
      else if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

    else {
    return ListView.builder(
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
        itemCount: snapshot.data!.docs.length,
        scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      DocumentSnapshot doc = snapshot.data!.docs[index];

      sellerid = doc['Uid'];
      return

        Container(

          padding: const EdgeInsets.all(paddingHorizontal),
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:  NetworkImage(doc['userImage']),
                    ),
                    const SizedBox(
                      width: 20,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc['Fullname'],
                          style: const TextStyle(
                              fontSize: textMedium, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                           'Malawi',
                          style: const TextStyle(
                              color: SecondaryDarkGrey, fontSize: textMedium),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
/// counting items::::::
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('products')
                                  .where('sellerId',isEqualTo: sellerid )
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  return
                                    Text(
                                      snapshot.data!.docs.length.toString().toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: textMedium,
                                        color: SecondaryDarkGrey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                }
                              },
                            ),



                            const SizedBox(height: 5),
                            const Text(
                              "Items",
                              style: TextStyle(
                                  fontSize: textMedium,
                                  color: SecondaryDarkGrey,
                                  fontWeight: FontWeight.w700),
                            ),

                            const SizedBox(height: 10),



      Container(
      height: 35,
      width: 100,
      child: TextButton(
      onPressed: ()=> {


 Navigator.push(context, MaterialPageRoute(
                                builder: (_) => ShopDetails(

                                  Fullname: doc['Fullname'],
                                  Uid: doc['Uid'],
                                  userImage: doc['userImage'],
                                  items:  doc['items'],
                                  followers: doc['followers'],
                                  DateJoined: doc['DateJoined'],
                                  Phonenumber: doc['Phonenumber'],
                                  AboutShop: doc['aboutshop'].toString(),
                                  ShopName: doc['ShopName'].toString(),
                                  ShopLocation: doc['ShopLocation'],




                                )))
      },




      child: const Text(
      'Go to shop',
      ),
      style: TextButton.styleFrom(
      primary: Colors.white,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5)),
      backgroundColor: PrimaryBlueOcean,
      textStyle: const TextStyle(
      fontSize: 14,
      )),
      ),
      ),


                          ]  ),
                      Column(
                          children: [
                            const SizedBox(height: 10),

///counting total followers
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('follower')
                                  .where('sellerId',isEqualTo: sellerid )
                                  .snapshots(),
                              builder: (context, snapshot) {

                                  return
                                    Text(
                                      snapshot.data!.docs.length.toString().toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: textMedium,
                                        color: SecondaryDarkGrey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );


                              },
                            ),





                            const SizedBox(height: 5),
                            const Text(
                              "Followers",
                              style: TextStyle(
                                  fontSize: textMedium,
                                  color: SecondaryDarkGrey,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 10),

                           GestureDetector(
                              onTap: (){
                                DocumentReference refe =  FirebaseFirestore.instance.collection('follower').doc();

                                Map <String, dynamic> data = {

                                  'follwid' : refe.id,
                                  'Uid' : FirebaseAuth.instance.currentUser!.uid,
                                  'Fullname' : doc['Fullname'],
                                  'AboutShop':doc['aboutshop'],
                                  'Phonenumber': doc['Phonenumber'],
                                  'DateTime' : DateTime.now(),
                                  'location' : doc['ShopLocation'],
                                  'sellerId' : doc['Uid'],
                                  'shopName' : doc['ShopName'],
                                  'userImage' :doc['userImage'],
                                  'status': "following",
                                };
                                refe.set(data).then((value) {
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                    msg:'Following Seller',
                                  );
                                });

                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 100,
                                height: 35,
                                padding:
                                EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      PrimaryBlueOcean,

                                ),
                                child: Center(
                                  child: Text(
                                     'Follow ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color:
                                           Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /*GestureDetector(
                              onTap: (){},
                              child: Container(
                                width: 100,
                                height: 35,
                                padding:
                                EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                  Colors.red,

                                ),
                                child: Center(
                                  child: Text(
                                    'UnFollow',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color:
                                      Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),*/









               /*     StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
          .collection('follower')

                              .where('Uid', isEqualTo: currentuser)
          .snapshots(),
                              builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {

                                if (snapshot.hasData) {
                                  return

                                    Container(
                                      height: 35,
                                      width: 100,
                                      child: TextButton(
                                        onPressed: ()
                                        {

                                          DocumentReference refe =  FirebaseFirestore.instance.collection('follower').doc();

                                          Map <String, dynamic> data = {

                                            'follwid' : refe.id,
                                            'Uid' : currentuser,
                                            'Fullname' : doc['Fullname'],
                                            'AboutShop':doc['aboutshop'],
                                            'Phonenumber': doc['Phonenumber'],
                                            'DateTime' : DateTime.now(),
                                            'location' : doc['ShopLocation'],
                                            'sellerId' : doc['Uid'],
                                            'shopName' : doc['ShopName'],
                                            'userImage' :doc['userImage'],
                                            'status': "following",
                                          };
                                          refe.set(data).then((value) {
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                              msg:'Successfully posted',
                                            );
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Follow',
                                        ),
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            alignment: Alignment.center,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)),
                                            backgroundColor: PrimaryBlueOcean,
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                            )),
                                      ),
                                    );



                                }
                                    return


                                      Container(
                                        height: 35,
                                        width: 100,
                                        child: TextButton(
                                          onPressed: () {
                                            deleteproducts(doc['follwid']);
                                          },
                                          child: const Text(
                                            'UnFollow',
                                          ),
                                          style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              alignment: Alignment.center,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(5)),
                                              backgroundColor: Colors.red,
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                              )),
                                        ),
                                      );





                                ///PhoneAuthPage();
                              },
                            ),*/
///following user


/// unfollow user



                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              doc['DateJoined'],
                              style: const TextStyle(
                                fontSize: textMedium,
                                color: SecondaryDarkGrey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Joined",
                              style: TextStyle(
                                  fontSize: textMedium,
                                  color: SecondaryDarkGrey,
                                  fontWeight: FontWeight.w700),
                            ),

                            const SizedBox(height: 10),

                          ]  ),


                    ]),
                Container(

                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: new ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[

                          StreamBuilder<QuerySnapshot>  (
                              stream: FirebaseFirestore.instance
                                  .collection('products')
                                  .where('sellerId', isEqualTo: doc['Uid'])

                                  .snapshots(),
                              builder: (context, snapshot) {

                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Text('No produts from this seller'),
                                  );
                                }
                                else {

                                  return    ListView.builder(
                                      itemCount: snapshot.data!.docs.length,

                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot docc = snapshot.data!.docs[index];
                                        return GestureDetector(

                                          onTap: ()async{
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ProductDetails(id: docc['productId'],)));
                                          },

                                          child: Column(

                                              children:[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius: BorderRadius.circular(7),
                                                  ),
                                                  margin: EdgeInsets.all(10.0),
                                                  child: new ClipRRect(
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    child: new Image(
                                                      image: new NetworkImage(docc['imageUrl']),
                                                      height: 90,
                                                      width: 90,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Text('K'+ docc['price'] + '.00',
                                                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),)
                                              ]
                                          ),
                                        );

                                      }

                                  );}})

                        ]))
              ])
      );

    });}

    }
        ),



      ]
      )




    );
  }
}


