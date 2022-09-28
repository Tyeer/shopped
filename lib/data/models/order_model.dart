import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String id;
  final String sellerId;
  final String buyerId;
  final String addressId;
  final String orderId;
  final String orderStatus;
  final String paymentMethods;
  final String price;
  final String productId;
  final String productName;
  final String quantity;
  final String totalAmount;
  final String imageUrl;
  final String createdAt;
  Order({
    required this.id,
    required this.sellerId,
    required this.buyerId,
    required this.addressId,
    required this.orderId,
    required this.orderStatus,
    required this.paymentMethods,
    required this.price,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.totalAmount,
    required this.imageUrl,
    required this.createdAt,
  });

  static Order fromSnapshot(DocumentSnapshot snapshot) {
    return Order(
      id: snapshot.id,
      sellerId: snapshot['sellerId'],
      buyerId: snapshot['buyerId'],
      addressId: snapshot['addressId'],
      orderId: snapshot['orderId'],
      orderStatus: snapshot['orderStatus'],
      paymentMethods: snapshot['paymentMethods'],
      price: snapshot['price'],
      productId: snapshot['productId'],
      productName: snapshot['productName'],
      quantity: snapshot['quantity'],
      totalAmount: snapshot['totalAmount'],
      imageUrl: snapshot['imageUrl'],
      createdAt: snapshot['createdAt'],
    );
  }

  @override
  List<Object> get props => [
        id,
        sellerId,
        buyerId,
        addressId,
        orderId,
        orderStatus,
        paymentMethods,
        price,
        productId,
        productName,
        quantity,
        totalAmount,
        imageUrl,
        createdAt,
      ];
}
