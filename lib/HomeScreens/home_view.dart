import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat2/HomeScreens/CategoriyView.dart';
import 'package:chat2/HomeScreens/Search.dart';
import 'package:chat2/HomeScreens/search_screen.dart';
import 'package:chat2/ProductScreens/ProductDetails.dart';
import 'package:chat2/bottom_nav.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUID() async{
    return (_auth.currentUser)!.uid;
  }

  bool _isloading = false;

  void _validate(String productid,  String image, String name, String price, String description){
    var dateformat = DateFormat('MMM d, yyyy');
    String date = dateformat.format(DateTime.now()).toString();
    DocumentReference ref =  FirebaseFirestore.instance.collection('history').doc();
    Map<String, dynamic> data ={



      'productid': productid,
      'Date Ordered': date,
      'Uid': FirebaseAuth.instance.currentUser?.uid,
      'price': price,
      'name': name,
      'image': image,
      'Hid': ref,

    };
    ref.set(data).then((value) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return ProductDetails(
          id: productid,

        );
      }));
    }
    );

  }
  void navigateToSearchScreen(String query) {

    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
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
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>BottomNav()));
                      },
                      child: Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: AssetImage('assets/icons/small_logo.png'),
                                fit: BoxFit.fill)
                        ),
                      ),
                    ),


                    SizedBox(width: 10,),
                    Expanded(
                      child: GestureDetector(


                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            onFieldSubmitted: navigateToSearchScreen,
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
                                    /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>Search()));*/
                                  },
                                ),
                              ),


                            ),
                          ),
                        ),
                      ),),

                 /*   GestureDetector(
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

      body: ListView(
          children: [
            const SizedBox(height: 7),
            SizedBox(
                height: 40,
                child:
                Row(
                    children:[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child:
                        InkWell(
                          onTap: () {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const CategoriyView()));
                          },
                          child: Column(
                            children: [
                              SvgPicture.network(
                                "https://www.svgrepo.com/show/202035/menu.svg",
                                color: iconBlueDark,
                                height: 23.5,

                                // By default our  icon color is white
                              ),
                              const SizedBox(height: 0.5),
                              const Text("All",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: textSmall,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child:
                        InkWell(
                          onTap: () {


                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const CategoriyView()));

                          },
                          child: Column(
                            children: [
                              SvgPicture.network(
                                "https://www.svgrepo.com/show/418836/computer-device-electronics.svg",
                                color: iconBlueDark,
                                height: 23.5,

                                // By default our  icon color is white
                              ),
                              const SizedBox(height: 0.5),
                              const Text("Electronics",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: textSmall,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child:
                        InkWell(
                          onTap: () {

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const CategoriyView()));
                          },
                          child: Column(
                            children: [
                              SvgPicture.network(
                                "https://www.svgrepo.com/show/251733/furniture-bed.svg",
                                color: iconBlueDark,
                                height: 23.5,

                                // By default our  icon color is white
                              ),
                              const SizedBox(height: 0.5),
                              const Text("Furniture",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: textSmall,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child:
                        InkWell(
                          onTap: () {

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const CategoriyView()));
                          },
                          child: Column(
                            children: [
                              SvgPicture.network(
                                "https://www.svgrepo.com/show/260897/polo-fashion.svg",
                                color: iconBlueDark,
                                height: 23.5,

                                // By default our  icon color is white
                              ),
                              const SizedBox(height: 0.5),
                              const Text("Fashion",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: textSmall,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Padding(

                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child:
                        InkWell(
                          onTap: () {

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const CategoriyView()));
                          },
                          child: Column(
                            children: [
                              SvgPicture.network(
                                "https://www.svgrepo.com/show/7857/baby-stroller.svg",
                                color: iconBlueDark,
                                height: 23.5,

                                // By default our  icon color is white
                              ),
                              const SizedBox(height: 0.5),
                              const Text("Baby",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: textSmall,
                                  ))
                            ],
                          ),
                        ),
                      ),


                    ]
                )
            ),
            const SizedBox(height: 7),

            CarouselSlider(
              items: [
                Container(
                  width: 400,
                  height: 400,
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage("https://img.freepik.com/free-vector/holiday-shopping-banner-with-realistic-paper-bags-gifts-vector-illustration_548887-112.jpg?w=2000"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 400,
                  height: 400,
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage("https://img.freepik.com/premium-vector/isometric-illustration-concept-online-shopping-buy-goods-smartphone_18660-2331.jpg?w=2000"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),Container(
                  width: 400,
                  height: 400,
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage("https://img.freepik.com/free-psd/online-shopping-store-concept-mobile-phone-with-3d-shopping-cart-shopping-bag-gift-boxes_106244-2050.jpg?w=2000"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),Container(
                  width: 400,
                  height: 400,
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage("https://img.freepik.com/premium-vector/shopping-banner-with-location-store-cart-gifts-market-bags-realistic-style-vector-illustration_548887-121.jpg?w=1060"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),Container(
                  width: 400,
                  height: 400,
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage("https://img.freepik.com/premium-vector/online-shopping-concept-digital-marketing-website-mobile-application_43880-332.jpg?w=2000"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),Container(
                  width: 400,
                  height: 400,
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage("https://img.freepik.com/premium-photo/3d-render-mobile-loading-icon-shopping-online-ecommerce-web-business-concept_387680-1278.jpg?w=2000"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),


              ],

              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                pageSnapping: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 1,
              ),
            ),


            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Text("Featured",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: SecondaryDarkGrey)),
            ),

            const SizedBox(
              height: 10,
            ),

            StreamBuilder<QuerySnapshot>  (
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('status', isEqualTo:"live")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (!snapshot.hasData) {
                    return
                      Center(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                      ;
                  }
                  else {
                    return
                      GridView.builder(
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

                            var productid = doc['productId'];
                            var image = doc['imageUrl'];
                            var name = doc['name'];
                            var price  = doc['price'];
                            var description = doc['description'];

                            return
                              Container(
                                margin: EdgeInsets.all(10),
                                child: GestureDetector(
                                onTap: ()async{
                                  _validate(productid, image, name, price, description );
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
                            doc['description'],
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
                                        /*Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 0,
                                                bottom: 35,

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
                                                right: 10,
                                                bottom:30,

                                                child: Container(
                                                  decoration: BoxDecoration(

                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Text(
                                                      '10'),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Container(
                                                    height: 180,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          doc['imageUrl'],
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 3,
                                                        ),

                                                        Text(
                                                          doc['name'],
                                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                                          child: Text(
                                                            doc['description'],
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Theme.of(context).textTheme.headline3!.copyWith(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text("K"+ (doc['price']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+'.00',
                                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                                            color: Colors.red,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],


                                              ),



                                            ],
                                          ),
                                        ),*/
                                      ],
                                    ),

                            ),
                              );

                          }
                      );
                  }
                }),




          ]),

    );
  }
}
