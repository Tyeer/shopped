import 'package:chat2/ProductScreens/ProductDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {


  CollectionReference starredproduct = FirebaseFirestore.instance.collection('history');
  Future<void> deleteHistory(id){
    return starredproduct.doc(id).delete().then((value) => print('Product deleted successfully')).catchError((error)=>print('Failed to delete Product: $error'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          centerTitle: true,
          title: const Text("History"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),

body: Container(
  child: ListView(
    children: [

      SizedBox(height: 10,),

    StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('history')
        .where('Uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid )
    .limit(30)
        .snapshots(),
    builder: (context, snapshot) {

    if (!snapshot.hasData) {
    return Center(child: CircularProgressIndicator());
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
      return Container(
      height: 80,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white38,

      ),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      GestureDetector(
        onTap:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return ProductDetails(
              id: doc['productid'],

            );
          }));
        },
        child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Colors.blue,
        image: DecorationImage(
        image: NetworkImage(
        doc['image'],
        ),
        fit: BoxFit.cover,
        ),
        ),
        ),
      ),
      SizedBox(
      width: 8,
      ),
      Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
      Text(



      doc['name'],
      style: Theme
          .of(context)
          .textTheme
          .headline3!
          .copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      ),
      ),
      Text(
         "Mwk "+ doc['price'].toString(),
        style: Theme
            .of(context)
            .textTheme
            .bodyText1,
        ),



      ],
      ),
      const Spacer(),
      Expanded(
      child: Column(
      children: [
      SizedBox(
      height: 5,
      ),
      Text(
      doc['Date Ordered'],
      style: Theme
          .of(context)
          .textTheme
          .bodyText1,
      ),

        IconButton(

          onPressed: (){
            deleteHistory(doc['Hid']);
          },

          icon: Icon(
            Icons.delete_outlined,
            color: Colors.red,
          ),)
      ],
      ),
      ),
      ],
      ),
      );
      });
    }
    }
    )
    ],
  ),
),
    );
  }
}
