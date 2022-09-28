import 'package:chat2/helpers/constants.dart';
import 'package:flutter/material.dart';

class StarredProducts extends StatefulWidget {
  const StarredProducts({Key? key}) : super(key: key);

  @override
  State<StarredProducts> createState() => _StarredProductsState();
}

class _StarredProductsState extends State<StarredProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBgColor,
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Follows"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),
    );
  }
}
