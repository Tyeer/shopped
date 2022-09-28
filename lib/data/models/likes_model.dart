import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Likes extends Equatable {
  final String id;
  final String objectId;
  final String userId;
  final String dateAdded;

  const Likes({
    required this.id,
    required this.objectId,
    required this.userId,
    required this.dateAdded,
  });

  static Likes fromSnapShot(DocumentSnapshot data) {
    Likes like = Likes(
      id: data.id,
      objectId: data['objectId'],
      userId: data['userId'],
      dateAdded: data['dateAdded'],
    );

    return like;
  }

  @override
  List get props => [id, objectId, userId, dateAdded];
}
