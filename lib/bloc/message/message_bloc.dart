import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Repository _messageRepository;
  StreamSubscription? _messageSubscription;

  MessageBloc({required Repository messageRepository})
      : _messageRepository = messageRepository,
        super(MessageLoading()) {
    on<LoadMessage>(_onLoadMessage);
    on<UpdateMessage>(_onUpdateMessage);
  }

  void _onLoadMessage(
    LoadMessage event,
    Emitter<MessageState> emit,
  ) {
    _messageSubscription?.cancel();

  }

  void _onUpdateMessage(
    UpdateMessage event,
    Emitter<MessageState> emit,
  ) {
    emit(MessageLoaded(messages: event.messages));
  }
}
