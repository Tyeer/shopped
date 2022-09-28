import 'dart:math';
import 'package:chat2/AuthScreens/Register_as_view.dart';
import 'package:chat2/AuthScreens/phone_auth_view.dart';
import 'package:chat2/ChatScreen/ChatDetail.dart';
import 'package:chat2/ProductScreens/OrderView.dart';
import 'package:chat2/ProductScreens/ShopDetails.dart';
import 'package:chat2/bottom_nav.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.id}) : super(key: key);
  final String? id;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {


  String _phone = "";
  @override
  void initState() {
    super.initState();
  }


  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  final FirebaseFirestore? _firebaseFirestore = FirebaseFirestore.instance;

  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;
  bool passwordVisible = true;
  void initState2(){
    super.initState();
    passwordVisible = true;
  }

  getFollowersCount(shopid) async {
    int followersCount =
    await DatabaseServices.followersNum(shopid);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  setupIsFollowing(currentid, id) async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(currentid, id);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }


  bool loading =false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUID() async{
    return (_auth.currentUser)!.uid;
  }


  final TextEditingController email = TextEditingController();
  final TextEditingController pasword = TextEditingController();

  void validator (){
    if (email.text.isEmpty && pasword.text.isEmpty ){

      Fluttertoast.showToast(
          msg:'Please Enter Email and Password'
      );
    }
    else if(email.text.isEmpty){
      Fluttertoast.showToast(
          msg:'Please Enter Email '
      );
    }
    else if(pasword.text.isEmpty){
      Fluttertoast.showToast(
          msg:'Please Enter Password'
      );
    }
    else{
      setState(() {
        loading = true  ;
      });
      login();
    }
  }
  void login(){
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: pasword.text).then((UserCredential userCredetial){

      //move to home screen

      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg:'Login Successfully ',
      );
      HomeScreen();
    }).catchError((error){
      //show error

      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg:error.toString(),
      );
    });

  }


  void HomeScreen(){

    Navigator.pop(context);
    /*Navigator.of(context).pushReplacement(

      MaterialPageRoute(builder: (context)=>BottomNav()),
    );*/
  }
  void SignInModal(context){
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return
        Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height *.40,
    child: Column(
    children: [

      Center(

          child: Padding(
            padding:   const EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child:

            Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                     Text('Dont have an account', style: TextStyle(fontFamily: 'DMsans',fontSize: 15,fontWeight: FontWeight.bold, color: Colors.grey),),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterAsView()));
                          },

                          child: Text('Sign Up', style: TextStyle(fontFamily: 'DMsans',
                              color: PrimaryBlueOcean,fontSize: 15, fontWeight: FontWeight.bold),)),
                    ),
                  ],
                ),


                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Enter Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: textMedium),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        height: 45,
                        padding: const EdgeInsets.all(5),

                        decoration: BoxDecoration(
                          color: Color(0xfff2f2f2),
                          border: Border.all(
                            color: Color(0xfff2f2f2),
                            width: 1,
                          ),

                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(


                          controller: email,
                          textInputAction: TextInputAction.next,
                          cursorColor: const Color(0xFFffffff),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,

                            fillColor: Color(0xfff2f2f2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Enter Password",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: textMedium),
                      ),
                      SizedBox(
                        height: 10,
                      ),


                      Container(
                        height: 45,
                        padding: const EdgeInsets.all(5),


                        decoration: BoxDecoration(
                          color: Color(0xfff2f2f2),
                          border: Border.all(
                            color: Color(0xfff2f2f2),
                            width: 1,
                          ),

                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(

                          controller: pasword,
                          obscureText: passwordVisible,
                          textInputAction: TextInputAction.done,
                          cursorColor: const Color(0xFFffffff),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            suffixIcon: IconButton(
                              iconSize: 15,
                              icon: Icon(

                                passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            fillColor: Color(0xfff2f2f2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),




                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    validator();
                  },
                  child:



                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: PrimaryBlueOcean,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child:


                    loading ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Processing...",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: textMedium,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                              strokeWidth: 1, color: Colors.white),
                        )
                      ],
                    ) :

                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),





              ],
            ),
          ),
      ),
   

    ])),
        );});}

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<DocumentSnapshot <Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('products')

            .doc(widget.id).get(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            print("something is wrong here");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          var data = snapshot.data!.data();

          var price = data!['price'];
          var description = data!['description'];
          var productStatus = data!['productStatus'];
          var quantity = data!['quantity'];
          var condition = data!['condition'];
          var category = data!['category'];
          var imageUrl = data!['imageUrl'];
          var sellerId = data!['sellerId'];
          var productId = data!['productId'];
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                title: Text(data!['name']),
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
                  ),
                )),

          body: Column(
          children: [
          Expanded(

          child: ListView(
          children: [

          Column(
          children: [
          Column(
          children: [
            Container(
              width: 400,
              height: 400,
              margin: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage('${imageUrl}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal, vertical: paddingHorizontal),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    children: [
                                      InkWell(
                                        onTap:  () async {

                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/heart.svg",
                                          color: SecondaryDarkGrey,
                                          height: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          '2',
                                      ),
                                    ]),
                                Text(
                                  '${productStatus}',
                                  style:
                                  TextStyle(color: greenColor, fontSize: textSmall),
                                )
                              ]
                          ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              data!['name'],
                              style: const TextStyle(
                                  fontSize: textMedium, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              'K ${((price).toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.00',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              " ${condition}",
                              style: const TextStyle(
                                fontSize: textMedium,
                              ),
                            ),

                          ]
                      )
                  )
                  ),

            Container(
              padding: const EdgeInsets.all(paddingHorizontal),
              margin: const EdgeInsets.only(bottom: 5),
              width: 410,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Item Details",
                    style: TextStyle(fontSize: textMedium, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${description}',
                    style: const TextStyle(fontSize: textMedium),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            StreamBuilder<QuerySnapshot>  (
                stream: FirebaseFirestore.instance
                    .collection('users').
                where('Type', isEqualTo: 'Seller').
                where('Uid', isEqualTo: sellerId)
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
                                              ' Malawi',
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
                                                SizedBox(
                                                  height: 35,
                                                  width: 100,
                                                  child: TextButton(
                                                    onPressed: ()
                                                    {
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (_) => ShopDetails(

                                                            Fullname: doc['Fullname'],
                                                            Uid: doc['Uid'],
                                                            userImage: doc['userImage'],
                                                            items:  doc['items'],
                                                            followers: doc['followers'],
                                                            DateJoined: doc['DateJoined'],
                                                            Phonenumber: doc['Phonenumber'],
                                                            AboutShop: doc['aboutshop'],
                                                              ShopName: doc['ShopName'],


                                                          )));
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

                                                     // unFollowUser(currentuser, (doc['Uid'] ));

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
                                                   //   followUser(currentuser, doc['Uid'] );
                                                      var dateFormat = DateFormat('MMM d, yyyy');
                                                      String date = dateFormat.format(DateTime.now()).toString();
                                                      String followid = generateRandomString(15);
                                                       _firebaseFirestore?.collection('follower').doc(followid).set({



                                                   // 'Uid': currentuser,
                                                    'sellerId': doc['Uid'],
                                                    'follwid': followid,
                                                         'userImage': doc['userImage'],
                                                         'shopName': doc['ShopName'],
                                                         'location': doc['Location'],
                                                         'date': date,
                                                         'Fullname': doc['Fullname'],
                                                         'items':  doc['items'],
                                                         'followers': doc['followers'],
                                                         'DateJoined': doc['DateJoined'],
                                                         'Phonenumber': doc['Phonenumber'],
                                                         'AboutShop': doc['AboutShop'].toString(),



                                                    });
                                                      Fluttertoast.showToast(
                                                          msg: "Following User",  // message
                                                          toastLength: Toast.LENGTH_SHORT, // length
                                                          gravity: ToastGravity.CENTER,    // location
                                                          timeInSecForIosWeb: 1               // duration
                                                      );
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
                                                ),
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
                                        child: new


    StreamBuilder<QuerySnapshot>  (
    stream: FirebaseFirestore.instance
        .collection('products')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots(),
    builder: (context, snapshot) {

    if (snapshot.hasError) {
    return Text("Something went wrong");
    }
    if (!snapshot.hasData) {
    return CircularProgressIndicator();
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




                                    )
                                  ])
                          );

                        });}

                }
            ),


            const SizedBox(
              height: 5,
            ),
            Container(

              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  const Text(
                    "Related Products",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: textMedium),
                  ),
                  const SizedBox(
                      height: 20
                  ),
                  Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                      child: Container(

                        width: 410,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: new StreamBuilder<QuerySnapshot>  (
                              stream: FirebaseFirestore.instance
                                  .collection('products')
                                  .where('category', isEqualTo: category)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                else {
                                  return  ListView.builder(
                                  itemCount: snapshot.data!.docs.length,

                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot doc = snapshot.data!.docs[index];
                                    return
                                      GestureDetector(

                                      onTap: ()async{
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProductDetails(id: doc['productId'],)));
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
                                                  image: new NetworkImage(doc['imageUrl']),
                                                  height: 140,
                                                  width: 140,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Text('K'+ doc['price'] +'.00',
                                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),)
                                          ]
                                      ),
                                    );

                                  }
                                     );
                                }
                              }),
                      )


                  ),
                  SizedBox(
                      height: 10
                  ),
                ],
              ),
            ),

          ])])

          ])

          ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.white,
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [




                    StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                        if (snapshot.hasData) {
          return  StreamBuilder<QuerySnapshot>  (
              stream: FirebaseFirestore.instance
                  .collection('users').

              where('Uid', isEqualTo: sellerId)
                  .snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,

                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];

                      return

                        Row(
                          children: [
                            InkWell(
                                onTap: (){


                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => ChatDetail(

                                        friendName: doc['Fullname'],
                                        friendUid: doc['Uid'],
                                        friendImage: doc['userImage'],


                                      )));



                                },
                                child:
                                ItemNavWidget(
                                  icon: "assets/icons/chat.svg",
                                  label: "Message",
                                )

                            ),
                            const SizedBox(
                              width: 40,
                            ),
                          ],
                        );
                    }


                );
              });
        }
        return

          Row(
            children: [
              InkWell(
                  onTap: (){



                    SignInModal(context);

                    Fluttertoast.showToast(
                        msg: "Login First",  // message
                        toastLength: Toast.LENGTH_SHORT, // length
                        gravity: ToastGravity.CENTER,    // location
                        timeInSecForIosWeb: 1               // duration
                    );

                  },
                  child:
                  ItemNavWidget(
                    icon: "assets/icons/chat.svg",
                    label: "Message",
                  )

              ),
              const SizedBox(
                width: 40,
              ),
            ],
          );

  },
  ),

                    StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                        if (snapshot.hasData) {
                          return
    StreamBuilder<QuerySnapshot>  (
    stream: FirebaseFirestore.instance
        .collection('products').
    where('productId', isEqualTo: productId).
    where('sellerId', isEqualTo: sellerId)
        .snapshots(),
    builder: (context, snapshot) {
      return ListView.builder(
      itemCount: snapshot.data!.docs.length,

      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        DocumentSnapshot docc3 = snapshot.data!.docs[index];

        return
          InkWell(
            onTap: () { Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderView(  id: docc3['productId'],
                    )));
            },
            child: Container(
              height: 15,
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: PrimaryBlueOcean,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: const Text(
                  "Start Buying",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
      }


      );
    });

        }
        return
          InkWell(
            onTap: () {

              SignInModal(context);

              Fluttertoast.showToast(
                  msg: "Login First",  // message
                  toastLength: Toast.LENGTH_SHORT, // length
                  gravity: ToastGravity.CENTER,    // location
                  timeInSecForIosWeb: 1               // duration
              );
            },
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: PrimaryBlueOcean,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: const Text(
                  "Start Buying",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );


                        ///PhoneAuthPage();
  },
  ),

                  ],
                )),
          ]),

          );
        }
    );
  }
}
class ItemNavWidget extends StatelessWidget {
  String icon;
  String label;
  ItemNavWidget({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          icon,
          color: Colors.grey,
          height: 20,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        )
      ],
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
