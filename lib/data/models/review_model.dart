import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String objectId;
  final String reviewType;
  final String reviewId;
  final String likes;
  final String rating;
  final String description;
  final String buyerId;
  final String createdAt;

  const Review({
    required this.id,
    required this.objectId,
    required this.reviewType,
    required this.description,
    required this.createdAt,
    required this.likes,
    required this.rating,
    required this.reviewId,
    required this.buyerId,
  });

  static Review fromSnapShot(DocumentSnapshot data) {
    Review reviews = Review(
      id: data.id,
      objectId: data['objectId'],
      reviewType: data['reviewType'],
      description: data['description'],
      createdAt: data['createdAt'],
      reviewId: data['reviewId'],
      rating: data['rating'],
      likes: data['likes'],
      buyerId: data['buyerId'],
    );

    return reviews;
  }

  List<Object> get props => [
        id,
        objectId,
        reviewType,
        reviewId,
        likes,
        rating,
        description,
        createdAt,
        buyerId,
      ];
}
