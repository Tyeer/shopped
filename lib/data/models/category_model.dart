import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CategoryProduct extends Equatable {
  final String id;
  final String name;

  const CategoryProduct({
    required this.id,
    required this.name,
  });

  factory CategoryProduct.fromSnapshot(DocumentSnapshot snap) {
    CategoryProduct category = CategoryProduct(
      id : snap['id'],
      name: snap['name'],
    );
    return category;
  }

  @override
  List<Object?> get props => [id, name];
}
