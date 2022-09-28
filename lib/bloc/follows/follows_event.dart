part of 'follows_bloc.dart';

abstract class FollowsEvent extends Equatable {
  const FollowsEvent();

  @override
  List<Object> get props => [];
}

class LoadFollows extends FollowsEvent {
  final String sellerId;

  const LoadFollows({required this.sellerId});

  @override
  List<Object> get props => [sellerId];
}

class UpdateFollows extends FollowsEvent {
  final List<Follows> follows;

  const UpdateFollows(this.follows);

  @override
  List<Object> get props => [follows];
}
