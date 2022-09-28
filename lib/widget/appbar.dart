import 'package:flutter/material.dart';

Widget appBar (BuildContext context){

  return Center(
    child: RichText(
        text: TextSpan(

            style: TextStyle(fontSize: 18),

            children: <TextSpan>[
              TextSpan(text:'Order Confirmation' , style:TextStyle(
                 color: Colors.white,fontFamily: 'RoyalEstelleDemoRegular',
              ) ),


            ]
        )
    ),
  );
}