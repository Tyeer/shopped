import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FeaturedProduct extends Equatable {
  final String id;
  final String productId;
  final String dateAdded;

  const FeaturedProduct({required this.id, required this.productId, required this.dateAdded});

  static FeaturedProduct fromSnapShot(DocumentSnapshot data) {
    return FeaturedProduct(
      id: data['id'],
      productId: data['productId'],
      dateAdded: data['dateAdded'],
    );
  }

  @override
  List<Object> get props => [id, productId, dateAdded];
}
