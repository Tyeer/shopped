
import 'dart:math';

import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddReview extends StatefulWidget {
  const AddReview({Key? key, }) : super(key: key);


  @override
  State<AddReview> createState() => _AddReview();
}

class _AddReview extends State<AddReview> {
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

  Future<void> addReview(String rating, String description) async {
    String reviewId = generateRandomString(15);
    await _firebaseFirestore?.collection('reviews').doc(reviewId).set({
      //'objectId': widget.objectId,
      'description': description,
     // 'reviewType': widget.reviewType,
      'rating' : rating,
      'likes' : "0",
      'buyerId': _userId,
      'reviewId' : reviewId,
      'createdAt': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
    });

    Fluttertoast.showToast(
        msg: "Review added successfully",  // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,    // location
        timeInSecForIosWeb: 1               // duration
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Starred",
          style: TextStyle(color: Colors.white, fontSize: appBarTitleSize),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 180,),
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
  }
}