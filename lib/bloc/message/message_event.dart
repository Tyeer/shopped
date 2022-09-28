part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessage extends MessageEvent {
  final String chatId;
  const LoadMessage({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class UpdateMessage extends MessageEvent {
  final List<Message> messages;

  const UpdateMessage(this.messages);

  @override
  List<Object> get props => [messages];
}
