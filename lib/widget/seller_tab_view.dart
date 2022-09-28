/*
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopped/bloc/blocs.dart';
import 'package:shopped/data/models/models.dart';
import 'package:shopped/data/repository/repository.dart';
import 'package:shopped/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:shopped/views/search_in_shop_view.dart';
import 'package:shopped/views/search_view.dart';
import 'package:shopped/widget/item_card.dart';
import 'package:collection/collection.dart';

import '../data/models/likes_model.dart';
import '../views/add_review.dart';

// We need satefull widget for our categories

class SellerTabs extends StatefulWidget {
  const SellerTabs({Key? key}) : super(key: key);

  @override
  _SellerTabsState createState() => _SellerTabsState();
}

class _SellerTabsState extends State<SellerTabs> {
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
  final Repository repo = Repository();
  String _userId = "";
  String _userRole = "";
  List<Customer> _users = [];
  List<Seller> _sellers = [];
  List<Likes> _likes = [];
  final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('userRole');
    String userId = '';
    if(userRole != null){
      if(userRole.contains("seller")){
        Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('phoneNumber'));
        userId = logSeller!.id;
      }
      else {
        Customer? logCustomer = await repo.findBuyerByPhoneNumber(prefs.getString('phoneNumber'));
        userId = logCustomer!.id;
      }

      List<Customer> tempList = await repo.getAllUsers();
      List<Seller> tempList2 = await repo.getSellers();
      List<Likes> tempList3 = await repo.getAllLikes();
      debugPrint(userId);
      setState(() {
        _userId = userId;
        _userRole = userRole;
        _users = tempList;
        _sellers = tempList2;
        _likes = tempList3;
      });
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
   // _productsBloc.add(LoadSellerProducts(sellerId: widget.seller.id));
   // _reviewBloc.add(LoadReviews(objectId: widget.seller.id, reviewType: "seller"));

  }

  @override


  Widget tileWidget(
      BuildContext context, String image, String title, String price) {
    return GestureDetector(
      onTap: ()async{
        
      },
      child: Container(

        width: MediaQuery.of(context).size.width / 2.3,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xfff2f2f2),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.favorite_border_outlined, size: 20, color: Colors.grey,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 1,
              bottom:20,
              child: Container(
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                    '  10'

                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        image,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),

                Container(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        price,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchView()));
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
          Container(


                     child: Column(

                       children: [

                         Row(
                           children: [
                             tileWidget(
                               context,
                               'assets/house2.jpg',
                               'James',
                               '\Mwk 5.00',
                             ),
                             tileWidget(
                               context,
                               'assets/house.jpg',
                               'Fanuel',
                               '\Mwk 5.00',
                             ),
                           ],
                         ),
                         Row(
                           children: [
                             tileWidget(
                               context,
                               'assets/12.jpg',
                               'James',
                               '\Mwk 5.00',
                             ),
                             tileWidget(
                               context,
                               'assets/1.jpg',
                               'Fanuel',
                               '\Mwk 5.00',
                             ),
                           ],
                         ),

                                                  Row(
                           children: [
                             tileWidget(
                               context,
                               'assets/madrid.jpg',
                               'James',
                               '\Mwk 5.00',
                             ),
                             tileWidget(
                               context,
                               'assets/psg.jpg',
                               'Fanuel',
                               '\Mwk 5.00',
                             ),
                           ],
                         ),
                       ],
                       

                     ),

          )
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
                              child: Text('The speaker unit contains a diaphragm that is'
                                  'precision-grown from NAC Audio bio-cellulose,'
                                  'making it stiffer, lighter and stronger than'
                                  'regular PET speaker units, and allowing the'
                                 ' sound-producing diaphragm to vibrate without'
                                  'the levels of distortion found in other speakers.',
                                style:TextStyle(fontFamily: 'DMsans', fontSize: 15, ) ,
                                  ),
                              ),

                              SizedBox(height: 10,),

                              Padding(padding: const EdgeInsets.symmetric(
                                  horizontal: paddingHorizontal),
                                child: Text('The speaker unit contains a diaphragm that is'
                                    'precision-grown from NAC Audio bio-cellulose,'
                                    'making it stiffer, lighter and stronger than'
                                    'regular PET speaker units, and allowing the'
                                    ' sound-producing diaphragm to vibrate without'
                                    'the levels of distortion found in other speakers.',
                                  style:TextStyle(fontFamily: 'DMsans', fontSize: 15, ) ,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Divider(height: 1,),
                              Padding(padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text('Reviews (86)', style: TextStyle(fontFamily: 'DMsans', fontSize: 20, fontWeight: FontWeight.bold),),
                                    TextButton(
                                      onPressed: ()
                                      {

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
                                                                  backgroundImage: AssetImage("assets/profile2.jpg")
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
                                                                  Text('Prescilla Assani',
                                                                    */
/*(_users.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                      (_users.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName
                                                                          : ((_sellers.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                            (_sellers.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName : ""),*//*

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
                                                                        "535 people found this review useful",
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
                                                              '1 Month Ago',
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
                                                      'The perfect size to grill up a couple of burgers for everyone in the family, for placing serving trays',
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
                                                            */
/*Likes? thisLike = await repo.findLike(_userId, review.id);
                                                                  if(thisLike != null){
                                                                    //already liked
                                                                    repo.unLike(thisLike.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Unliked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  } else {
                                                                    String id = generateRandomString(15);
                                                                    repo.addLike(id, _userId, review.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Liked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  }*//*

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
                                  ),
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
                                                                  backgroundImage: AssetImage("assets/profile2.jpg")
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
                                                                  Text('Prescilla Assani',
                                                                    */
/*(_users.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                      (_users.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName
                                                                          : ((_sellers.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                            (_sellers.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName : ""),*//*

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
                                                                        "535 people found this review useful",
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
                                                              '1 Month Ago',
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
                                                      'The perfect size to grill up a couple of burgers for everyone in the family, for placing serving trays',
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
                                                            */
/*Likes? thisLike = await repo.findLike(_userId, review.id);
                                                                  if(thisLike != null){
                                                                    //already liked
                                                                    repo.unLike(thisLike.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Unliked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  } else {
                                                                    String id = generateRandomString(15);
                                                                    repo.addLike(id, _userId, review.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Liked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  }*//*

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






                                  ),
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
                                                                  backgroundImage: AssetImage("assets/profile2.jpg")
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
                                                                  Text('Prescilla Assani',
                                                                    */
/*(_users.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                      (_users.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName
                                                                          : ((_sellers.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                            (_sellers.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName : ""),*//*

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
                                                                        "535 people found this review useful",
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
                                                              '1 Month Ago',
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
                                                      'The perfect size to grill up a couple of burgers for everyone in the family, for placing serving trays',
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
                                                            */
/*Likes? thisLike = await repo.findLike(_userId, review.id);
                                                                  if(thisLike != null){
                                                                    //already liked
                                                                    repo.unLike(thisLike.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Unliked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  } else {
                                                                    String id = generateRandomString(15);
                                                                    repo.addLike(id, _userId, review.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Liked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  }*//*

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






                                  ),
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
                                                                  backgroundImage: AssetImage("assets/profile2.jpg")
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
                                                                  Text('Prescilla Assani',
                                                                    */
/*(_users.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                      (_users.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName
                                                                          : ((_sellers.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                            (_sellers.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName : ""),*//*

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
                                                                        "535 people found this review useful",
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
                                                              '1 Month Ago',
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
                                                      'The perfect size to grill up a couple of burgers for everyone in the family, for placing serving trays',
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
                                                            */
/*Likes? thisLike = await repo.findLike(_userId, review.id);
                                                                  if(thisLike != null){
                                                                    //already liked
                                                                    repo.unLike(thisLike.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Unliked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  } else {
                                                                    String id = generateRandomString(15);
                                                                    repo.addLike(id, _userId, review.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Liked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  }*//*

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






                                  ),
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
                                                    backgroundImage: AssetImage("assets/profile2.jpg")
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
                                                    Text('Prescilla Assani',
                                                      */
/*(_users.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                      (_users.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName
                                                                          : ((_sellers.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                            (_sellers.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName : ""),*//*

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
                                                          "535 people found this review useful",
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
                                                '1 Month Ago',
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
                                        'The perfect size to grill up a couple of burgers for everyone in the family, for placing serving trays',
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
                                              */
/*Likes? thisLike = await repo.findLike(_userId, review.id);
                                                                  if(thisLike != null){
                                                                    //already liked
                                                                    repo.unLike(thisLike.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Unliked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  } else {
                                                                    String id = generateRandomString(15);
                                                                    repo.addLike(id, _userId, review.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Liked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  }*//*

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
                    ),
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
                                                    backgroundImage: AssetImage("assets/profile2.jpg")
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
                                                    Text('Prescilla Assani',
                                                      */
/*(_users.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                      (_users.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName
                                                                          : ((_sellers.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                            (_sellers.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName : ""),*//*

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
                                                          "535 people found this review useful",
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
                                                '1 Month Ago',
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
                                        'The perfect size to grill up a couple of burgers for everyone in the family, for placing serving trays',
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
                                              */
/*Likes? thisLike = await repo.findLike(_userId, review.id);
                                                                  if(thisLike != null){
                                                                    //already liked
                                                                    repo.unLike(thisLike.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Unliked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  } else {
                                                                    String id = generateRandomString(15);
                                                                    repo.addLike(id, _userId, review.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Liked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  }*//*

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






                    ),
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
                                                    backgroundImage: AssetImage("assets/profile2.jpg")
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
                                                    Text('Prescilla Assani',
                                                      */
/*(_users.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                      (_users.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName
                                                                          : ((_sellers.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                            (_sellers.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName : ""),*//*

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
                                                          "535 people found this review useful",
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
                                                '1 Month Ago',
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
                                        'The perfect size to grill up a couple of burgers for everyone in the family, for placing serving trays',
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
                                              */
/*Likes? thisLike = await repo.findLike(_userId, review.id);
                                                                  if(thisLike != null){
                                                                    //already liked
                                                                    repo.unLike(thisLike.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Unliked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  } else {
                                                                    String id = generateRandomString(15);
                                                                    repo.addLike(id, _userId, review.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Liked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  }*//*

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






                    ),
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
                                                    backgroundImage: AssetImage("assets/profile2.jpg")
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
                                                    Text('Prescilla Assani',
                                                      */
/*(_users.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                      (_users.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName
                                                                          : ((_sellers.firstWhereOrNull((element) => element.id == review.buyerId)) != null ?
                                                                            (_sellers.firstWhereOrNull((element) => element.id == review.buyerId))!.fullName : ""),*//*

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
                                                          "535 people found this review useful",
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
                                                '1 Month Ago',
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
                                        'The perfect size to grill up a couple of burgers for everyone in the family, for placing serving trays',
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
                                              */
/*Likes? thisLike = await repo.findLike(_userId, review.id);
                                                                  if(thisLike != null){
                                                                    //already liked
                                                                    repo.unLike(thisLike.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Unliked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  } else {
                                                                    String id = generateRandomString(15);
                                                                    repo.addLike(id, _userId, review.id);
                                                                    getSharedPrefs();
                                                                    Fluttertoast.showToast(
                                                                        msg: "Liked!",  // message
                                                                        toastLength: Toast.LENGTH_SHORT, // length
                                                                        gravity: ToastGravity.CENTER,    // location
                                                                        timeInSecForIosWeb: 1               // duration
                                                                    );
                                                                  }*//*

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






                    ),
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
    );
  }

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
}
*/


