import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final Repository _orderRepository;
  StreamSubscription? _orderSubscription;

  OrderBloc({required orderRepository})
      : _orderRepository = orderRepository,
        super(OrderLoading()) {
    on<LoadOrder>(_onLoadOrder);
    on<LoadSellersOrders>(_onLoadSellersOrders);
    on<LoadAllSellersOrders>(_onLoadAllSellersOrders);
    on<LoadBuyersOrders>(_onLoadBuyersOrders);
    on<LoadPurchaseOrders>(_onLoadPurchaseOrder);
    on<LoadBuyerPurchases>(_onLoadBuyerPurchases);
    on<GetOrder>(_onGetOrder);
    on<UpdateOrder>(_onUpdateOrder);
  }

  void _onLoadOrder(
    LoadOrder event,
    Emitter<OrderState> emit,
  ) {
    _orderSubscription?.cancel();
  }

  void _onLoadSellersOrders(
      LoadSellersOrders event,
      Emitter<OrderState> emit,
      ) {
    _orderSubscription?.cancel();

  }

  void _onLoadAllSellersOrders(
      LoadAllSellersOrders event,
      Emitter<OrderState> emit,
      ) {
    _orderSubscription?.cancel();

  }

  void _onLoadBuyersOrders(
      LoadBuyersOrders event,
      Emitter<OrderState> emit,
      ) {
    _orderSubscription?.cancel();

  }

  void _onGetOrder(
    GetOrder event,
    Emitter<OrderState> emit,
  ) {
    _orderSubscription?.cancel();
  }

  void _onUpdateOrder(
    UpdateOrder event,
    Emitter<OrderState> emit,
  ) {
    emit(OrderLoaded(orders: event.orders));
  }

  void _onLoadPurchaseOrder(
    LoadPurchaseOrders event,
    Emitter<OrderState> emit,
  ) {
    _orderSubscription?.cancel();

  }

  void _onLoadBuyerPurchases(
      LoadBuyerPurchases event,
      Emitter<OrderState> emit,
      ) {
    _orderSubscription?.cancel();

  }
}
