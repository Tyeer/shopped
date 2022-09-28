import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Log extends Equatable {
  final String id;
  final String sellerId;
  final String buyerId;
  final String date;
  final String logType;

  const Log({
    required this.id,
    required this.sellerId,
    required this.buyerId,
    required this.date,
    required this.logType
  });

  factory Log.fromSnapshot(DocumentSnapshot snap) {
    Log category = Log(
      id : snap['logID'] ?? '',
      sellerId : snap['sellerId'] ?? '',
      buyerId : snap['buyerId'] ?? '',
      date : snap['date'] ?? '',
      logType : snap['logType'] ?? '',
    );
    return category;
  }

  @override
  List<Object?> get props => [id, sellerId, buyerId, date, logType];
}
