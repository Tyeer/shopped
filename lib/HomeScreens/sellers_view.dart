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


  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;


  getFollowersCount(shopid) async {
    int followersCount =
    await DatabaseServices.followersNum(shopid);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }
  getFollowingCount(number) async {
    int followingCount =
    await DatabaseServices.followingNum(number);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
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

                   /* GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>Search()));
                      },
                      child: Container(
                        width: 390,
                        height: 40,
                        decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(20)),

                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(left: 33),
                            child: TextField(
                              style: TextStyle(

                                fontSize: 12,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w200,
                              ),
                              decoration: InputDecoration(

                                hintText: 'What are you looking for?',
                                hintStyle:
                                const TextStyle(color: SecondaryDarkGrey, fontSize: 18),
                                border: InputBorder.none,
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
                        ),

                      ),
                    ),*/

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
                            Text(
                             doc['items'].toString(),
                              style: const TextStyle(
                                fontSize: textMedium,
                                color: SecondaryDarkGrey,
                                fontWeight: FontWeight.w700,
                              ),
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
                            Text(
                              " ${_followersCount}",
                              style: const TextStyle(
                                fontSize: textMedium,
                                color: SecondaryDarkGrey,
                                fontWeight: FontWeight.w700,
                              ),
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

                            _isFollowing ?
                            SizedBox(
                              height: 35,
                              width: 100,
                              child: TextButton(
                                onPressed: ()
                                {

                                //  unFollowUser( (doc['Uid'] ));

                                },
                                child: const Text(
                                  'UnFollow',
                                ),
                                style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    alignment: Alignment.center,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    backgroundColor: Colors.redAccent,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                    )),
                              ),
                            ):
                            SizedBox(
                              height: 35,
                              width: 100,
                              child: TextButton(
                                onPressed: ()
                                {
                                 // followUser( doc['Uid'] );

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
                            )
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

class DatabaseServices {
  static Future<int> followersNum(String userId) async {
    QuerySnapshot followersSnapshot =
    await FirebaseFirestore.instance.collection('followers').doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
  }

  static Future<int> followingNum(String userId) async {
    QuerySnapshot followingSnapshot =
    await  FirebaseFirestore.instance.collection('following').doc(userId).collection('Following').get();
    return followingSnapshot.docs.length;
  }




  static void followUser(String currentUserId, String visitedUserId) {
    FirebaseFirestore.instance.collection('following')
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .set({});
    FirebaseFirestore.instance.collection('followers')
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .set({});


    Fluttertoast.showToast(
        msg: "Following User",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,    // location
        timeInSecForIosWeb: 1               // duration
    );

  }

  static void unFollowUser(String currentUserId, String visitedUserId) {
    FirebaseFirestore.instance.collection('following')
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    FirebaseFirestore.instance.collection('followers')
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });



    Fluttertoast.showToast(
        msg: "Un follow User",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,    // location
        timeInSecForIosWeb: 1               // duration
    );
  }

  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await
    FirebaseFirestore.instance.collection('followers')
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }



}

