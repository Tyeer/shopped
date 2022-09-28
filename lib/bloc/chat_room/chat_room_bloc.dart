import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final Repository _chatRoomRepository;
  StreamSubscription? _chatRoomSubscription;

  ChatRoomBloc({required Repository chatRoomRepository})
      : _chatRoomRepository = chatRoomRepository,
        super(ChatRoomLoading()) {
    on<LoadChatRooms>(_onLoadChatRooms);
    on<LoadChatRoomsSuccess>(_onLoadChatRoomsSuccess);
  }

  void _onLoadChatRooms(LoadChatRooms event, Emitter<ChatRoomState> emit) {
    _chatRoomSubscription?.cancel();

  }

  void _onLoadChatRoomsSuccess(
      LoadChatRoomsSuccess event, Emitter<ChatRoomState> emit) {
    emit(ChatRoomLoaded(chatRooms: event.chatRooms));
  }
}
