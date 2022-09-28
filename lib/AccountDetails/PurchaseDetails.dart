
import 'package:chat2/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PurchaseDetails extends StatefulWidget {
  const PurchaseDetails({Key? key}) : super(key: key);

  @override
  State<PurchaseDetails> createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends State<PurchaseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Purchase Item"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),

      body: ListView(
        children: [
          OrderIDWidget(
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

                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chitawira",
                            style: const TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "+265 99 806 8724",
                            style: const TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Private Bag 11",
                            style: const TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Blantyre',
                            style: const TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text('Tracking Number',
                        style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quickand',

                        ),
                      ),

                      SizedBox(height: 10,),
                      Container(
                        width: 350,
                        height: 35,
                        margin: const EdgeInsets.all(0.0),
                        child: TextField(


                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,

                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Put tracking number",

                            suffixIcon: Icon(Icons.edit,



                              size: 15,
                            ),

                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.network(
                        "https://www.svgrepo.com/show/18137/home.svg",
                        height: 20,

                        color: Colors.amberAccent,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Gladlex Shopping Center',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/barbao3.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Text(
                              'barbao',
                              style: const TextStyle(
                                  fontSize: textMedium,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'K 12,000.00',
                                  style: const TextStyle(
                                      color: priceColor,
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(
                                  width: 170,
                                ),
                                Text(
                                  "x1",
                                  style: const TextStyle(
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.bold),
                                ),

                              ],),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '2022/20/02',
                      style: const TextStyle(
                          fontSize: textMedium, color: SecondaryDarkGrey),
                    ),

                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "1 items",
                      style: const TextStyle(fontSize: textMedium),
                    ),
                    Text(
                      'K 12, 000',
                      style: const TextStyle(
                          color: priceColor,
                          fontSize: textMedium,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),

          PaymentWidget(
          ),


        ],
      ),
    );
  }


}


class PaymentWidget extends StatelessWidget {
  /*const PaymentWidget(
      {Key? key, required this.paymentMethod, required this.totalAmount})
      : super(key: key);
  final String paymentMethod;
  final String totalAmount;*/

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment",
            style: TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "You paid using  Airtel Money" /*+ paymentMethod*/,
            style: const TextStyle(
              fontSize: textMedium,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Total",
                style: TextStyle(
                    fontSize: textMedium, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "K12, 000",
                style: const TextStyle(
                    fontSize: textMedium,
                    color: priceColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
class OrderIDWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                      'SP9873680016171738389',
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
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Status",
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


                  Text(
                    'Success',
                    style: const TextStyle(
                        fontSize: textMedium, fontWeight: FontWeight.w600),
                  ),



                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

