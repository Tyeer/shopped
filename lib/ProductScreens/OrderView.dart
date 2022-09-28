import 'dart:io';
import 'dart:math';
import 'package:chat2/ProductScreens/ConfirmOrder.dart';
import 'package:chat2/ProductScreens/addresses_view.dart';
import 'package:chat2/bloc/address/address_bloc.dart';
import 'package:chat2/data/models/address_model.dart';
import 'package:chat2/data/models/seller_model.dart';
import 'package:chat2/data/models/user_model.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OrderView extends StatefulWidget {
  const OrderView({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  var currentuser = FirebaseAuth.instance.currentUser!.uid;
  File? _image;
  int counter = 1;
  Future<void> _openImagePicker() async {
    final _picker = ImagePicker();
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
  void _incrementCounter() {
    setState(() {
      if (counter <= 20) {
        counter++;
      }
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  void _decrementCounter() {
    setState(() {
      if (counter > 1) {
        counter--;
      }
    });
  }

  void initState() {

  }
  void _validate(String productId, String price2, String name, String imageUrl2, String sellerId,  ){
    if (_image == null){
   Fluttertoast.showToast(msg: 'Provide payment Proof');
    }
    else{
      setState(() {
        _isloading = true  ;
      });
      _opload(productId, price2, name, imageUrl2, sellerId,  );
    }
  }

  void _opload(String productId, String price2, String name, String imageUrl2, String sellerId){
    String imagename = DateTime.now().microsecondsSinceEpoch.toString();
    final Reference  storageReference = FirebaseStorage.instance.ref().child('Proof').child(imagename);
    final UploadTask uploadTask = storageReference.putFile(_image!);
    uploadTask.then((TaskSnapshot taskSnapshot){
      taskSnapshot.ref.getDownloadURL().then((imageUrl) {
        setState(() {
          _isloading = true  ;
        });
        _saveData(imageUrl, productId, price2, name, imageUrl2, sellerId);

      });
      
    }).catchError((error){
      Fluttertoast.showToast(msg: error.toString(),);
    });

  }
  bool _isloading = false;
 void  _saveData(String imageUrl, String productId,  String price2, String name, String imageUrl2, String sellerId){
 var total = price2 * counter;
    DocumentReference ref = FirebaseFirestore.instance.collection('orders').doc();
 String orderno = generateRandomString(15);

FirebaseFirestore.instance.collection('orders').add({
  'Proof': imageUrl,
  'Date Ordered': DateFormat('MMM d, yyyy').format(DateTime.now()),
  'buyerId': FirebaseAuth.instance.currentUser?.uid,
  'sellerId': sellerId,
  'addressId':'3LHrSSH8KYUgd9OhkmZC88FbUX23',
  'quantity': counter,
  'productId': widget.id,
  'orderNo': orderno,
  'Oid': ref.id,
  "orderStatus": "pending",
  "paymentMethods": "cash",
  "totalAmount": total,
  "imageUrl": imageUrl2,
  "price": price2,
  "productName": name,

}).whenComplete(() {
setState((){
_isloading = false;
});

Fluttertoast.showToast(
    msg: "Purchase was Successful",  // message
    toastLength: Toast.LENGTH_SHORT, // length
    gravity: ToastGravity.CENTER,    // location
    timeInSecForIosWeb: 1               // duration
);

  Navigator.of(context).push(MaterialPageRoute(builder: (context){
    return ConfirmOrder(

      id: ref.id, seller: sellerId

    );
  }));
}).catchError((error){
  Fluttertoast.showToast(msg: error.toString(),);
});

 }

  String _addressId = '';

  final FirebaseFirestore? _firebaseFirestore = FirebaseFirestore.instance;

  final Repository repo = Repository();
  String _userId = "";

  final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('userRole');
    String userId = '';
    if(userRole != null){
      if(userRole.contains("seller")){
        //debugPrint("seller");
        Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('phoneNumber'));
        userId = logSeller!.id;
      }
      else {
        Customer? logCustomer = await repo.findBuyerByPhoneNumber(prefs.getString('phoneNumber'));
        userId = logCustomer!.id;
      }

      Stream<List<Address>> addressStream = repo.getAllAddresses(userId.trim());
      //access the stream object and listen to it
      String addr = '';
      addressStream.listen((List<Address> addresses) {
        debugPrint(addresses.toString());
        Address address = addresses[0];
        addr = address.id;
        setState(() {
          _userId = userId;
          _addressId = addr;
        });
      });


    }
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Payment",
          ),
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
                const Text(
                  "Order ID",
                  style:
                  TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.id,
                          style: const TextStyle(
                              fontSize: textMedium, fontWeight: FontWeight.w600),
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
                                color: PrimaryBlueOcean, fontSize: textMedium),
                          ),
                        ],
                      )
                    ],
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: SecondaryDarkGrey.withOpacity(0.1),
                ),
                child:

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
              ),
            ],
          ),
        ),






        GestureDetector(

          onTap: () {
            _openImagePicker();
          },

          child: Container(

            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Provide Proof Payment",
                  style: TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: _image != null
                              ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            width: 100,
                            height: 30,
                            color: Colors.grey,
                            child: Center(child: Text('Select Image',style: TextStyle(color: Colors.white),)),
                          )
                      )),
                ),
              ],
            ),
          ),
        ),

        FutureBuilder<DocumentSnapshot <Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('products').doc(widget.id).get(),
            builder: (_, snapshot) {

              var data = snapshot.data!.data();
              var price = data!['price'];

              var name = data!['name'];
              var imageUrl = data!['imageUrl'];

              var after = int.tryParse(price);


             var  total3 = after! * counter;

              return

        Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: NetworkImage(
                                '${imageUrl}'
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${name}',
                        style: const TextStyle(
                            fontSize: textMedium,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'K ${((total3).toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.00',
                        style: const TextStyle(
                            color: priceColor,
                            fontSize: textMedium,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => _decrementCounter(),
                              icon: const Icon(
                                Icons.remove,
                                color: PrimaryBlueOcean,
                                size: 16,
                              ),
                            ),
                            Text(counter.toString(),
                                style: const TextStyle(fontSize: textMedium)),
                            IconButton(
                              onPressed: () {
                                _incrementCounter();
                              },
                              icon: const Icon(Icons.add,
                                  color: PrimaryBlueOcean, size: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    counter.toString() + " items",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        );



  }
      )

          ]
      )
    ),
        FutureBuilder<DocumentSnapshot <Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('products').doc(widget.id).get(),
            builder: (_, snapshot) {

              var data = snapshot.data!.data();
              var price2 = data!['price'];
              var sellerId= data!['sellerId'];
              var name = data!['name'];
              var imageUrl2 = data!['imageUrl'];
              var productId = data!['productId'];
              var after = int.tryParse(price2);
              var  total2 = after! * counter;

              return
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: Colors.white,
                    height: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'K ${((total2 * counter).toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.00'
                              ,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap:(){
                            _validate(productId, price2, name, imageUrl2,sellerId  );
                          },
                          child: _isloading
                              ? Container(
                            height: 56,
                            width: 140,
                            decoration: BoxDecoration(
                              color: PrimaryBlueOcean,
                              borderRadius: BorderRadius.circular(7),
                            ),
                                child: Row (
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                                Text(
                                  "Loading...",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1, color: Colors.white),
                                )
                            ],
                          ),
                              )
                              : Container(
                            height: 56,
                            width: 140,
                            decoration: BoxDecoration(
                              color: PrimaryBlueOcean,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Center(
                              child: Text(
                                "Buy Now",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ));
            })
    ]
      ),
    );

  }
}
class PaymentWidget extends StatelessWidget {
  const PaymentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text(
          "Payment",
          style: TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
        ),



      ]),
    );
  }
}




