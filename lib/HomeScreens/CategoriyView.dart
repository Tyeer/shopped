import 'package:chat2/HomeScreens/Search.dart';
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
                  color: iconBlueDark,

                  height: 23.5,
                  // By default our  icon color is white
                ),
                const Text("All", style: TextStyle(fontSize: textSmall))
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
                const Text("All", style: TextStyle(fontSize: textSmall, color: iconBlueDark))
              ],
            ),
            label: Text(""),
          ),
          NavigationRailDestination(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    "assets/icons/device.svg",
                    color: iconBlueDark,
                    // By default our  icon color is white
                  ),
                  Text('Electronics', style: const TextStyle(fontSize: textSmall, color: iconBlueDark,))
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
                  SvgPicture.network(
                    "https://www.svgrepo.com/show/196892/phone-call-smartphone.svg",
                    color: iconBlueDark,
                    height: 20,

                    // By default our  icon color is white
                  ),
                  Text('Phone', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),
                  SizedBox(height: 5,),
                  SvgPicture.network(
                   "https://www.svgrepo.com/show/12668/computer.svg",
                    color: iconBlueDark,

                    height: 20,
                    // By default our  icon color is white
                  ),
                  Text('Computers', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),
                  SizedBox(height: 5,),
                  SvgPicture.network(
                    "https://www.svgrepo.com/show/425380/watch.svg",
                    color: iconBlueDark,

                    height: 20,
                    // By default our  icon color is white
                  ),
                  Text('Watches', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),
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
                    color: iconBlueDark,
                    // By default our  icon color is white
                  ),
                  Text('Furniture', style: const TextStyle(fontSize: textSmall, color: iconBlueDark,))
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
                  SvgPicture.network(
                    "https://www.svgrepo.com/show/53180/sofa.svg",
                    color: iconBlueDark,
                    height: 20,
                    // By default our  icon color is white
                  ),
                  Text('Sofa', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),
                  SvgPicture.network(
                    "https://www.svgrepo.com/show/112922/dinning-table.svg",
                    color: iconBlueDark,
                    height: 20,
                    // By default our  icon color is white
                  ),
                  Text('Dinning Table', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),
                  SvgPicture.network(
                    "https://www.svgrepo.com/show/14685/bed.svg",
                    color: iconBlueDark,
height: 20,
                    // By default our  icon color is white
                  ),
                  Text('Beds', style: const TextStyle(fontSize: textSmall, color: iconBlueDark))
                ],
              ),
              label: Text(""),
            ),
          NavigationRailDestination(
            icon: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/fashion.svg",
                  color: iconBlueDark,
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

                SvgPicture.network(
                  "https://www.svgrepo.com/show/119102/men-clothes.svg",
                  color: iconBlueDark,
height: 20,
                  // By default our  icon color is white
                ),
                Text('Men Cloths', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),

                SvgPicture.network(
                  "https://www.svgrepo.com/show/119102/men-clothes.svg",
                  color: iconBlueDark,
height: 20,
                  // By default our  icon color is white
                ),
                Text('Women Clothes', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),

                SvgPicture.network(
                  "https://www.svgrepo.com/show/136183/shoes.svg",
                  color: iconBlueDark,
height: 20,
                  // By default our  icon color is white
                ),
                Text('Shoes', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),

                SvgPicture.network(
                  "https://www.svgrepo.com/show/55164/jacket.svg",
                  color: iconBlueDark,
height: 20,
                  // By default our  icon color is white
                ),
                Text('Suits', style: const TextStyle(fontSize: textSmall, color: iconBlueDark)),
              ],
            ),
            label: Text(""),
          ),
          NavigationRailDestination(
            icon: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/baby.svg",
                  color: iconBlueDark,
                  // By default our  icon color is white
                ),
                Text('Baby', style: const TextStyle(fontSize: textSmall,color: iconBlueDark,))
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
      StreamBuilder<QuerySnapshot>  (
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
          })
          :_selectedIndex == 1
          ?
      StreamBuilder<QuerySnapshot>  (
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
          })
          :
      _selectedIndex == 2
          ?
      StreamBuilder<QuerySnapshot>  (
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
          })
          :
      _selectedIndex == 3
          ?
      StreamBuilder<QuerySnapshot>  (
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
          })
          :
      _selectedIndex == 4
          ?
      StreamBuilder<QuerySnapshot>  (
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
          })
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
