import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final Repository _reviewRepository;
  StreamSubscription? _reviewSubscription;

  ReviewBloc({required Repository reviewRepository})
      : _reviewRepository = reviewRepository,
        super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<UpdateReviews>(_onUpdateReviews);
  }

  void _onLoadReviews(
    LoadReviews event,
    Emitter<ReviewState> emit,
  ) {
    _reviewSubscription?.cancel();
    _reviewSubscription = _reviewRepository
        .getAllReviews(event.objectId, event.reviewType)
        .listen(
          (reviews) => add(UpdateReviews(reviews)),
        );
  }

  void _onUpdateReviews(
    UpdateReviews event,
    Emitter<ReviewState> emit,
  ) {
    emit(ReviewLoaded(reviews: event.reviews));
  }
}
