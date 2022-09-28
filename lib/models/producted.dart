import 'package:flutter/material.dart';

class Producted {
  final String image, title, description;
  final int price, size, id;
  final Color color;
  Producted({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.size,
    required this.color,
  });
}

List<Producted> products = [
  Producted(
      id: 1,
      title: "Office Code",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/product.jpg",
      color: Color(0xFF3D82AE)),
  Producted(
      id: 2,
      title: "Belt Bag",
      price: 234,
      size: 8,
      description: dummyText,
      image: "assets/product.jpg",
      color: Color(0xFFD3A984)),
  Producted(
      id: 3,
      title: "Hang Top",
      price: 234,
      size: 10,
      description: dummyText,
      image: "assets/product.jpg",
      color: Color(0xFF989493)),
  Producted(
      id: 4,
      title: "Old Fashion",
      price: 234,
      size: 11,
      description: dummyText,
      image: "assets/product.jpg",
      color: Color(0xFFE6B398)),
  Producted(
      id: 5,
      title: "Office Code",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/product.jpg",
      color: Color(0xFFFB7883)),
  Producted(
    id: 6,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/product.jpg",
    color: Color(0xFFAEAEAE),
  ),
];

String dummyText = "Lorem Ipsum is simply dummy .";
