import 'package:chat2/bottom_nav.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/widget/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
 class ConfirmOrder extends StatefulWidget {
   const ConfirmOrder({Key? key, required this.id, required this.seller}) : super(key: key);
   final String? id;
   final String? seller;
   @override
   State<ConfirmOrder> createState() => _ConfirmOrderState();
 }

 class _ConfirmOrderState extends State<ConfirmOrder> {
   var currentuser = FirebaseAuth.instance.currentUser!.uid;
   var total2 ;
   var sumTotal2 ;
   @override
   Widget build(BuildContext context) {


     return

     Scaffold(

     /*appBar: AppBar(
     centerTitle: true,
     title: const Text(
     "Order Confirmation",
     ),
     flexibleSpace: Container(
     decoration: const BoxDecoration(
     gradient: LinearGradient(
     begin: Alignment.centerLeft,
     end: Alignment.centerRight,
     colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
     ),
     )
     ),*/

       appBar: AppBar(
         title: appBar(context),

         leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,size: 18,), onPressed: () {

           Navigator.pushReplacement(context, MaterialPageRoute(

               builder: (context)=>

                   BottomNav()
           ),

           );
         },),
         flexibleSpace: Container(
           decoration: const BoxDecoration(
             gradient: LinearGradient(
                 begin: Alignment.centerLeft,
                 end: Alignment.centerRight,
                 colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
           ),
         ),


         backgroundColor: Colors.transparent,
         elevation: 0.0,
         brightness: Brightness.light,

       ),

     body: Container(

     child:
     Column(
     children: [


     Expanded(
     child:

     StreamBuilder<QuerySnapshot>  (
     stream: FirebaseFirestore.instance
         .collection('orders')
         .where('Oid', isEqualTo:widget.id)
         .limit(1)
         .snapshots(),
     builder: (context, snapshot) {
     if (snapshot.hasError) {
     return Text("Something went w rong");
     }
     if (!snapshot.hasData) {
     return Center(
       child:CircularProgressIndicator(),
     );
     }
     else {


     return



     ListView.builder(
     shrinkWrap: true,
     physics: ClampingScrollPhysics(),
     itemCount: snapshot.data!.docs.length,
     scrollDirection: Axis.vertical,
     itemBuilder: (context, index) {
     DocumentSnapshot doc = snapshot.data!.docs[index];

     sumTotal2 = int.tryParse(doc['totalAmount']);
     total2 = sumTotal2 + sumTotal2;

     return
     Container(
       child: Column(
         children: [


           Container(
             margin: const EdgeInsets.symmetric(vertical: 5),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(5),
               color: Colors.white,
             ),
             child: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     children: [
                       Container(
                         decoration: const BoxDecoration(
                           shape: BoxShape.circle,
                           color: sucessColor,
                         ),
                         child: const Padding(
                           padding: EdgeInsets.all(10),
                           child: Icon(
                             Icons.check,
                             color: Colors.white,
                             size: 30,
                           ),
                         ),
                       ),
                       const SizedBox(
                         width: 20,
                       ),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: const [
                           Text("Thank you!",
                               style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontSize: textMedium)),
                           Text("Your order has been placed",
                               style: TextStyle(fontSize: textMedium))
                         ],
                       )
                     ],
                   ),
                   const SizedBox(height: 20),
                   const Text(
                       "Keep in contact with the seller to ensure delivery",
                       style: TextStyle(fontSize: textMedium)),
                   const SizedBox(height: 20),
                   Text(
                     "Time placed:" +doc['Date Ordered'],
                     style:
                     const TextStyle(fontWeight: FontWeight.w400,
                         fontSize: textMedium),
                   ),
                   const SizedBox(height: 40),
                   const Text(
                     "Order ID",
                     style:
                     TextStyle(fontSize: textMedium,
                         fontWeight: FontWeight.bold),
                   ),
                   const SizedBox(
                     height: 10,
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 5),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Flexible(
                           child:
                           Text(
                             doc['orderNo'],
                             style: const TextStyle(
                                 fontSize: textMedium,
                                 fontWeight: FontWeight.w600),
                           ),
                         ),

                         Row(
                           children: [
                             SvgPicture.asset(
                               "assets/icons/copy.svg",
                               height: 18,
                             ),
                             const SizedBox(
                               width: 10,
                             ),
                             const Text(
                               "Copy",
                               style: TextStyle(
                                   color: PrimaryBlueOcean,
                                   fontSize: textMedium),
                             ),
                           ],
                         )
                       ],
                     ),
                   ),
                   const SizedBox(
                     height: 20,
                   ),
                   const Text(
                     "Payment",
                     style:
                     TextStyle(fontSize: textMedium,
                         fontWeight: FontWeight.bold),
                   ),
                   Container(
                     width: 100,
                     height: 100,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5),
                       image: DecorationImage(
                         image: NetworkImage(
                           doc['Proof'],
                         ),
                         fit: BoxFit.cover,
                       ),
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.only(left: 10, top: 10),
                     child: Text(
                       "Paid through  " + doc['paymentMethods'],
                       style: const TextStyle(
                         fontSize: textMedium,
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
           Container(
             margin: const EdgeInsets.only(bottom: 5),
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(5),
               color: Colors.white,
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: const [
                     Text(
                       "Address",
                       style: TextStyle(
                           fontSize: textMedium, fontWeight: FontWeight.bold),
                     ),
                   ],
                 ),
                 const SizedBox(
                   height: 10,
                 ),



                 StreamBuilder<QuerySnapshot>  (
                     stream: FirebaseFirestore.instance
                         .collection('addresses').
                     where('userId', isEqualTo: currentuser)

                         .snapshots(),
                     builder: (context, snapshot) {

                       if (snapshot.hasError) {
                         return Center(child: Text("Something went wrong"));
                       }
                       else if (!snapshot.hasData) {
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
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [




                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(
                                             doc['name'],
                                             style: const TextStyle(
                                                 fontSize: textMedium,
                                                 fontWeight: FontWeight.w400),
                                           ),
                                           Text(
                                             doc['phone'],
                                             style: const TextStyle(
                                                 fontSize: textMedium,
                                                 fontWeight: FontWeight.w400),
                                           ),
                                           Text(
                                             doc['address'],
                                             style: const TextStyle(
                                                 fontSize: textMedium,
                                                 fontWeight: FontWeight.w400),
                                           ),
                                           Text(
                                             doc['city'],
                                             style: const TextStyle(
                                                 fontSize: textMedium,
                                                 fontWeight: FontWeight.w400),
                                           ),
                                         ],
                                       ),

                                       IconButton(
                                         onPressed: () =>{ },
                                         icon: SvgPicture.asset(
                                           "assets/icons/right.svg",
                                           color: PrimaryBlueOcean,
                                           height: 25,
                                         ),
                                       ),
                                     ],
                                   ),
                                 )

                               ;

                             });}

                     }
                 ),



               ],
             ),
           ),
           Container(
             margin: const EdgeInsets.only(bottom: 5),
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(5),
               color: Colors.white,
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment:
                   MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     StreamBuilder<QuerySnapshot>  (
                         stream: FirebaseFirestore.instance
                             .collection('users').
                         where('Uid', isEqualTo: widget.seller)

                             .snapshots(),
                         builder: (context, snapshot) {

                           if (snapshot.hasError) {
                             return Center(child: Text("Something went wrong"));
                           }
                           else if (!snapshot.hasData) {
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

                     Row(
                       children: [
                         CircleAvatar(
                           radius: 15,
                           backgroundImage: NetworkImage(
                               doc['userImage']),
                         ),
                         const SizedBox(
                           width: 10,
                         ),
                         Text(
                           doc['Fullname'],
                           style: const TextStyle(
                               fontSize: textMedium,
                               fontWeight: FontWeight.bold),
                         ),
                       ],
                     );
     });}

     }
     ),


                   ],
                 ),
                 const SizedBox(
                   height: 20,
                 ),
                 Row(
                   mainAxisAlignment:
                   MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     Row(
                       crossAxisAlignment:
                       CrossAxisAlignment.start,
                       children: [
                         Container(
                           width: 100,
                           height: 100,
                           decoration: BoxDecoration(
                             borderRadius:
                             BorderRadius.circular(5),
                             image: DecorationImage(
                               image: NetworkImage(
                                   doc['imageUrl']
                               ),
                               fit: BoxFit.fill,
                             ),
                           ),
                         ),
                         const SizedBox(
                           width: 15,
                         ),
                         Column(
                           crossAxisAlignment:
                           CrossAxisAlignment.start,
                           children: [
                             Text(
                               doc['productName'],
                               style: const TextStyle(
                                   fontSize: textMedium,
                                   fontWeight: FontWeight.bold),
                             ),
                             const SizedBox(
                               height: 5,
                             ),
                             Text(
                               doc['price'].toString(),
                               style: const TextStyle(
                                   color: priceColor,
                                   fontSize: textMedium,
                                   fontWeight: FontWeight.bold),
                             ),
                           ],
                         ),
                       ],
                     ),
                     Text(
                         "x "+ doc['quantity'].toString(),
                         style: const TextStyle(
                             fontSize: textMedium,
                             fontWeight: FontWeight.w300)),
                   ],
                 ),
                 const SizedBox(
                   height: 40,
                 ),
                 Row(
                   mainAxisAlignment:
                   MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       doc['quantity'].toString() +" items",
                       style: const TextStyle(fontSize: textMedium),
                     ),
                     Text(
                       doc['price'].toString(),
                       style: const TextStyle(
                           color: priceColor,
                           fontSize: textMedium,
                           fontWeight: FontWeight.bold),
                     )
                   ],
                 ),
                 const SizedBox(
                   height: 10,
                 ),
                 Row(
                   mainAxisAlignment:
                   MainAxisAlignment.spaceBetween,
                   children: [
                     const Text(
                       "Subtotal",
                       style: TextStyle(fontSize: textMedium),
                     ),
                     Text(
                       doc['price'].toString(),
                       style: const TextStyle(
                           fontSize: textMedium,
                           fontWeight: FontWeight.bold),
                     )
                   ],
                 ),
                 const SizedBox(
                   height: 10,
                 ),
                 Row(
                   mainAxisAlignment:
                   MainAxisAlignment.spaceBetween,
                   children: const [
                     Text(
                       "Delivery",
                       style: TextStyle(fontSize: textMedium),
                     ),
                     Text(
                       "K0.00",
                       style: TextStyle(
                           fontSize: textMedium,
                           fontWeight: FontWeight.bold),
                     )
                   ],
                 ),
                 const SizedBox(
                   height: 10,
                 ),
                 const Divider(
                   height: 1,
                   color: SecondaryDarkGrey,
                 ),
                 const SizedBox(
                   height: 10,
                 ),
                 Row(
                   mainAxisAlignment:
                   MainAxisAlignment.spaceBetween,
                   children: [
                     const Text(
                       "Total",
                       style: TextStyle(fontSize: textMedium),
                     ),
                     Text(

                    doc['totalAmount'],
                       style: const TextStyle(
                           fontSize: textMedium,
                           fontWeight: FontWeight.bold),
                     )
                   ],
                 ),
                 const SizedBox(
                   height: 10,
                 ),
               ],
             ),
           ),

         ],
       )
     );


     }
     );


     }}
     )

     ),


     Container(
     padding: const EdgeInsets.symmetric(
     horizontal: 20, vertical: 10),
     color: Colors.white,
     height: 70,
     width: double.infinity,
     child: OutlinedButton(
     onPressed: (){
     Navigator.pushReplacement(
     context,
     MaterialPageRoute(
     builder: (context) =>  BottomNav(),
     ),
     );
     },
     style: ButtonStyle(
     side: MaterialStateProperty.all<BorderSide>(
     const BorderSide(
     color: PrimaryBlueOcean,
     width: 1.5,
     ),
     ),
     shape: MaterialStateProperty.all(
     RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10.0))),
     ),
     child: Container(
     margin: const EdgeInsets.symmetric(vertical: 15),
     child: const Text("Back to shopping",
     style: TextStyle(
     fontSize: textMedium,
     color: PrimaryBlueOcean,
     fontWeight: FontWeight.bold))),
     ))
     ]
     )
     ),


     );


   }
 }

