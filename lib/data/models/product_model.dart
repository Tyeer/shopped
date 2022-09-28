import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String price;
  final String quantity;
  final String condition;
  final String sellerId;
  final String location;
  final String dateAdded;
  final String productStatus;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.quantity,
    required this.condition,
    required this.sellerId,
    required this.location,
    required this.productStatus,
    required this.dateAdded,
  });

  static Product fromSnapShot(DocumentSnapshot snap) {
    Product product = Product(
      id: snap.id,
      name: snap['name'],
      description: snap['description'],
      imageUrl: snap['imageUrl'],
      category: snap['category'],
      price: snap['price'],
      quantity: snap['quantity'],
      condition: snap['condition'],
      sellerId: snap['sellerId'],
      location: snap['location'],
        productStatus: snap['productStatus'],
      dateAdded: snap['dateAdded'],
    );
    return product;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'price': price,
      'quantity': quantity,
      'condition': condition,
      'sellerId': sellerId,
      'location': location,
      "productStatus": productStatus,
      "dateAdded" : dateAdded,
    };
  }

  @override
  List<Object> get props => [
        id,
        name,
        description,
        imageUrl,
        category,
        price,
        quantity,
        condition,
        sellerId,
        location,
        productStatus,
        dateAdded,
      ];
}
