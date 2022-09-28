import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/helpers/constants.dart';
//import 'package:chat2/views/product_detail_view.dart';
//import 'package:chat2/views/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../data/repository/repository.dart';

class ItemCard extends StatelessWidget {



  const ItemCard({Key? key});

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async
      {
       /* final Repository repo = Repository();
        userId != product.sellerId ? await repo.addLog(generateRandomString(12), userId, product.sellerId, "productView")
            : null;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailView(product: product)));*/
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                      image: AssetImage('assets/banner.png'),
                      fit: BoxFit.cover)
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            // products is out demo list
            'product.name.toString()',
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
            'Light blue jacket by Polo Ralph Lauren. Button neck with'
          'spread collar. Zip placket. Embroidered logo to chest and'
    'cuffSide pockets/ Elasticated hem.',
            style: const TextStyle(fontSize: textMedium),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'K 20, 000',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, color: priceColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
