import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String imageUrl;
  final String fullName;
  final String phoneNumber;
  final String role;
  final String status;
  final String dateAdded;

  const Customer({
    required this.id,
    required this.imageUrl,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    required this.status,
    required this.dateAdded,
  });

  static Customer fromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
      id: snapshot.id,
      imageUrl: snapshot['imageUrl'],
      fullName: snapshot['fullName'],
      phoneNumber: snapshot['phoneNumber'],
      role: snapshot['userRole'],
      status: snapshot['userStatus'],
      dateAdded: snapshot['dateAdded'],
    );
  }

  @override
  List<Object> get props =>
      [id, fullName, phoneNumber, imageUrl, role, status, dateAdded];
}
