import 'package:chat2/ProductScreens/ProductDetails.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchSeller extends StatefulWidget {
  SearchSeller({Key? key, required this.id}) : super(key: key);
 String id;
  @override
  State<SearchSeller> createState() => _SearchSellerState();
}

class _SearchSellerState extends State<SearchSeller> {
  var scafoldkey =  new GlobalKey<ScaffoldState>();
  String name2 = "";
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scafoldkey,
endDrawer: new FilterSeller(),
      appBar: AppBar(
          title: Card(
            child: TextFormField(
              initialValue: widget.id,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search here'),
              onChanged: (val) {
                setState(() {
                  name2 = val;
                });
              },
            ),
          )),

    body:ListView(
    children: [

      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('Fullname', isEqualTo: widget.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return
                          Text(
                            snapshot.data!.docs.length .toString() + ' Items',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                     }
                    },
                  ),


                ],
              ),
            ),
            InkWell(
              onTap: () async {
                scafoldkey.currentState!.openEndDrawer();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Filter",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
 SizedBox(height:10),







              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


    StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')

        .where('Fullname', isEqualTo: widget.id)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError){
        return Center(
          child: Text('something went wrong'),
        );
      }
    if (!snapshot.hasData) {
    return CircularProgressIndicator();
    } else {
    return ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),

    itemCount: snapshot.data!.docs.length,
    itemBuilder: (context, index) {
      DocumentSnapshot doc = snapshot.data!.docs[index];

    if (name2.isEmpty) {
      return
GestureDetector(
  child:
        Container(

            padding: const EdgeInsets.all(paddingHorizontal),
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(doc['userImage']),
                      ),
                      const SizedBox(
                        width: 20,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['Fullname'].toString(),
                            style: const TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['Location'].toString(),
                                style: const TextStyle(
                                    color: SecondaryDarkGrey,
                                    fontSize: textMedium),
                              ),
                              SizedBox(width: 50,),
                              Text(doc['DateJoined'].toString(),
                                  style: const TextStyle(
                                      color: SecondaryDarkGrey,
                                      fontSize: textMedium)),
                              SizedBox(width: 50,),
                              Text(doc['followers'].toString(),
                                  style: const TextStyle(
                                      color: SecondaryDarkGrey,
                                      fontSize: textMedium)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(

                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: new ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[

                            StreamBuilder<QuerySnapshot>  (
                                stream: FirebaseFirestore.instance
                                    .collection('products')
                                    .where('sellerId', isEqualTo: doc['Uid'])
                                    .snapshots(),
                                builder: (context, snapshot) {

                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  }
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  }
                                  else {

                                    return    ListView.builder(
                                        itemCount: snapshot.data!.docs.length,

                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot docc = snapshot.data!.docs[index];
                                          return GestureDetector(

                                            onTap: ()async{
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ProductDetails(id: docc['productId'],)));
                                            },

                                            child: Column(

                                                children:[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      borderRadius: BorderRadius.circular(7),
                                                    ),
                                                    margin: EdgeInsets.all(10.0),
                                                    child: new ClipRRect(
                                                      borderRadius: new BorderRadius.circular(10.0),
                                                      child: new Image(
                                                        image: new NetworkImage(docc['imageUrl']),
                                                        height: 90,
                                                        width: 90,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Text('K'+ docc['price'] + '.00',
                                                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),)
                                                ]
                                            ),
                                          );

                                        }

                                    );}})

                          ]))
                ])
        )
);
    }
    if ( doc['Fullname'].toString().startsWith(name2.toLowerCase())){
      GestureDetector(

        child: Container(

            padding: const EdgeInsets.all(paddingHorizontal),
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(doc['userImage']),
                      ),
                      const SizedBox(
                        width: 20,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['Fullname'].toString(),
                            style: const TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['location'].toString(),
                                style: const TextStyle(
                                    color: SecondaryDarkGrey,
                                    fontSize: textMedium),
                              ),
                              SizedBox(width: 50,),
                              Text(doc['DateJoined'].toString(),
                                  style: const TextStyle(
                                      color: SecondaryDarkGrey,
                                      fontSize: textMedium)),
                              SizedBox(width: 50,),
                              Text(doc['followers'].toString(),
                                  style: const TextStyle(
                                      color: SecondaryDarkGrey,
                                      fontSize: textMedium)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(

                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: new ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[

                            StreamBuilder<QuerySnapshot>  (
                                stream: FirebaseFirestore.instance
                                    .collection('products')
                                    .where('sellerId', isEqualTo: doc['Uid'])
                                    .snapshots(),
                                builder: (context, snapshot) {

                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  }
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  }
                                  else {

                                    return    ListView.builder(
                                        itemCount: snapshot.data!.docs.length,

                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot docc = snapshot.data!.docs[index];
                                          return GestureDetector(

                                            onTap: ()async{
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ProductDetails(id: docc['productId'],)));
                                            },

                                            child: Column(

                                                children:[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      borderRadius: BorderRadius.circular(7),
                                                    ),
                                                    margin: EdgeInsets.all(10.0),
                                                    child: new ClipRRect(
                                                      borderRadius: new BorderRadius.circular(10.0),
                                                      child: new Image(
                                                        image: new NetworkImage(docc['imageUrl']),
                                                        height: 90,
                                                        width: 90,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Text('K'+ docc['price'] + '.00',
                                                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),)
                                                ]
                                            ),
                                          );

                                        }

                                    );}})

                          ]))

                ])
        ),
      );
    }
      return Container();
    }
    );
    }}),





                ],
              ),






    ])
    );
  }
}

class FilterSeller extends StatefulWidget {
  const FilterSeller({Key? key}) : super(key: key);

  @override
  State<FilterSeller> createState() => _FilterSellerState();
}

class _FilterSellerState extends State<FilterSeller> {
  TextEditingController  min = new TextEditingController();
  TextEditingController  max = new TextEditingController();
  TextEditingController  location = new TextEditingController();

  final List<String> _statusList = ["All", "Lilongwe", "Blantyre", "Mzuzu", "Zomba"];

  String? _statusSelectedValue;
  @override
  Widget build(BuildContext context) {

    return new Drawer(
backgroundColor: Colors.white,
      child: new ListView(
        children: <Widget>[
          Padding(padding:EdgeInsets.all(20),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [Text('Price (K)',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),)],

      ),

      SizedBox(height: 10,),
      Row(
        children: [
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(

                    width: 100,
                    height: 30,
                    child: Container(
                      child: TextField(
                        controller: min,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                       //   hintText: "Min",
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ],
              ),
SizedBox(width: 6,),
              Text('-', style: TextStyle(),),
              SizedBox(width: 6,),
              Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(

                    width: 100,
                    height: 30,
                    child: Container(
                      child: TextField(
                        controller: max,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          ),

                         // hintText: "Max",
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 30,),
    ],
  ),


),

          Divider(height: 2,),
          Padding(padding:EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 16.0),
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            isEmpty: _statusSelectedValue == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: const Text('Location'),
                                value: _statusSelectedValue,
                                isDense: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _statusSelectedValue = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: _statusList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      )
                  ),
                ),
                SizedBox(height: 10,),


                SizedBox(height: 30,),
                Divider(height: 2,),
              ],
            ),

          ),
          SizedBox(height: 390,),
          Divider(height: 2,),

          Padding(padding:EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                SizedBox(height: 10,),
                Row(
                  children: [
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(

                              width: 110,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),

                                ),
                                child: Center(child: Text('Clear All',style: TextStyle(color:Colors.black45),),),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 6,),
                        Text('-', style: TextStyle(),),
                        SizedBox(width: 6,),
                        Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(

                              width: 110,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(15.0),

                                ),
                                child: Center(child: Text('Done', style: TextStyle(
                                  color: Colors.white,
                                ),),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30,),
              ],
            ),


          ),


        ],
      ),

    );
  }
}


