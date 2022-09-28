import 'package:chat2/ProductScreens/SearchProduct.dart';
import 'package:chat2/ProductScreens/SearchSeller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
String name = "";
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Card(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          )),
        body:ListView(
            children: [
        BottomSection()
        ,
])

    );
  }
}

class BottomSection extends StatefulWidget {
  @override
  _BottomSectionState createState() => new _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection>
    with TickerProviderStateMixin {
  late List<Tab> _tabs;
  late List<Widget> _pages;
  late TabController _controller;

  @override
  void initState() {

    super.initState();
    _tabs = [
      new Tab(child: Text('Products', style: TextStyle(color: Color(0xff016DD1)),), ),

      new Tab(child: Text('Seller', style: TextStyle(color: Color(0xff016DD1)),),),
    ];
    _pages = [
      Gallery(),
      About(),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            indicatorColor: Color(0xff016DD1),
            controller: _controller,
            tabs: _tabs,
            labelColor: Theme.of(context).accentColor,
            labelStyle: TextStyle(
              color: Color(0xff016DD1),
            ),

          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(3000.0),

            child: new TabBarView(

              controller: _controller,

              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}

//==============================================================================

//===================
// Build Gallery Tab
//===================
class Gallery extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
        child: new ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {

                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text(
                                'Available Information',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 10,),



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
                            return CircularProgressIndicator();
                          }
                          else {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),


                                itemBuilder: (context, index) {

                                  DocumentSnapshot doc = snapshot.data!.docs[index];

                                  if (name.isEmpty) {
                                    return
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SearchProduct(
                                                              id: doc['name'],
                                                            )));
                                              },
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  SvgPicture.network(
                                                    "https://www.svgrepo.com/show/13682/search.svg",
                                                    height: 20,

                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    doc['name'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ;
                                  }

                                  if ( doc['name'].toString().startsWith(name.toLowerCase())){
                                    return
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SearchProduct(
                                                              id: name,
                                                            )));
                                              },
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  SvgPicture.network(
                                                    "https://www.svgrepo.com/show/13682/search.svg",
                                                    height: 20,

                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    doc['name'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ;

                                  }
                                  return Container();
                                }
                            );
                          }
                        }),




                  ],
                ),
              ),

            ])
    );




  }
}


class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return new Container(
 child: ListView(
   children: [

     Padding(
       padding: const EdgeInsets.all(20),
       child: Column(
         children: [


           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               InkWell(
                 onTap: () async {

                 },
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [

                     Text(
                       'Available Information',
                       style: TextStyle(
                           fontSize: 15,
                           color: Colors.black54,
                           fontWeight: FontWeight.bold),
                     ),
                   ],
                 ),
               ),

             ],
           ),



           SizedBox(height: 10,),
           StreamBuilder<QuerySnapshot>  (
               stream: FirebaseFirestore.instance
                   .collection('users')
                   .where('Type', isEqualTo: 'Seller')
                   .snapshots(),
               builder: (context, snapshot) {
                 if (snapshot.hasError) {
                   return Text("Something went wrong");
                 }
                 if (!snapshot.hasData) {
                   return CircularProgressIndicator();
                 }
                 else {
                   return ListView.builder(
                       itemCount: snapshot.data!.docs.length,
                       scrollDirection: Axis.vertical,
                       shrinkWrap: true,
                       physics: ClampingScrollPhysics(),


                       itemBuilder: (context, index) {

                         DocumentSnapshot doc = snapshot.data!.docs[index];

                         if (name.isEmpty) {
                           return
                             Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment
                                     .spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment
                                     .center,
                                 children: [
                                   InkWell(
                                     onTap: () async {
                                       Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) =>
                                                   SearchSeller(
id: doc['Fullname'],
                                                   )));
                                     },
                                     child: Row(
                                       crossAxisAlignment: CrossAxisAlignment
                                           .center,
                                       children: [
                                         SvgPicture.network(
                                           "https://www.svgrepo.com/show/13682/search.svg",
                                           height: 20,

                                           color: Colors.grey,
                                         ),
                                         const SizedBox(
                                           width: 10,
                                         ),
                                         Text(
                                           doc['Fullname'],
                                           style: TextStyle(
                                               fontSize: 20,
                                               color: Colors.grey,
                                               fontWeight: FontWeight
                                                   .bold),
                                         ),
                                       ],
                                     ),
                                   ),

                                 ],
                               ),
                             )
                           ;
                         }

                         if ( doc['Fullname'].toString().startsWith(name.toLowerCase())){
                           return
                             Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment
                                     .spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment
                                     .center,
                                 children: [
                                   InkWell(
                                     onTap: () async {
                                       Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) =>
                                                   SearchSeller(
                                                     id: name,
                                                   )));
                                     },
                                     child: Row(
                                       crossAxisAlignment: CrossAxisAlignment
                                           .center,
                                       children: [
                                         SvgPicture.network(
                                           "https://www.svgrepo.com/show/13682/search.svg",
                                           height: 20,

                                           color: Colors.grey,
                                         ),
                                         const SizedBox(
                                           width: 10,
                                         ),
                                         Text(
                                           doc['Fullname'],
                                           style: TextStyle(
                                               fontSize: 20,
                                               color: Colors.grey,
                                               fontWeight: FontWeight
                                                   .bold),
                                         ),
                                       ],
                                     ),
                                   ),

                                 ],
                               ),
                             )
                           ;

                         }
                         return Container();
                       }
                   );
                 }
               }),

         ],
       ),
     ),

   ],
 ),
    );
  }
}
