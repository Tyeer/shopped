import 'package:chat2/helpers/constants.dart';
import 'package:flutter/material.dart';

// We need satefull widget for our categories

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = [
    "All",
    "Electronics",
    "Furniture",
    "Fashion",
    "Baby"
  ];
  // By default our first item will be selected
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: selectedIndex == index ? activeTabColor : Colors.white,
            borderRadius: BorderRadius.circular(50)),
        child: Text(
          categories[index],
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: selectedIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
