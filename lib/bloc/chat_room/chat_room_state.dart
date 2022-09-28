part of 'chat_room_bloc.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();

  @override
  List<Object> get props => [];
}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final List<ChatRoom> chatRooms;

  const ChatRoomLoaded({this.chatRooms = const <ChatRoom>[]});

  @override
  List<Object> get props => [chatRooms];
}
