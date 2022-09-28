import 'package:flutter/material.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/main.dart';
import 'package:chat2/AuthScreens/register_account_as_buyer_view.dart';
import 'package:chat2/AuthScreens/register_account_as_seller_view.dart';


class RegisterAsView extends StatefulWidget {
  const RegisterAsView({Key? key}) : super(key: key);

  @override
  State<RegisterAsView> createState() => _RegisterAsViewState();
}

class _RegisterAsViewState extends State<RegisterAsView> {
  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton(String label) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => RegisterSellerView())),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: PrimaryBlueOcean,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
  Widget _submitButton2(String label) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => RegisterBuyerView())),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: PrimaryBlueOcean,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }



  Widget _title() {
    return Text("Register As",
        style: TextStyle(
          fontSize: textLarge,
          fontWeight: FontWeight.w700,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding:   const EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                    child:

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 150),
                        _title(),
                        SizedBox(height: 37),
                        _submitButton2("Buyer"),
                        SizedBox(height: 10),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: paddingHorizontal),
                          child: Text(
                            "Buy from mutiple shops \nValid phone number \nRefund for unwanted products \nSecure payment through shopped",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 51),
                        _submitButton("Seller & Buyer"),
                        SizedBox(height: 10),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: paddingHorizontal),
                          child: Text(
                            "Buy to mutiple customers \nBuy from mutiple shops \nValid phone number \nGranted payment reciept through shopped\n2.5% commission on every sold products",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),


              ],
            ),
          ),
        )

    );
  }
}
