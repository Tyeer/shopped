import 'package:chat2/ProductScreens/ProductDetails.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  SearchProduct({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  String name2 = "";
  var scafoldkey =  new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        key: scafoldkey,
        endDrawer: FilterProduct(),
      appBar: AppBar(

          title: Card(
            color: Colors.white,
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
              onTap: () async {

              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('status', isEqualTo:"live")
                        .where('name', isEqualTo: widget.id)
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
      Column(
          children: <Widget>[

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products')
                  .where('status', isEqualTo:"live")
              .where('name', isEqualTo: widget.id)
                  .snapshots(),
              builder: (context, snapshots) {
                return (snapshots.connectionState == ConnectionState.waiting)
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    :
                GridView.builder(

                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {

    DocumentSnapshot doc = snapshots.data!.docs[index];

    if (name2.isEmpty) {
      return
        GestureDetector(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductDetails(id: doc['productId'],)));
          },
          child:
          Row(
            children: [
              Container(

                width: 185,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      bottom: 10,
                      child: Container(
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.favorite_border_outlined, size: 20, color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom:0,
                      child: Container(
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                            '  10'

                        ),
                      ),
                    ),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 13.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 3,
                              ),

                              Text(
                                doc['name'],
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
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
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("K" +
                                  (doc['price']).toString().replaceAllMapped(
                                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (
                                      Match m) => '${m[1]},') + '.00',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
    if ( doc['name'].toString().startsWith(name2.toLowerCase())){
      GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProductDetails(id: doc['productId'],)));
        },
        child:
        Row(
          children: [
            Container(

              width: 185,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xfff2f2f2),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite_border_outlined, size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1,
                    bottom: 20,
                    child: Container(
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                          '  10'

                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 140,
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
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),

                            Text(
                              doc['name'],
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("K" +
                                (doc['price']).toString().replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (
                                    Match m) => '${m[1]},') + '.00',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
    }



                );
              },
            )
          ])

    ])
    );
  }
}

class FilterProduct extends StatefulWidget {
  const FilterProduct({Key? key}) : super(key: key);

  @override
  State<FilterProduct> createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  final List<String> _statusList = ["All", "Lilongwe", "Blantyre", "Mzuzu", "Zomba"];
  List<String> _categories = ["House", "Electronics", "Furniture", "Car", "Clothing", "Shoes"];
  String? _statusSelectedValue;
  String? _categorySelectedValue;
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
                            isEmpty: _categorySelectedValue == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: const Text('Category'),
                                value: _categorySelectedValue,
                                isDense: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _categorySelectedValue = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: _categories.map((String value) {
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

