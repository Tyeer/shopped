import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String to;
  final String from;
  final String dateAdded;
  final String lastMessage;
  final Timestamp lastMessageTime;

  const ChatRoom(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.to,
      required this.from,
      required this.dateAdded,
      required this.lastMessage,
      required this.lastMessageTime});

  static ChatRoom fromSnapShot(DocumentSnapshot snap) {
    ChatRoom chatRoom = ChatRoom(
        id: snap['chatId'],
        name: snap['name'],
        imageUrl: snap['imageUrl'],
        to: snap['to'],
        from: snap['from'],
        dateAdded: snap['dateAdded'],
        lastMessage: snap['lastMessage'],
        lastMessageTime: snap['lastMessageTime']);
    return chatRoom;
  }

  @override
  List<Object> get props =>
      [id, name, imageUrl, to, from, dateAdded, lastMessage, lastMessageTime];
}
