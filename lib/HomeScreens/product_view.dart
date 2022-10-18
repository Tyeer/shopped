import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat2/HomeScreens/Search.dart';
import 'package:chat2/ProductScreens/ProductDetails.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUID() async{
    return (_auth.currentUser)!.uid;
  }

  bool _isloading = false;
  void  _validate(String productid,  String image, String name, String price, String description){

    FirebaseFirestore.instance.collection('history').add({
      'productid': productid,
      'Date Ordered': DateFormat('MMM d, yyyy').format(DateTime.now()),
      'Uid': FirebaseAuth.instance.currentUser?.uid,
      'price': price,
      'name': name,
      'image': image,
      "desription": description,


    }).whenComplete(() {
      setState((){
        _isloading = false;
      });






      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetails(




                id: productid,

              )));
    }).catchError((error){
      Fluttertoast.showToast(msg: error.toString(),);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBgColor,
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          elevation: 0,

          title: GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>Search()));
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 2, 2, 2),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: TextField(
                  onChanged: (value) {
                    /*setState(() {
                      _searchString = value.toLowerCase();
                    });*/
                  },
                  decoration: InputDecoration(
                      suffixIcon: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(120)),
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
                      hintText: 'What are you looking for?',
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
        ),
      body: ListView(
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
      ])


    );
  }
}
