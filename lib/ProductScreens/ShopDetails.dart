import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat2/ChatScreen/ChatDetail.dart';
import 'package:chat2/HomeScreens/Search.dart';
import 'package:chat2/ProductScreens/ProductDetails.dart';
import 'package:chat2/ProductScreens/add_review.dart';
import 'package:chat2/bloc/product/product_bloc.dart';
import 'package:chat2/bloc/review/review_bloc.dart';
import 'package:chat2/data/models/likes_model.dart';
import 'package:chat2/data/models/seller_model.dart';
import 'package:chat2/data/models/user_model.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ShopDetails extends StatefulWidget {
  ShopDetails({Key? key,


    this.Fullname,
    this.Uid,
    this.userImage,
    this.items,
    this.followers,
    this.DateJoined,
    this.Phonenumber,
    this.AboutShop,
    this.ShopName,
    this.ShopLocation,



  }) : super(key: key);

final Fullname;
final  Uid;
final userImage;
final items;
final followers;
final DateJoined;
final Phonenumber;
final AboutShop;
final ShopName;
final ShopLocation;


 // final currentuser = FirebaseAuth.instance.currentUser!.uid;
  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  final TextEditingController _reviewController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final FirebaseFirestore? _firebaseFirestore = FirebaseFirestore.instance;
  double _ratingValue = 0.0;
  final Repository repo = Repository();
  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  String _userId = "";
//final currentuser = FirebaseAuth.instance.currentUser!.uid;
  Future<void> addReview(String rating, String description) async {
    String reviewId = generateRandomString(15);
    await _firebaseFirestore?.collection('reviews').doc(reviewId).set({
      'description': description,
      'rating' : rating,
      'likes' : "0",
      'sellerid': widget.Uid,
     'buyerId': FirebaseAuth.instance.currentUser!.uid,
      'reviewId' : reviewId,
      'buyername': widget.Fullname,
      'buyerImage': widget.userImage,
      'createdAt': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
    });

    Fluttertoast.showToast(
        msg: "Review added successfully",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,    // location
        timeInSecForIosWeb: 1               // duration
    );
  }
  List<String> categories = [
    "Products",
    "About",
    "Categories",
    "Reviews",
  ];
  // By default our first item will be selected
  int selectedIndex = 0;
  final ProductBloc _productsBloc =
  ProductBloc(productRepository: Repository());
  final ReviewBloc _reviewBloc = ReviewBloc(reviewRepository: Repository());
  final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');


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

  void AddReviewModal(context){
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container(
height: MediaQuery.of(context).size.height* .50,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 300,
                padding: const EdgeInsets.only(
                  top: paddingHorizontal,
                  left: paddingHorizontal,
                  right: paddingHorizontal,
                ),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Write a review",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 60,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter a rating',
                                textAlign: TextAlign.left,
                              ),
                              RatingBar(
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                      full: const Icon(Icons.star, color: Colors.orange),
                                      half: const Icon(
                                        Icons.star_half,
                                        color: Colors.orange,
                                      ),
                                      empty: const Icon(
                                        Icons.star_outline,
                                        color: Colors.orange,
                                      )),
                                  onRatingUpdate: (value) {
                                    setState(() {
                                      _ratingValue = value;
                                    });
                                  }),
                            ]
                        )
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _reviewController,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'enter review comment',
                        ),
                        autofocus: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              addReview(_ratingValue.toString(), _reviewController.text.trim());
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Submit',
                            ),
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: PrimaryBlueOcean,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(
    title: Text(widget.ShopName, style: TextStyle(
        color:Colors.white
    ),),
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
    child:


    ListView(
    children: [
      SizedBox(height: 1,),
    Container(
    height: 250,

    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(0),
    image: DecorationImage(
    image: NetworkImage('https://pharem-project.eu/wp-content/themes/consultix/images/no-image-found-360x250.png'),
    fit: BoxFit.fill)),
    ),
    Container(

    padding: const EdgeInsets.all(paddingHorizontal),
    margin: const EdgeInsets.all(0),
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
    backgroundImage: NetworkImage(widget.userImage),
    ),
    const SizedBox(
    width: 20,
    ),

    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    widget.Fullname,
    style: const TextStyle(
    fontSize: textMedium, fontWeight: FontWeight.w700),
    ),
    const SizedBox(
    height: 5,
    ),
    Text(
    widget.Phonenumber,
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
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('sellerId',isEqualTo: widget.Uid )
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





      SizedBox(
        height: 35,
        width: 100,
        child: TextButton(
          onPressed: ()
          {
          //  followUser( widget.Uid );
            var dateFormat = DateFormat('MMM d, yyyy');
            String date = dateFormat.format(DateTime.now()).toString();
            String followid = generateRandomString(15);
            _firebaseFirestore?.collection('follower').doc(followid).set({


              'Uid': FirebaseAuth.instance.currentUser!.uid,
              'sellerId': widget.Uid,
              'follwid': followid,
              'userImage': widget.userImage,
              'shopName': widget.ShopName,
              'location': 'blantyre',
              'date': date,
              'Fullname': widget.Fullname,
              'items':  widget.items,
              'followers': widget.followers,
              'DateJoined': widget.DateJoined,
              'Phonenumber': widget.Phonenumber,
              'AboutShop': widget.AboutShop,



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

    ] ),
    Column(
    children: [
    const SizedBox(height: 10),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('follower')
            .where('sellerId',isEqualTo: widget.Uid )
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
    SizedBox(
    height: 35,
    width: 100,
    child: TextButton(
    onPressed: ()
    {

      Navigator.push(context, MaterialPageRoute(
          builder: (_) => ChatDetail(


            friendName: widget.Fullname,
            friendUid: widget.Uid,
            friendImage: widget.userImage,


          )));

    },
    child: const Text(
    'Message',
    ),
    style: TextButton.styleFrom(
    primary: Colors.white,
    alignment: Alignment.center,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)),
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
    widget.DateJoined,
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

    ] ),


    ]),
    ])

    ),

    Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Search()));
                }, icon: Icon(Icons.search)),
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
          StreamBuilder<QuerySnapshot>  (
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('status', isEqualTo:"live")
                  .where('sellerId', isEqualTo: widget.Uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                else {
                  return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: kDefaultPaddin,
                        crossAxisSpacing: kDefaultPaddin,
                        childAspectRatio: 0.6,
                      ),

                      itemBuilder: (context, index) {

                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return
                          Container(
                            margin: EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: ()async{
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(id: doc['productId'],)));
                              },
                              child:

                              Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget>[


                                  Expanded(
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            doc['imageUrl'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    // products is out demo list
                                    doc['name'].toString(),
                                    style: const TextStyle(
                                        fontSize: textMedium,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    // products is out demo list
                                    doc['description'].toString(),
                                    style: const TextStyle(fontSize: textMedium),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'K ${(doc['price']).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.00',
                                        style:
                                        const TextStyle(fontWeight: FontWeight.bold, color: priceColor),
                                      )
                                    ],
                                  ),

                                ],
                              ),

                            ),
                          );
                      }
                  );
                }
              })
              : selectedIndex == 2
              ?
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: paddingHorizontal),
            child: ListView(
              shrinkWrap: true,
              children:
              ListTile.divideTiles(context: context, tiles: [
                const ListTile(
                  title: Text(
                    'Dresses',
                    style: TextStyle(fontSize: textMedium),
                  ),
                ),
                const ListTile(
                  title: Text('Skirts',
                      style: TextStyle(fontSize: textMedium)),
                ),
                const ListTile(
                  title: Text('T-shirts',
                      style: TextStyle(fontSize: textMedium)),
                ),
                const ListTile(
                  title: Text('Track Pants',
                      style: TextStyle(fontSize: textMedium)),
                ),
                const ListTile(
                  title: Text('Trousers',
                      style: TextStyle(fontSize: textMedium)),
                ),
              ]).toList(),
            ),
          )
              : selectedIndex == 1
              ?
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: paddingHorizontal),
            child:
            Column(

              children: [
                Padding(padding: const EdgeInsets.symmetric(
                    horizontal: paddingHorizontal),
                  child: Text(widget.AboutShop.toString(),
                    style:TextStyle(fontFamily: 'DMsans', fontSize: 15, ) ,
                  ),
                ),

                SizedBox(height: 10,),


                SizedBox(height: 10,),
                Divider(height: 1,),
                Padding(padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [


                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('reviews')
                            .where('sellerid',isEqualTo: widget.Uid )
                            .snapshots(),
                        builder: (context, snapshot) {

                          return
                            Text( ' Reviews ' + '('+snapshot.data!.docs.length .toString()+')' ,
                                style: TextStyle(fontFamily: 'DMsans', fontSize: 20, fontWeight: FontWeight.bold),
                            );

                        },
                      ),

                      TextButton(
                        onPressed: ()
                        {

                        AddReviewModal(context);


                        },
                        child: const Text(
                          'Comment',
                        ),
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: PrimaryBlueOcean,
                            textStyle: const TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ],
                  ),
                ),
                Column(

                  children: [

                    StreamBuilder<QuerySnapshot>  (
                        stream: FirebaseFirestore.instance
                            .collection('reviews')
                            .where('sellerid',isEqualTo: widget.Uid )

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
                        child:
                        Column(
                            children: [

                              const SizedBox(
                                height: 25,
                              ),
                              Container(

                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Flexible(
                                            child:
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: NetworkImage(doc['buyerImage'])
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ), Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text( doc['buyername']  ,

                                                      style: const TextStyle(
                                                          fontSize:
                                                          textMedium,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),

                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end,
                                                      children: [


                                                        Text(
                                                          doc ['likes']+" people found this review useful",
                                                          style: const TextStyle(
                                                              fontSize: textMedium),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .end,
                                            children: [
                                              Text(
                                                doc['createdAt'],
                                                style: const TextStyle(

                                                    fontSize:
                                                    textSmall),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        doc['description'],
                                        style: const TextStyle(
                                          fontSize: textMedium,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .end,
                                        children: [
                                          Text(
                                            'Helpful',
                                            style: const TextStyle(
                                                color:
                                                iconBlueDark,
                                                fontSize:
                                                textSmall),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          InkWell(
                                            onTap:  () async {

                                            },
                                            child: SvgPicture.asset(
                                              "assets/icons/thumbs-up.svg",
                                              color: iconBlueDark,
                                              height: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(height: 1),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                    ],

                                  )

                              ),
                            ])
                    );

  }



  );
}})


                  ],

                ),
                Container(
                  height: 45,
                  padding: const EdgeInsets.all(5),

                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      color: Color(0xff000000),
                      width: 1,
                    ),

                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('See All Review', style: TextStyle(
                      color:Colors.black,
                      fontFamily: 'DMsans', fontSize: 20,
                    ),),
                  ),
                ),
                SizedBox(height: 20,),

              ],

            ),
          ):
          selectedIndex == 3 ?

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: paddingHorizontal),
            child:
            Column(

              children: [
                StreamBuilder<QuerySnapshot>  (
                    stream: FirebaseFirestore.instance
                        .collection('reviews')
                        .where('sellerid',isEqualTo: widget.Uid )

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
                                    child:
                                    Column(
                                        children: [

                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Container(

                                              child:
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child:
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage: NetworkImage(doc['buyerImage'])
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ), Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text( doc['buyername']  ,

                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                      textMedium,
                                                                      fontWeight:
                                                                      FontWeight.w600),
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [


                                                                    Text(
                                                                      doc ['likes']+" people found this review useful",
                                                                      style: const TextStyle(
                                                                          fontSize: textMedium),
                                                                    ),
                                                                  ],
                                                                ),

                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .end,
                                                        children: [
                                                          Text(
                                                            doc['createdAt'],
                                                            style: const TextStyle(

                                                                fontSize:
                                                                textSmall),
                                                          ),

                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    doc['description'],
                                                    style: const TextStyle(
                                                      fontSize: textMedium,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .end,
                                                    children: [
                                                      Text(
                                                        'Helpful',
                                                        style: const TextStyle(
                                                            color:
                                                            iconBlueDark,
                                                            fontSize:
                                                            textSmall),
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      InkWell(
                                                        onTap:  () async {

                                                        },
                                                        child: SvgPicture.asset(
                                                          "assets/icons/thumbs-up.svg",
                                                          color: iconBlueDark,
                                                          height: 15,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Divider(height: 1),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                ],

                                              )

                                          ),
                                        ])
                                );

                            }



                        );
                      }})
              ],

            ),
          )
              : SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                50,

          ),
        ],
      ),
    ),



    ])

    )


    ])

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
