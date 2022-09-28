import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat2/models/producted.dart';
import 'package:chat2/widget/item_card.dart';

import '../bloc/order/order_bloc.dart';
import '../data/models/order_model.dart';
import '../data/models/seller_model.dart';
import '../data/models/user_model.dart';
import '../data/repository/repository.dart';

// We need satefull widget for our categories

class TransactionTabs extends StatefulWidget {
  @override
  _TransactionTabsState createState() => _TransactionTabsState();
}

class _TransactionTabsState extends State<TransactionTabs> {
  List<String> categories = [
    "All",
    "Completed",
    "Pending",
    "Refunded",
  ];
  // By default our first item will be selected
  int selectedIndex = 0;
  final Repository repo = Repository();
  final OrderBloc _allOrdersBloc = OrderBloc(orderRepository: Repository());
  final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');


  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('userRole');
    if(userRole != null){
      if(userRole.contains("seller")){
        //debugPrint("seller");
        Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('phoneNumber'));
        debugPrint(logSeller!.id);
        _allOrdersBloc.add(LoadAllSellersOrders(sellerId: logSeller.id));

      }
      else {
        Customer? logCustomer = await repo.findBuyerByPhoneNumber(prefs.getString('phoneNumber'));
        _allOrdersBloc.add(LoadBuyersOrders(buyerId: logCustomer!.id));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [






        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) => buildCategory(index),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Text('2022/02/02',
                style: TextStyle(color: Colors.grey,
                  fontFamily: 'Quickand',

                ),
              ),
            ],
          ),
        ),
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CircleAvatar(
                      backgroundColor: Colors.blueAccent[100],
                      backgroundImage: NetworkImage('https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Products'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: SecondaryDarkGrey,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "12 Dec 2021 10:30 pm",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 130,
                            ),
                            Text('+K80,000',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700),)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
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

                          child: Text('Confirmed',

                            style: TextStyle(color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Quicksand',
                            ),
                          ),

                        ),
                      ],
                    ),


                  ],
                )
            )
        ),
        const SizedBox(
          height: 10,
        ),


        Container(

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CircleAvatar(
                      backgroundColor: Colors.blueAccent[100],
                      backgroundImage: NetworkImage('https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Products'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: SecondaryDarkGrey,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "12 Dec 2021 10:30 pm",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 130,
                            ),
                            Text('+K80,000',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700),)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
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

                          child: Text('Confirmed',

                            style: TextStyle(color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Quicksand',
                            ),
                          ),

                        ),
                      ],
                    ),


                  ],
                )
            )
        ),


      ],
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: selectedIndex == index ? activeTabColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          categories[index],
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: selectedIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
