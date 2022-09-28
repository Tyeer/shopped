import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Seller extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String paymentMethod;
  final String phoneNumber;
  final String userStatus;
  final String location;
  final String imageUrl;
  final String createdAt;

  const Seller(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.paymentMethod,
      required this.phoneNumber,
      required this.userStatus,
      required this.location,
        required this.imageUrl,
      required this.createdAt});

  static Seller fromSnapShot(DocumentSnapshot snap) {
    Seller sellers = Seller(
        id: snap['sellerID'],
        email: snap['email'],
        paymentMethod: snap['paymentMethod'],
        fullName: snap['fullName'],
        phoneNumber: snap['phoneNumber'],
        userStatus: snap['sellerStatus'],
        location: snap['location'],
        imageUrl: snap['imageUrl'],
        createdAt: snap['createdAt']);
    return sellers;
  }

  @override
  List<Object> get props => [
        id,
        email,
        fullName,
        paymentMethod,
        phoneNumber,
        userStatus,
        location,
        imageUrl,
        createdAt
      ];
}
