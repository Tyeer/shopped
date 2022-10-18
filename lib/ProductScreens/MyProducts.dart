import 'package:chat2/ProductScreens/EditProduct.dart';
import 'package:chat2/ProductScreens/add_product_view.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  var currentuser = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference products = FirebaseFirestore.instance.collection('products');

  Future <void> putofflineproducts(id){
    return  products.doc(id).update({

      'status': 'offline',

    }).then((value) =>
        print(
            'Product is Offline'
        ))
        .catchError((error)=>
        print(
            '$error'
        ));

  }

  Future <void> putliveproducts(id){
    return  products.doc(id).update({

      'status': 'live',

    }).then((value) =>
        print(
            'Product is Offline'
        ))
        .catchError((error)=>
        print(
            '$error'
        ));

  }

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
  String? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,

        title: const Center(child: Text('Products'),),


      ),
    body: Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where('sellerId',isEqualTo: currentuser )
                .snapshots(),
            builder: (context, snapshot) {

                return
                  Text(
                    snapshot.data!.docs.length .toString() + ' Items',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,),
                  );

            },
          ),

          SizedBox(width: 200,),
          OutlinedButton.icon(

            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddProductView()));
            },
            icon: Icon(
              Icons.add,
              size: 10.0,
              color: Colors.blue,
            ),
            label: Text('add products'
                , style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,

                )),
          ),

        ],
      ),
      Expanded(
        child:
    StreamBuilder<QuerySnapshot>  (
    stream: FirebaseFirestore.instance
        .collection('products')
    .where('sellerId', isEqualTo: currentuser)

        .snapshots(),
    builder: (context, snapshot) {
    if (snapshot.hasError) {
    return Text("Something went wrong");
    }
    if (!snapshot.hasData) {
    return Center(child: CircularProgressIndicator());
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
        child: Column(
          children: [

            Card(

                child:

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [

                      Radio(
                          value: "radio value",
                          groupValue: "group value",
                          onChanged: (value) {
                            print(value); //selected value
                          }
                      ),


                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        doc['imageUrl'] ),
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
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [
                                      Text(
                                        doc['name'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: textMedium,
                                            fontWeight: FontWeight.bold),
                                      ),

                                      const SizedBox(width: 80,),
                                      IconButton(
                                        alignment: Alignment.topRight,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProduct(
                                                        id: doc['productId'],
                                                      )));
                                        },
                                        icon: SvgPicture.network(
                                          "https://www.svgrepo.com/show/56967/edit.svg",

                                          height: 15,
                                          color: Colors.blue,
                                        ),)

                                    ],),

                                  Text(
                                    doc['dateAdded'],
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: textMedium,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      Text(
                                        "K"+ (doc['price']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+'.00',
                                        style: const TextStyle(
                                            color: priceColor,
                                            fontSize: textMedium,
                                            fontWeight: FontWeight.bold),
                                      ),

                                      const SizedBox(width: 80,),
                                      Text(
                                        "x" + doc['quantity'] ,
                                        style: const TextStyle(
                                            fontSize: textMedium,
                                            fontWeight: FontWeight.bold),
                                      ),

                                    ],),


                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text('Status:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,

                                ),),
                              Text(doc['status'] ,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,

                                ),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [


                              Container(
                                height: 25,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,

                                    side: BorderSide(
                                      color: Color(0xFFff0000),), //<-- SEE HERE
                                  ),
                                    onPressed: ()=>{
                                      deleteproducts(doc['productId'])
                                    },
                                  child: Text(
                                    'Delete', style: TextStyle(fontSize: 10,
                                    color: Color(0xFFff0000),),),
                                ),
                              ),
                              SizedBox(width: 45,),
                              Container(
                                height: 25,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,

                                    side: BorderSide(
                                      color: Color(0xffffcc00),), //<-- SEE HERE
                                  ),
                                  onPressed: ()=>{
                                    putofflineproducts(doc['productId'])
                                  },
                                  child: Text('Put Offline',
                                    style: TextStyle(fontSize: 10,
                                      color: Color(0xffffcc00),),),
                                ),
                              ),
                              SizedBox(width: 45,),
                              Container(
                                height: 25,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,

                                    side: BorderSide(
                                      color: Color(0xFF009933),), //<-- SEE HERE
                                  ),
                                  onPressed: ()=>{
                                    putliveproducts(doc['productId'])
                                  },
                                  child: Text(
                                    'Publish', style: TextStyle(fontSize: 10,
                                    color: Color(0xFF009933),),),
                                ),
                              ),


                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                )
            ),
          ],
        ),
      );

    }



    );
    }})


      ),

      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.white,

          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.center,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),

                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFff0000),
                          Color(0xFFff0000),
                          Color(0xFFff0000),
                        ])

                ),

                  child: Text('Delete',

                    style: TextStyle(color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Quicksand',
                    ),
                  ),

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
                          Color(0xFFffcc00),
                          Color(0xFFffcc00),
                          Color(0xFFffcc00),
                        ])

                ),

                child: Text('Put Offline',

                  style: TextStyle(color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                  ),
                ),

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
                          Color(0xFF009933),
                          Color(0xFF009933),
                          Color(0xFF009933),
                        ])

                ),

                child: Text('Publish',

                  style: TextStyle(color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                  ),
                ),

              ),



            ],
          ))

    ],
    )
    );
  }
}
