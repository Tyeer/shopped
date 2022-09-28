part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class LoadReviews extends ReviewEvent {
  final String objectId;
  final String reviewType;

  const LoadReviews({required this.objectId, required this.reviewType});

  @override
  List<Object> get props => [objectId, reviewType];
}

class UpdateReviews extends ReviewEvent {
  final List<Review> reviews;

  const UpdateReviews(this.reviews);

  @override
  List<Object> get props => [reviews];
}
