import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String userId;
  final String createdAt;

  const Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.userId,
    required this.createdAt,
  });

  static Address fromSnapShot(DocumentSnapshot snapshot) {
    return Address(
      id: snapshot['addressId'],
      name: snapshot['name'],
      phone: snapshot['phone'],
      address: snapshot['address'],
      email: snapshot['email'],
      city: snapshot['city'],
      userId: snapshot['userId'],
      createdAt: snapshot['createdAt'],
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        phone,
        address,
        city,
        userId,
        email,
        createdAt,
      ];
}
