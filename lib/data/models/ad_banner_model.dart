import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AdBanner extends Equatable {
  final String id;
  final String image;

  const AdBanner({required this.id, required this.image});

  static AdBanner fromSnapShot(DocumentSnapshot data) {
    return AdBanner(
      id: data['id'],
      image: data['imageUrl'],
    );
  }

  @override
  List<Object> get props => [id, image];
}
