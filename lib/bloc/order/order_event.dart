part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrder extends OrderEvent {}

class LoadSellersOrders extends OrderEvent {
  final String sellerId;

  const LoadSellersOrders({required this.sellerId});

  @override
  List<Object> get props => [sellerId];
}

class LoadAllSellersOrders extends OrderEvent {
  final String sellerId;

  const LoadAllSellersOrders({required this.sellerId});

  @override
  List<Object> get props => [sellerId];
}

class LoadBuyersOrders extends OrderEvent {
  final String buyerId;

  const LoadBuyersOrders({required this.buyerId});

  @override
  List<Object> get props => [buyerId];
}

class LoadPurchaseOrders extends OrderEvent {
  final String sellerId;

  const LoadPurchaseOrders({required this.sellerId});

  @override
  List<Object> get props => [sellerId];

}

class LoadBuyerPurchases extends OrderEvent {
  final String buyerId;

  const LoadBuyerPurchases({required this.buyerId});

  @override
  List<Object> get props => [buyerId];

}

class GetOrder extends OrderEvent {
  final String id;

  const GetOrder(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateOrder extends OrderEvent {
  final List<Order> orders;

  const UpdateOrder(this.orders);

  @override
  List<Object> get props => [orders];
}
