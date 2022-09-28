import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Follows extends Equatable {
  final String id;
  final String sellerId;
  final String buyerId;
  final String createdAt;

  const Follows({
    required this.id,
    required this.sellerId,
    required this.buyerId,
    required this.createdAt,
  });

  static Follows fromSnapShot(DocumentSnapshot data) {
    Follows follows = Follows(
      id: data.id,
      sellerId: data['sellerId'],
      buyerId: data['buyerId'],
      createdAt: data['createdAt'],
    );

    return follows;
  }

  @override
  List get props => [id, sellerId, buyerId, createdAt];
}
