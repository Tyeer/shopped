import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:chat2/bloc/blocs.dart';
import 'package:chat2/bloc/order/order_bloc.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../bottom_nav.dart';

class OrderConfimationView extends StatefulWidget {
  /*const OrderConfimationView({Key? key, required this.orderId})
      : super(key: key);
  final String orderId;*/

  @override
  State<OrderConfimationView> createState() => _OrderConfimationViewState();
}

class _OrderConfimationViewState extends State<OrderConfimationView> {
  final OrderBloc _orderBloc = OrderBloc(orderRepository: Repository());
  final Repository repo = Repository();
  List<Seller> _sellers = [];

  @override
  /*void initState() {
    super.initState();
    _orderBloc.add(GetOrder(widget.orderId));
    Stream<List<Seller>> sellerStream = repo.getAllSellers();
    //access the stream object and listen to it
    sellerStream.listen((List<Seller> sellers) {
      setState(() {
        _sellers = sellers;
      });
    });

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          )),
      body: Container(

        child:
                Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        OrderIDWidget(),
                        AddAddressWidget(),
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
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundImage: AssetImage('assets/profile1.jpg'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Winkford Mboma',
                                        style: const TextStyle(
                                            fontSize: textMedium,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
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
                                            image: AssetImage(
                                              'assets/1.jpg'
                                            ),
                                            fit: BoxFit.cover,
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
                                            'Barbao Benz',
                                            style: const TextStyle(
                                                fontSize: textMedium,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'K 20, 000,000',
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
                                      "x 1" ,
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
                                    "1 items",
                                    style: const TextStyle(fontSize: textMedium),
                                  ),
                                  Text(
                                    'K 20, 000,000',
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
                                    'K 20, 000,000',
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
                                    'K 20, 000,000',
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
                    ),
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
                              builder: (context) => const BottomNav(),
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
                ],
              ),




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

class AddAddressWidget extends StatefulWidget {


  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  final AddressBloc _addressBloc = AddressBloc(addressRepository: Repository());

/*  @override
  void initState() {
    super.initState();
    if (widget.addressId != null) {
      _addressBloc.add(GetAddress(widget.addressId.toString()));
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chitawira',
                                  style: const TextStyle(
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "+265 99 806 87 24",
                                  style: const TextStyle(
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  'Private Bag 11, dedza',
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


              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderIDWidget extends StatelessWidget {
/*  const OrderIDWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final Order order;*/


  @override
  Widget build(BuildContext context) {
    return 
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
                            fontWeight: FontWeight.bold, fontSize: textMedium)),
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
              "Time placed: 22 June, 2022 " ,
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: textMedium),
            ),
            const SizedBox(height: 40),
            const Text(
              "Order ID",
              style:
                  TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
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
              "Payment",
              style:
                  TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "Paid through Airtel Money" ,
                style: const TextStyle(
                  fontSize: textMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
