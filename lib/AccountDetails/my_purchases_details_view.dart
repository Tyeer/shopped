import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat2/bloc/blocs.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PurchaseDetailView extends StatefulWidget {
   PurchaseDetailView({Key? key, required this.id2}) : super(key: key);
 String id2;

  @override
  _PurchaseDetailViewState createState() => _PurchaseDetailViewState();
}

class _PurchaseDetailViewState extends State<PurchaseDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Purchase item"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),
        body:

        StreamBuilder<QuerySnapshot>  (
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('Oid', isEqualTo:widget.id2)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
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
                        return

                          Container(child: Column(
                              children: [
                                Container(
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
                                                  doc['orderNo'].toString(),
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
                                                doc['orderStatus'].toString(),
                                                style: const TextStyle(
                                                    fontSize: textMedium, fontWeight: FontWeight.w600),
                                              ),





                                            ],
                                          ),
                                        )
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
                                              "https://www.svgrepo.com/show/13663/user.svg",
                                              height: 20,

                                              color: Colors.amberAccent,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Wink Mboma',
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
                                                    image: NetworkImage(
                                                      doc['imageUrl'],
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
                                                    doc['productName'].toString(),
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
                                                        'K' + doc['price'].toString() + '.00',
                                                        style: const TextStyle(
                                                            color: priceColor,
                                                            fontSize: textMedium,
                                                            fontWeight: FontWeight.bold),
                                                      ),

                                                      const SizedBox(
                                                        width: 170,
                                                      ),
                                                      Text(
                                                        "x"+ doc['quantity'].toString(),
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
                                            doc['Date Ordered'].toString(),
                                            style: const TextStyle(
                                                fontSize: textMedium, color: SecondaryDarkGrey),
                                          ),
                                          Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: greenColor,
                                              ),
                                              child: Text(
                                                doc['orderStatus'].toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: textSmall,
                                                    fontWeight: FontWeight.bold),
                                              ))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            doc['quantity'].toString()+" items",
                                            style: const TextStyle(fontSize: textMedium),
                                          ),
                                          Text(
                                            doc['totalAmount'].toString(),
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
                                      const Text(
                                        "Payment",
                                        style: TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10,),
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Paid using  "+ doc['paymentMethods'],
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
                                            doc['totalAmount'].toString(),
                                            style: const TextStyle(
                                                fontSize: textMedium,
                                                color: priceColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ]
                          ),);
                      }

                  );
              }})
    );
  }
}

class PaymentWidget extends StatelessWidget {
  const PaymentWidget(
      {Key? key, required this.paymentMethod, required this.totalAmount})
      : super(key: key);
  final String paymentMethod;
  final String totalAmount;

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
          Text(
            "Payment",
            style: TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Paid using " + paymentMethod,
            style: TextStyle(
              fontSize: textMedium,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Total",
                style: TextStyle(
                    fontSize: textMedium, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                "K" + totalAmount,
                style: TextStyle(
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

class AddAddressWidget extends StatefulWidget {
  const AddAddressWidget({
    Key? key,
    required this.addressId,
  }) : super(key: key);
  final String? addressId;

  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  final AddressBloc _addressBloc = AddressBloc(addressRepository: Repository());

  @override
  void initState() {
    super.initState();
    if (widget.addressId != null) {
      _addressBloc.add(GetAddress(widget.addressId.toString()));
    }
  }

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
            children: [
              Text(
                "Address",
                style: TextStyle(
                    fontSize: textMedium, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.addressId == null
                    ? Center(child: Text("Create Address"))
                    : BlocBuilder<AddressBloc, AddressState>(
                        bloc: _addressBloc,
                        builder: (context, state) {
                          if (state is AddressLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.addresses[0].name,
                                  style: TextStyle(
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "+265" + state.addresses[0].phone,
                                  style: TextStyle(
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  state.addresses[0].address,
                                  style: TextStyle(
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  state.addresses[0].city,
                                  style: TextStyle(
                                      fontSize: textMedium,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            );
                          }
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        },
                      ),
              ],
            ),
          ),
          // Text(
          //   "Tracking number",
          //   style: TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // SizedBox(
          //   height: 50,
          //   child: TextField(
          //     decoration: InputDecoration(
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(5),
          //         ),
          //         hintText: "Put tracking number",
          //         focusColor: iconBlueDark,
          //         suffix: Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 16),
          //           child: Icon(
          //             Icons.edit_outlined,
          //             color: iconBlueDark,
          //           ),
          //         )),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class OrderIDWidget extends StatelessWidget {
  const OrderIDWidget({
    Key? key,
    required this.orderId,
    required this.status,
  }) : super(key: key);
  final String orderId;
  final String status;

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
            Text(
              "Order ID",
              style:
                  TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      orderId,
                      style: TextStyle(
                          fontSize: textMedium, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/copy.svg",
                        height: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Copy",
                        style: TextStyle(
                            color: PrimaryBlueOcean, fontSize: textMedium),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Status",
              style:
                  TextStyle(fontSize: textMedium, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                        fontSize: textMedium, fontWeight: FontWeight.w600),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: greenColor,
                      ),
                      child: Text(
                        "Confirm delivery",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: textSmall,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddressWidget extends StatefulWidget {
  const AddressWidget({
    Key? key,
    required this.addressId,
  }) : super(key: key);
  final String addressId;

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final AddressBloc _addressBloc = AddressBloc(addressRepository: Repository());

  @override
  void initState() {
    super.initState();
    _addressBloc.add(GetAddress(widget.addressId));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/coolicon.svg",
          height: 20,
        ),
        SizedBox(
          width: 10,
        ),
        BlocProvider(
          create: (_) => _addressBloc,
          child: BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              return Text(
                state is AddressLoaded ? state.addresses[0].name : "",
                style: TextStyle(
                    fontSize: textMedium, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ],
    );
  }
}
