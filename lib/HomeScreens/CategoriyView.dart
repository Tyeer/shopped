import 'package:chat2/HomeScreens/Search.dart';
import 'package:chat2/HomeScreens/product_view.dart';
import 'package:chat2/ProductScreens/ProductDetails.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CategoriyView extends StatefulWidget {
  const CategoriyView({Key? key}) : super(key: key);

  @override
  State<CategoriyView> createState() => _CategoriyViewState();
}

class _CategoriyViewState extends State<CategoriyView> {
  String _searchString = '';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,

        title: GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>Search()));
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 2, 2, 2),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                    suffixIcon: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(120)),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>Search()));
                        },
                      ),
                    ),
                    hintText: 'What are you looking for?',
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
      ),


          body: Row(
    children: <Widget>[
          NavigationRail(
          selectedIconTheme: const IconThemeData(color: iconBlueDark),
        unselectedIconTheme: const IconThemeData(
          color: SecondaryDarkGrey,
        ),
        backgroundColor: Colors.white,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        labelType: NavigationRailLabelType.selected,
        destinations: [
          NavigationRailDestination(
            icon: Column(
              children: [
                SvgPicture.network(
                  "https://www.svgrepo.com/show/202035/menu.svg",
                  color: Colors.grey,

                  height: 23.5,
                  // By default our  icon color is white
                ),
                const Text("Popular", style: TextStyle(fontSize: textSmall))
              ],
            ),
            selectedIcon: Column(
              children: [
                SvgPicture.network(
                  "https://www.svgrepo.com/show/202035/menu.svg",
                  color: iconBlueDark,

                  height: 23.5,
                  // By default our  icon color is white
                ),
                const Text("Popular", style: TextStyle(fontSize: textSmall, color: iconBlueDark)),


              ],
            ),
            label: Text(""),
          ),

          NavigationRailDestination(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    "assets/icons/device.svg",
                    color: Colors.grey,

                    // By default our  icon color is white
                  ),
                  Text('Electronics', style: const TextStyle(fontSize: textSmall,))
                ],
              ),
              selectedIcon: Column(
                children: [
                  SvgPicture.asset(
                    "assets/icons/device.svg",
                    color: iconBlueDark,

                    // By default our  icon color is white
                  ),
                  Text('Electronics', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),
                  SizedBox(height: 5,),

                ],
              ),
              label: Text(""),
            ),
          NavigationRailDestination(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    "assets/icons/furniture.svg",
                    color: Colors.grey,

                    // By default our  icon color is white
                  ),
                  Text('Furniture', style: const TextStyle(fontSize: textSmall, ))
                ],
              ),
              selectedIcon: Column(
                children: [
                  SvgPicture.asset(
                    "assets/icons/furniture.svg",
                    color: iconBlueDark,

                    // By default our  icon color is white
                  ),
                  Text('Furniture', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),

                ],
              ),
              label: Text(""),
            ),
          NavigationRailDestination(
            icon: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/fashion.svg",
                  color: Colors.grey,
                  // By default our  icon color is white
                ),
                Text('Fashion', style: const TextStyle(fontSize: textSmall))
              ],
            ),
            selectedIcon: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/fashion.svg",
                  color: iconBlueDark,

                  // By default our  icon color is white
                ),
                Text('Fashion', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),

              ],
            ),
            label: Text(""),
          ),


          NavigationRailDestination(
            icon: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/baby.svg",
                  color: Colors.grey,
                  // By default our  icon color is white
                ),
                Text('Baby', style: const TextStyle(fontSize: textSmall,))
              ],
            ),
            selectedIcon: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/baby.svg",
                  color: iconBlueDark,

                  // By default our  icon color is white
                ),
                Text('Baby', style: const TextStyle(fontSize: textSmall, color: iconBlueDark))
              ],
            ),
            label: Text(""),
          ),
        ] ),
      Expanded(
          child: Container(

    child: ListView(
    children: [
      _selectedIndex == 0 ?
          Container(



            child:


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Text("All",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: SecondaryDarkGrey)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    Column(

                        children:[
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductView(

                                      )));
                            },
                            child: Container(
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(7),
                              ),
                              margin: EdgeInsets.all(10.0),
                              child: new ClipRRect(
                                borderRadius: new BorderRadius.circular(10.0),
                                child: new Image(
                                  image: new NetworkImage('https://media.istockphoto.com/photos/blue-chino-pants-with-brown-leather-belt-isolated-on-white-background-picture-id1149139165?k=20&m=1149139165&s=612x612&w=0&h=GZNt8WgiJ3tSbVmcAKbIUmFAzbulMTw1NJ7msG2Tyno='),
                                  height: 60,
                                  width:60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Text('Trousers',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://dpegb9ebondhq.cloudfront.net/product_photos/85797283/file_335a51ac92_original.jpg'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Shoes',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://i.pinimg.com/originals/8e/5f/86/8e5f86f5290eec3f09db5e405b25e07a.png'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Dresses',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://cdn.shopify.com/s/files/1/0409/7245/products/skyblue_26f13da0-a8df-496a-a86a-bdeb3e844223_1024x1024.png?v=1603977357'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('IPhones',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://p2-ofp.static.pub/fes/cms/2021/04/28/odtbtgltop8fb3ytjpdy4orxz9a3l7232523.jpg'),
                                height: 60,
                                width:60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Lenevo LP',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://www.homelane.com/blog/wp-content/uploads/2021/11/shutterstock_735847378.jpg'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Sofa Sets',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://cdn.shopify.com/s/files/1/0075/2815/3206/products/FRAND02.jpg?v=1576271268'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Dinning Tables',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://www.keeltoys.com/wp-content/uploads/2013/10/SN0513-775x857.jpg'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Dolls',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [


                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://babyshopnigeria.com/wp-content/uploads/2018/10/61ROw2YmqfL._SL1000_.jpg'),
                                height: 60,
                                width:60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Baby Net',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://secure.img1-cg.wfcdn.com/im/00231479/resize-h600-w600%5Ecompr-r85/1748/174807175/KALUNS+24-Piece+Assorted+Kitchen+Utensil+Set.jpg'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Kitchen Utensils',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),

                  ],
                ),

                Divider(),
                const SizedBox(height: 10),

              ],
            ),

          )
      /*StreamBuilder<QuerySnapshot>  (
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('status', isEqualTo:"live")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (!snapshot.hasData) {
              return
                Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ;
            }
            else {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,

                    childAspectRatio: 0.6,
                  ),

                  itemBuilder: (context, index) {

                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return
                      GestureDetector(
                        onTap: ()async{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(id: doc['productId'],)));
                        },
                        child:

                        Container(



                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          doc['imageUrl'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 13.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 3,
                                        ),

                                        Text(
                                          doc['name'],
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          doc['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("K"+ (doc['price']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+'.00',
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],


                              ),



                            ],
                          ),
                        ),

                      );

                  }
              );
            }
          })*/
          :_selectedIndex == 1
          ?
      Container(



        child:


        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Text("Electronics",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SecondaryDarkGrey)),
        ),


              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(

                      children:[
                        Container(
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(7),
                          ),
                          margin: EdgeInsets.all(10.0),
                          child: new ClipRRect(
                            borderRadius: new BorderRadius.circular(10.0),
                            child: new Image(
                              image: new NetworkImage('https://p2-ofp.static.pub/fes/cms/2021/04/28/odtbtgltop8fb3ytjpdy4orxz9a3l7232523.jpg'),
                              height: 60,
                              width:60,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text('Lenevo LP',
                          style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                      ]
                  ),

                  Column(

                      children:[
                        Container(
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(7),
                          ),
                          margin: EdgeInsets.all(10.0),
                          child: new ClipRRect(
                            borderRadius: new BorderRadius.circular(10.0),
                            child: new Image(
                              image: new NetworkImage('https://cdn.shopify.com/s/files/1/0409/7245/products/skyblue_26f13da0-a8df-496a-a86a-bdeb3e844223_1024x1024.png?v=1603977357'),
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text('IPhones',
                          style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                      ]
                  ),



                ],
              ),


      ]))
     /* StreamBuilder<QuerySnapshot>  (
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('status', isEqualTo:"live")
          .where('category', isEqualTo:"electronics")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (!snapshot.hasData) {
              return
                Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ;
            }
            else {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,

                    childAspectRatio: 0.6,
                  ),

                  itemBuilder: (context, index) {

                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return
                      GestureDetector(
                        onTap: ()async{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(id: doc['productId'],)));
                        },
                        child:

                        Container(



                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          doc['imageUrl'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 13.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 3,
                                        ),

                                        Text(
                                          doc['name'],
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          doc['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("K"+ (doc['price']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+'.00',
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],


                              ),



                            ],
                          ),
                        ),

                      );

                  }
              );
            }
          })*/
          :
      _selectedIndex == 2
          ?
      Container(



          child:


          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Text("Furniture",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: SecondaryDarkGrey)),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://www.homelane.com/blog/wp-content/uploads/2021/11/shutterstock_735847378.jpg'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Sofa Sets',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://cdn.shopify.com/s/files/1/0075/2815/3206/products/FRAND02.jpg?v=1576271268'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Dinning Tables',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),


                  ],
                ),



              ]))
     /* StreamBuilder<QuerySnapshot>  (
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('status', isEqualTo:"live")
          .where('category', isEqualTo: 'furniture')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (!snapshot.hasData) {
              return
                Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ;
            }
            else {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,

                    childAspectRatio: 0.6,
                  ),

                  itemBuilder: (context, index) {

                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return
                      GestureDetector(
                        onTap: ()async{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(id: doc['productId'],)));
                        },
                        child:

                        Container(



                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          doc['imageUrl'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 13.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 3,
                                        ),

                                        Text(
                                          doc['name'],
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          doc['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("K"+ (doc['price']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+'.00',
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],


                              ),



                            ],
                          ),
                        ),

                      );

                  }
              );
            }
          })*/
          :
      _selectedIndex == 3
          ?
      Container(



          child:


          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Text("Fashion",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: SecondaryDarkGrey)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [


                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://media.istockphoto.com/photos/blue-chino-pants-with-brown-leather-belt-isolated-on-white-background-picture-id1149139165?k=20&m=1149139165&s=612x612&w=0&h=GZNt8WgiJ3tSbVmcAKbIUmFAzbulMTw1NJ7msG2Tyno='),
                                height: 60,
                                width:60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Trousers',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://dpegb9ebondhq.cloudfront.net/product_photos/85797283/file_335a51ac92_original.jpg'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Shoes',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://i.pinimg.com/originals/8e/5f/86/8e5f86f5290eec3f09db5e405b25e07a.png'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Dresses',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),

                  ],
                ),



              ]))
      /*StreamBuilder<QuerySnapshot>  (
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('status', isEqualTo:"live")
              .where('category', isEqualTo: "fashion")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (!snapshot.hasData) {
              return
                Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ;
            }
            else {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,

                    childAspectRatio: 0.6,
                  ),

                  itemBuilder: (context, index) {

                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return
                      GestureDetector(
                        onTap: ()async{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(id: doc['productId'],)));
                        },
                        child:

                        Container(



                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          doc['imageUrl'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 13.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 3,
                                        ),

                                        Text(
                                          doc['name'],
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          doc['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("K"+ (doc['price']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+'.00',
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],


                              ),



                            ],
                          ),
                        ),

                      );

                  }
              );
            }
          })*/
          :
      _selectedIndex == 4
          ?
      Container(



          child:


          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Text("Baby",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: SecondaryDarkGrey)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [


                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://babyshopnigeria.com/wp-content/uploads/2018/10/61ROw2YmqfL._SL1000_.jpg'),
                                height: 60,
                                width:60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Baby Net',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),
                    Column(

                        children:[
                          Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: new ClipRRect(
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Image(
                                image: new NetworkImage('https://www.keeltoys.com/wp-content/uploads/2013/10/SN0513-775x857.jpg'),
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text('Dolls',
                            style: TextStyle(color: iconBlueDark, fontWeight: FontWeight.bold),)
                        ]
                    ),


                  ],
                ),



              ]))
     /* StreamBuilder<QuerySnapshot>  (
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('status', isEqualTo:"live")
          .where('category', isEqualTo: 'baby')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (!snapshot.hasData) {
              return
                Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ;
            }
            else {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,

                    childAspectRatio: 0.6,
                  ),

                  itemBuilder: (context, index) {

                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return
                      GestureDetector(
                        onTap: ()async{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(id: doc['productId'],)));
                        },
                        child:

                        Container(



                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          doc['imageUrl'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 13.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 3,
                                        ),

                                        Text(
                                          doc['name'],
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          doc['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("K"+ (doc['price']).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')+'.00',
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],


                              ),



                            ],
                          ),
                        ),

                      );

                  }
              );
            }
          })*/
          :
      SizedBox(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom -
            50,
      ),

    ])
          )
      )
    ])

    );
  }
}
