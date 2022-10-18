import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderDetailsView extends StatefulWidget {

  OrderDetailsView({Key? key, required this.id2}) : super(key: key);
  String id2;


  @override
  _OrderDetailsViewState createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {

  final List<String> _condition = ["Pending", "Confirmed", "Cancelled"];
  String? _conditionSelectedValue;
  CollectionReference products = FirebaseFirestore.instance.collection('orders');

  Future <void> putofflineproducts(){
    return  products.doc(widget.id2).update({

      'orderStatus': _conditionSelectedValue,


    }).then((value) =>
        print(
            'Product is Offline'
        ))
        .catchError((error)=>
        print(
            '$error'
        ));

  }

  Future <void> UpdateOrderStatus(){
    return  FirebaseFirestore.instance.collection('orders').doc(widget.id2).update({

      'orderStatus': _conditionSelectedValue,

    }).then((value) =>
        print(
            'Order Updated'
        ))
        .catchError((error)=>
        print(
            '$error'
        ));

  }
  void ConfirmBottomSheet(context){
    showModalBottomSheet(context: context,
        builder:(BuildContext bc)
    {
      return Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(


            children: [

              Row(
                children: [

                  Text('Choose payment progress',style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold)),

                  Spacer(),
                  IconButton(
                      onPressed: (){

                        Navigator.of(context).pop();
                  },
                      icon: Icon(Icons.cancel, color: Color(0xff17259C), size: 25,))
                ],
              ),
              SizedBox(height: 20,),
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
                          isEmpty: _conditionSelectedValue == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Condition'),
                              value: _conditionSelectedValue,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _conditionSelectedValue = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _condition.map((String value) {
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
              SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: (){

                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),


            const SizedBox(
              width: 10,
            ),

    Expanded(
    child: OutlinedButton(
    onPressed: () =>{

    putofflineproducts()
    }, child: Text('Save'),
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: PrimaryBlueOcean,
        ),))
]
            )


            ],
          ),
        ),
      );
    });
  }
  String addressid = "";
String order_id = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Order Item"),
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

          order_id = doc['Oid'];
          addressid = doc['addressId'];

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


                        Container(
                          height: 25,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:greenColor,

                              side: BorderSide(
                                color: greenColor,), //<-- SEE HERE
                            ),
                            onPressed: (){


                           ConfirmBottomSheet(context);
                            },
                            child: Text('Confirm Payment',
                              style: TextStyle(fontSize: 15,
                                color: Color(0xffffffff),),),
                          ),
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
                StreamBuilder<QuerySnapshot>  (
                    stream: FirebaseFirestore.instance
                        .collection('address').
                    where('Aid', isEqualTo: addressid)

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

                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [




                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doc['name'],
                                            style: const TextStyle(
                                                fontSize: textMedium,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            doc['phone'],
                                            style: const TextStyle(
                                                fontSize: textMedium,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            doc['address'],
                                            style: const TextStyle(
                                                fontSize: textMedium,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            doc['city'],
                                            style: const TextStyle(
                                                fontSize: textMedium,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),

                                      IconButton(
                                        onPressed: () =>{ },
                                        icon: SvgPicture.asset(
                                          "assets/icons/right.svg",
                                          color: PrimaryBlueOcean,
                                          height: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                              ;

                            });}

                    }
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
                        doc['buyername'],
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

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(

      title: const Text('Confirm Payment'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Choose your option for order Transaction"),
        ],
      ),
      actions: <Widget>[

        GestureDetector(
/*onTap: ()=>{
      Confirm(
          widget.id2
      )
    },*/
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: greenColor,
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: textSmall,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GestureDetector(

          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.amberAccent,
            ),
            child: const Text(
              "In Progress",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: textSmall,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

        GestureDetector(

          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey,
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: textSmall,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),


      ],
    );
  }
}

class PaymentWidget extends StatelessWidget {
  /*const PaymentWidget(
      {Key? key, required this.paymentMethod, required this.totalAmount})
      : super(key: key);
  final String paymentMethod;
  final String totalAmount;*/

  @override
  Widget build(BuildContext context) {
    return
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
          const SizedBox(
            height: 20,
          ),
          Text(
            "Paid using  Airtel Money" /*+ paymentMethod*/,
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
                "K12, 000",
                style: const TextStyle(
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



class OrderIDWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return

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
                    'Success',
                    style: const TextStyle(
                        fontSize: textMedium, fontWeight: FontWeight.w600),
                  ),

                  InkWell(
                    onTap: () {
                      showPaymentDialog;
                    },
                    child:
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: greenColor,
                      ),
                      child: const Text(
                        "Confirm Payment",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: textSmall,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDeliveryDialog;
                    },
                    child:
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: greenColor,
                        ),
                        child: const Text(
                          "Confirm delivery",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: textSmall,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showPaymentDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed:  () async {

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Payment"),
      content: const Text("Would you like to confirm the payment of this order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeliveryDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed:  () async {

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Delivery"),
      content: const Text("Would you like to confirm the delivery of this order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

