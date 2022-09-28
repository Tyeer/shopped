import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'follows_event.dart';
part 'follows_state.dart';

class FollowsBloc extends Bloc<FollowsEvent, FollowsState> {
  Repository _followsRepository;
  StreamSubscription? _followsSubscription;

  FollowsBloc({required Repository followsRepository})
      : _followsRepository = followsRepository,
        super(FollowsLoading()) {
    on<LoadFollows>(_onLoadFollows);
    on<UpdateFollows>(_onUpdateFollows);
  }

  void _onLoadFollows(
    LoadFollows event,
    Emitter<FollowsState> emit,
  ) {
    _followsSubscription?.cancel();


  }

  void _onUpdateFollows(
    UpdateFollows event,
    Emitter<FollowsState> emit,
  ) {
    emit(FollowsLoaded(follows: event.follows));
  }
}
