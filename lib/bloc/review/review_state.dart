part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewInitial extends ReviewState {
  final String message = "No reviews yet";

  @override
  List<Object> get props => [message];
}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;

  const ReviewLoaded({this.reviews = const <Review>[]});

  @override
  List<Object> get props => [reviews];
}
