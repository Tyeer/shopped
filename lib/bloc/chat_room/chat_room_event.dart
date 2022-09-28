part of 'chat_room_bloc.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object> get props => [];
}

class LoadChatRooms extends ChatRoomEvent {
  final String userId;

  const LoadChatRooms({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadChatRoomsSuccess extends ChatRoomEvent {
  final List<ChatRoom> chatRooms;

  const LoadChatRoomsSuccess(this.chatRooms);

  @override
  List<Object> get props => [chatRooms];
}
