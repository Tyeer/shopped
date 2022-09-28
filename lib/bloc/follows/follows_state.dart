part of 'follows_bloc.dart';

abstract class FollowsState extends Equatable {
  const FollowsState();

  @override
  List<Object> get props => [];
}

class FollowsLoading extends FollowsState {}

class FollowsLoaded extends FollowsState {
  final List<Follows> follows;

  const FollowsLoaded({this.follows = const <Follows>[]});

  @override
  List<Object> get props => [follows];
}
