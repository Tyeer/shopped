import 'package:chat2/AccountDetails/AboutView.dart';
import 'package:chat2/AccountDetails/StarredProducts.dart';
import 'package:chat2/AccountDetails/StatisticsView.dart';
import 'package:chat2/AccountDetails/follows_view.dart';
import 'package:chat2/AccountDetails/my_purchase_view.dart';
import 'package:chat2/AccountDetails/orders_view.dart';
import 'package:chat2/AccountDetails/security_view.dart';
import 'package:chat2/AccountDetails/shop_info_view.dart';
import 'package:chat2/AccountDetails/starred_products_view.dart';
import 'package:chat2/AccountDetails/user_info_view.dart';
import 'package:chat2/AuthScreens/phone_auth_view.dart';
import 'package:chat2/HomeScreens/BuyerProfile.dart';
import 'package:chat2/ProductScreens/MyProducts.dart';
import 'package:chat2/ProductScreens/add_product_view.dart';
import 'package:chat2/ProductScreens/transations_view.dart';
import 'package:chat2/bloc/follows/follows_bloc.dart';
import 'package:chat2/bloc/order/order_bloc.dart';
import 'package:chat2/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:chat2/bloc/product/product_bloc.dart';
import 'package:chat2/bottom_nav.dart';
import 'package:chat2/data/models/log_model.dart';
import 'package:chat2/data/models/seller_model.dart';
import 'package:chat2/data/models/user_model.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  var currentuser = FirebaseAuth.instance.currentUser!.uid;
  String _phone = "";
  @override
  void initState() {
    super.initState();
  }
  final Repository repo = Repository();
  final PhoneAuthBloc _authBloc = PhoneAuthBloc(
    phoneAuthRepository: Repository(),
  );
  final OrderBloc _purchaseBloc = OrderBloc(orderRepository: Repository());
  final ProductBloc _productsBloc = ProductBloc(productRepository: Repository());
  final OrderBloc _orderBloc = OrderBloc(orderRepository: Repository());
  final OrderBloc _allOrdersBloc = OrderBloc(orderRepository: Repository());
  final FollowsBloc _allFollows = FollowsBloc(followsRepository: Repository());
  List<Log> _shopVisits = [];
  String _userId = "";

  String _userRole = "";

  Seller? _sellerObject = null;
  final DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');


  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('Type');
    if(userRole != null){
      if(userRole.contains("Seller")){

        Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('Phonenumber'));
        _purchaseBloc.add(LoadPurchaseOrders(sellerId: logSeller!.id));
        _productsBloc.add(LoadSellerProducts(sellerId: logSeller.id));
        _orderBloc.add(LoadSellersOrders(sellerId: logSeller.id));
        _allOrdersBloc.add(LoadAllSellersOrders(sellerId: logSeller.id));
        _allFollows.add(LoadFollows(sellerId: logSeller.id));
        List<Log> tempList = await repo.getShopVisits(logSeller.id);
        DateTime now = DateTime.now();
        setState(() {
          _userId = logSeller.id;
          _phone = prefs.getString('Phonenumber') ?? '';
          _userRole = prefs.getString('Type') ?? '';
          _sellerObject = logSeller;
          _shopVisits = tempList.where((element) => format.parse(element.date).month == now.month).toList();
        });
      }
      else {
        Customer? logCustomer = await repo.findBuyerByPhoneNumber(prefs.getString('Phonenumber'));
        _orderBloc.add(LoadBuyersOrders(buyerId: logCustomer!.id));
        _purchaseBloc.add(LoadBuyerPurchases(buyerId: logCustomer.id));
        setState(() {
          _userId = logCustomer.id;
          _phone = prefs.getString('Phonenumber') ?? '';
          _userRole = prefs.getString('Type') ?? '';
        });
      }
    }
  }


  @override
  void initState2() {
    super.initState();
    getSharedPrefs();
  }

final _auth = FirebaseAuth.instance.currentUser!.uid;

  final Stream<QuerySnapshot> userRole = FirebaseFirestore.instance
      .collection('users')
      .where('Type', isEqualTo: 'Seller')
      .snapshots();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,

        title: const Center(child: Text('Profile'),),
      ),

    body: Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ListView(
    children: [
    const SizedBox(
    height: 10,
    ),
RepositoryProvider(
          create: (context) => Repository(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => PhoneAuthBloc(
                  phoneAuthRepository:
                  RepositoryProvider.of<Repository>(context),
                ),
              ),
            ],
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users').
              where('Uid', isEqualTo: currentuser)
              .where('Type', isEqualTo: 'Seller')
                  .snapshots(),
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  return  Container(
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>  (
                              stream: FirebaseFirestore.instance
                                  .collection('users').
                              where('Uid', isEqualTo: currentuser)

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

                                          Card(
                                            color: Colors.blue[800],
                                            elevation: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Row(
                                                children: [

                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(doc['userImage']),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      doc['Fullname'],
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),

                                                  IconButton(
                                                    onPressed: () { Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) =>  UserInfoView(

                                                          Fullname: doc['Fullname'],
                                                          Uid: doc['Uid'],
                                                          userImage: doc['userImage'],
                                                          Phonenumber: doc['Phonenumber'],


                                                        ))
                                                    );},
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );


                                      });}

                              }
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: (1 / .5),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              children: [


                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OrdersView()));
                                  },
                                  child: Container(
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
                                                backgroundColor: Colors.red[100],
                                                child: SvgPicture.asset(
                                                  "assets/icons/cart.svg",
                                                  height: 15,

                                                  color: Colors.red[800],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Orders'.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: SecondaryDarkGrey,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),

                                                  StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance
                                                        .collection('orders')
                                                        .where('sellerId',isEqualTo: currentuser )
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return CircularProgressIndicator();
                                                      } else {
                                                        return
                                                          Text(
                                                            snapshot.data!.docs.length.toString().toUpperCase(),
                                                            style: const TextStyle(
                                                                fontSize: 25,
                                                                color: Color(0xff330066),
                                                                fontWeight: FontWeight.bold),
                                                          );
                                                      }
                                                    },
                                                  ),


                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PurchaseView()));
                                  },
                                  child: Container(
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
                                                backgroundColor: Colors.red[100],
                                                child: SvgPicture.asset(
                                                  "assets/icons/cart.svg",
                                                  height: 15,
                                                  color: Colors.red[800],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Purchases'.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: SecondaryDarkGrey,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance
                                                        .collection('orders')
                                                        .where('sellerId',isEqualTo: currentuser )

                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return CircularProgressIndicator();
                                                      } else {
                                                        return
                                                          Text(
                                                            snapshot.data!.docs.length.toString().toUpperCase(),
                                                            style: const TextStyle(
                                                                fontSize: 25,
                                                                color: Color(0xff330066),
                                                                fontWeight: FontWeight.bold),
                                                          );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ),

                              ]),
                          const SizedBox(
                            height: 10,
                          ),

                          GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: (1 / .5),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              children: [


                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyProducts()));
                                  },
                                  child:
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
                                                child: SvgPicture.network(
                                                  "https://www.svgrepo.com/show/58582/big-box.svg",
                                                  height: 15,
                                                  color:Color(0xFF3669C9),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'My Products   '.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: SecondaryDarkGrey,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance
                                                        .collection('products')
                                                        .where('sellerId',isEqualTo: currentuser )
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return CircularProgressIndicator();
                                                      } else {
                                                        return
                                                          Text(
                                                            snapshot.data!.docs.length.toString().toUpperCase(),
                                                            style: const TextStyle(
                                                                fontSize: 25,
                                                                color: Color(0xff330066),
                                                                fontWeight: FontWeight.bold),
                                                          );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PurchaseView()));*/
                                  },
                                  child: Container(
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
                                                backgroundColor: Colors.green[100],
                                                child: SvgPicture.network(
                                                  "https://www.svgrepo.com/show/51298/report.svg",
                                                  height: 15,
                                                  color: Colors.green[800],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'History'.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: SecondaryDarkGrey,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "230".toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.deepPurpleAccent,
                                                        fontWeight: FontWeight.w700),
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ),

                              ]),
                          const SizedBox(
                            height: 10,
                          ),


                          GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: (1 / .5),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              children: [


                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddProductView()));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [

                                              CircleAvatar(
                                                backgroundColor: Colors.grey[300],
                                                child: SvgPicture.network(
                                                  "https://www.svgrepo.com/show/58582/big-box.svg",
                                                  height: 15,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Add Products'.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold),
                                                  ),


                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TransactionsView ()));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [

                                              CircleAvatar(
                                                backgroundColor: Colors.blueAccent[100],
                                                child: SvgPicture.network(
                                                  "https://www.svgrepo.com/show/34314/wallet.svg",
                                                  height: 15,
                                                  color: Colors.blue[800],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Transaction'.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blueAccent,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),

                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ),

                              ]),
                          const SizedBox(
                            height: 10,
                          ),
                          GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: (1 / .5),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              children: [


                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>StarredProductsView ()));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [

                                              CircleAvatar(
                                                backgroundColor: Colors.amberAccent[100],
                                                child: SvgPicture.network(
                                                  "https://www.svgrepo.com/show/8843/star.svg",
                                                  height: 15,
                                                  color: Colors.amber[800],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Starred'.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 15,

                                                        color: Colors.amber,
                                                        fontWeight: FontWeight.bold),
                                                  ),


                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FollowsView ()));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [

                                              CircleAvatar(
                                                backgroundColor: Colors.blue[100],
                                                child: SvgPicture.network(
                                                  "https://www.svgrepo.com/show/34976/like.svg",
                                                  height: 15,
                                                  color: Colors.blue[800],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Following'.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),

                                                ],
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ),

                              ]),

                          const SizedBox(
                            height: 10,
                          ),

                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Account Settings",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                GridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: (1 / .5),
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    children: [


                                      StreamBuilder<QuerySnapshot>  (
                                          stream: FirebaseFirestore.instance
                                              .collection('users').
                                          where('Uid', isEqualTo: currentuser)

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
                                                      GestureDetector(
                                                        onTap: (){
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => UserInfoView(

                                                                    Fullname: doc['Fullname'],
                                                                    Uid: doc['Uid'],
                                                                    userImage: doc['userImage'],
                                                                    Phonenumber: doc['Phonenumber'],

                                                                  )));
                                                        },
                                                        child: Container(
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
                                                                      backgroundColor: Colors.blueGrey,
                                                                      child: SvgPicture.asset(
                                                                        "assets/icons/user.svg",
                                                                        height: 15,
                                                                        color: Colors.blue,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'User info'.toUpperCase(),
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              color: SecondaryDarkGrey,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                            children:[ Text(
                                                                              "Edit",
                                                                              style: const TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.blueAccent,
                                                                                  fontWeight: FontWeight.w700),
                                                                            ),

                                                                              SizedBox(width: 20,),
                                                                              SvgPicture.asset(
                                                                                "assets/icons/pencil.svg",
                                                                                height: 15,
                                                                                color: Colors.blueAccent,
                                                                              ),
                                                                            ]
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                )
                                                            )
                                                        ),
                                                      );

                                                  });}

                                          }
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SecurityView()));
                                        },
                                        child: Container(
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
                                                      backgroundColor: Colors.blueGrey,
                                                      child: Icon(
                                                        Icons.lock,color: Colors.blue,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Security'.toUpperCase(),
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: SecondaryDarkGrey,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                            children:[ Text(
                                                              "Edit",
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors.blueAccent,
                                                                  fontWeight: FontWeight.w700),
                                                            ),

                                                              SizedBox(width: 20,),
                                                              SvgPicture.asset(
                                                                "assets/icons/pencil.svg",
                                                                height: 15,
                                                                color: Colors.blueAccent,
                                                              ),
                                                            ]
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                            )
                                        ),
                                      ),

                                    ]),
                                const SizedBox(
                                  height: 10,
                                ),

                                GridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: (1 / .5),
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    children: [

                                      StreamBuilder<QuerySnapshot>  (
                                          stream: FirebaseFirestore.instance
                                              .collection('users').
                                          where('Uid', isEqualTo: currentuser)

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
                                                      GestureDetector(
                                                        onTap: (){
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ShopInfoView(

                                                                    ShopName: doc['ShopName'],
                                                                    Uid: doc['Uid'],
                                                                    ShopImage: doc['coverImage'],
                                                                    Location: doc['ShopLocation'],
                                                                    AboutShop: doc['aboutshop'],

                                                                  )));
                                                        },
                                                        child: Container(
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
                                                                      backgroundColor: Colors.blueGrey,
                                                                      child: SvgPicture.asset(
                                                                        "assets/icons/pram.svg",
                                                                        height: 15,
                                                                        color: Colors.blue,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'Shop info'.toUpperCase(),
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              color: SecondaryDarkGrey,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                            children:[ Text(
                                                                              "Edit",
                                                                              style: const TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.blueAccent,
                                                                                  fontWeight: FontWeight.w700),
                                                                            ),

                                                                              SizedBox(width: 20,),
                                                                              SvgPicture.asset(
                                                                                "assets/icons/pencil.svg",
                                                                                height: 15,
                                                                                color: Colors.blueAccent,
                                                                              ),
                                                                            ]
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                )
                                                            )
                                                        ),
                                                      );

                                                  });}

                                          }
                                      ),

                                    ]),

                              ]
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Account Settings",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  elevation: 0.5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: (){
                                              /*  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeNumber()));*/
                                            },
                                            child:GestureDetector(

                                              onTap: (){

                                              },
                                              child: OfficialListWidget(
                                                leftIcon: "assets/icons/heart.svg",
                                                label: _phone,
                                                detail: "Statistics",
                                                icon: true,

                                                press: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsView()));
                                                },
                                              ),
                                            )
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                            onTap: (){

                                            },
                                            child:GestureDetector(

                                              child: OfficialListWidget(
                                                leftIcon: "assets/icons/heart.svg",
                                                label: _phone,
                                                detail: "Help & Support",
                                                icon: true,
                                                press: (){},
                                              ),
                                            )
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutView()));
                                            },
                                            child:GestureDetector(

                                              child: OfficialListWidget(
                                                leftIcon: "assets/icons/heart.svg",
                                                label: _phone,
                                                detail: "About App",
                                                icon: true,
                                                press: (){},
                                              ),
                                            )
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),


                                        InkWell(
                                            onTap: () {
                                            },

                                            child: GestureDetector(
                                              onTap: () async{


                                                await FirebaseAuth.instance.signOut();
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNav()));
                                              },
                                              child: OfficialListWidget(
                                                leftIcon: "assets/icons/sign-out.svg",
                                                label: "Logout",
                                                detail: "Logout ",
                                                icon: true,
                                                press: () async{

                                                  await FirebaseAuth.instance.signOut();
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNav()));
                                                  //  await _auth.signOut();
                                                },
                                              ),
                                            )
                                        )


                                      ],
                                    ),
                                  ),
                                ),
                              ]
                          ),

                        ],
                      )
                  );
                }
                return   Container(
                    child: Column(
                      children: [

                        StreamBuilder<QuerySnapshot>  (
                            stream: FirebaseFirestore.instance
                                .collection('users').
                            where('Uid', isEqualTo: currentuser)

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

                                        Card(
                                          color: Colors.blue[800],
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              children: [

                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(doc['userImage']),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    doc['Fullname'],
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),

                                                IconButton(
                                                  onPressed: () { Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => UserInfoView(

                                                        Fullname: doc['Fullname'],
                                                        Uid: doc['Uid'],
                                                        userImage: doc['userImage'],
                                                        Phonenumber: doc['Phonenumber'],

                                                      ))
                                                  );},
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );


                                    });}

                            }
                        ),


                        const SizedBox(
                          height: 10,
                        ),
                        GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: (1 / .5),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            children: [



                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PurchaseView()));
                                },
                                child: Container(
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
                                              backgroundColor: Colors.red[100],
                                              child: SvgPicture.asset(
                                                "assets/icons/cart.svg",
                                                height: 15,
                                                color: Colors.red[800],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Purchases'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: SecondaryDarkGrey,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .where('sellerId',isEqualTo: currentuser )
                                                      .where('orderStatus', isEqualTo: 'confirmed')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return CircularProgressIndicator();
                                                    } else {
                                                      return
                                                        Text(
                                                          snapshot.data!.docs.length.toString().toUpperCase(),
                                                          style: const TextStyle(
                                                              fontSize: 25,
                                                              color: Color(0xff330066),
                                                              fontWeight: FontWeight.bold),
                                                        );
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PurchaseView()));*/
                                },
                                child: Container(
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
                                              backgroundColor: Colors.green[100],
                                              child: SvgPicture.network(
                                                "https://www.svgrepo.com/show/51298/report.svg",
                                                height: 15,
                                                color: Colors.green[800],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'History'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: SecondaryDarkGrey,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "230".toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.deepPurpleAccent,
                                                      fontWeight: FontWeight.w700),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                    )
                                ),
                              ),

                            ]),
                        const SizedBox(
                          height: 10,
                        ),


                        const SizedBox(
                          height: 10,
                        ),


                        GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: (1 / .5),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            children: [



                              GestureDetector(
                                onTap: ()async{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StarredProductsView ()));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            CircleAvatar(
                                              backgroundColor: Colors.amberAccent[100],
                                              child: SvgPicture.network(
                                                "https://www.svgrepo.com/show/8843/star.svg",
                                                height: 15,
                                                color: Colors.amber[800],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Starred'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 15,

                                                      color: Colors.amber,
                                                      fontWeight: FontWeight.bold),
                                                ),


                                              ],
                                            )
                                          ],
                                        )
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TransactionsView ()));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            CircleAvatar(
                                              backgroundColor: Colors.blueAccent[100],
                                              child: SvgPicture.network(
                                                "https://www.svgrepo.com/show/34314/wallet.svg",
                                                height: 15,
                                                color: Colors.blue[800],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Transaction'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blueAccent,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),

                                              ],
                                            )
                                          ],
                                        )
                                    )
                                ),
                              ),

                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: (1 / .5),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            children: [


                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FollowsView ()));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            CircleAvatar(
                                              backgroundColor: Colors.blue[100],
                                              child: SvgPicture.network(
                                                "https://www.svgrepo.com/show/34976/like.svg",
                                                height: 15,
                                                color: Colors.blue[800],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Following'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),

                                              ],
                                            )
                                          ],
                                        )
                                    )
                                ),
                              ),

                            ]),

                        const SizedBox(
                          height: 10,
                        ),

                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account Settings",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: (1 / .5),
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  children: [

                                    StreamBuilder<QuerySnapshot>  (
                                        stream: FirebaseFirestore.instance
                                            .collection('users').
                                        where('Uid', isEqualTo: currentuser)

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
                                                    GestureDetector(
                                                      onTap: (){
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => UserInfoView(

                                                                  Fullname: doc['Fullname'],
                                                                  Uid: doc['Uid'],
                                                                  userImage: doc['userImage'],
                                                                  Phonenumber: doc['Phonenumber'],

                                                                )));
                                                      },
                                                      child: Container(
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
                                                                    backgroundColor: Colors.blueGrey,
                                                                    child: SvgPicture.asset(
                                                                      "assets/icons/user.svg",
                                                                      height: 15,
                                                                      color: Colors.blue,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        'User info'.toUpperCase(),
                                                                        style: const TextStyle(
                                                                            fontSize: 12,
                                                                            color: SecondaryDarkGrey,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                          children:[ Text(
                                                                            "Edit",
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                color: Colors.blueAccent,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),

                                                                            SizedBox(width: 20,),
                                                                            SvgPicture.asset(
                                                                              "assets/icons/pencil.svg",
                                                                              height: 15,
                                                                              color: Colors.blueAccent,
                                                                            ),
                                                                          ]
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                          )
                                                      ),
                                                    );

                                                });}

                                        }
                                    ),


                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SecurityView()));
                                      },
                                      child: Container(
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
                                                    backgroundColor: Colors.blueGrey,
                                                    child: Icon(
                                                      Icons.lock,color: Colors.blue,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Security'.toUpperCase(),
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: SecondaryDarkGrey,
                                                            fontWeight: FontWeight.w700),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                          children:[ Text(
                                                            "Edit",
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.blueAccent,
                                                                fontWeight: FontWeight.w700),
                                                          ),

                                                            SizedBox(width: 20,),
                                                            SvgPicture.asset(
                                                              "assets/icons/pencil.svg",
                                                              height: 15,
                                                              color: Colors.blueAccent,
                                                            ),
                                                          ]
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                          )
                                      ),
                                    ),

                                  ]),
                              const SizedBox(
                                height: 10,
                              ),



                            ]
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Account Settings",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 0.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: (){

                                          },
                                          child:GestureDetector(

                                            child: OfficialListWidget(
                                              leftIcon: "assets/icons/heart.svg",
                                              label: _phone,
                                              detail: "Statistics",
                                              icon: true,

                                              press: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsView()));
                                              },
                                            ),
                                          )
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                          onTap: (){
                                            /* Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeNumber()));*/
                                          },
                                          child:GestureDetector(

                                            child: OfficialListWidget(
                                              leftIcon: "assets/icons/heart.svg",
                                              label: _phone,
                                              detail: "Help & Support",
                                              icon: true,
                                              press: (){},
                                            ),
                                          )
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  AboutView()));
                                          },
                                          child:GestureDetector(

                                            child: OfficialListWidget(
                                              leftIcon: "assets/icons/heart.svg",
                                              label: _phone,
                                              detail: "About App",
                                              icon: true,
                                              press: (){},
                                            ),
                                          )
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),


                                      InkWell(
                                          onTap: () {
                                          },

                                          child: GestureDetector(
                                            onTap: () async{


                                              await FirebaseAuth.instance.signOut();
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNav()));
                                            },
                                            child: OfficialListWidget(
                                              leftIcon: "assets/icons/sign-out.svg",
                                              label: "Logout",
                                              detail: "Logout ",
                                              icon: true,
                                              press: () async{

                                                await FirebaseAuth.instance.signOut();
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNav()));
                                                // await _auth.signOut();
                                              },
                                            ),
                                          )
                                      )


                                    ],
                                  ),
                                ),
                              ),
                            ]
                        ),

                      ],
                    )
                );
              },
            ),
          ))


          ///for selle



    ]
    )
    ),

    );
  }

}
