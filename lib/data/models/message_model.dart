import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({
    required this.id,
    required this.message,
    required this.chatId,
    required this.createdAt,
    required this.sender,
    required this.receiver,
  });
  final String id;
  final String message;
  final String chatId;
  final Timestamp createdAt;
  final String sender;
  final String receiver;

  static Message fromSnapShot(DocumentSnapshot snapShot) {
    return Message(
      id: snapShot.id,
      message: snapShot['message'],
      chatId: snapShot['chatId'],
      createdAt: snapShot['createdAt'],
      sender: snapShot['senderId'],
      receiver: snapShot['receiverId'],
    );
  }

  @override
  List<Object> get props => [id, message, chatId, createdAt, sender, receiver];
}
