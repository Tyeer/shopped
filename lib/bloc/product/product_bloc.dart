import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final Repository _productRepository;
  StreamSubscription? _productSubscription;

  ProductBloc({required Repository productRepository})
      : _productRepository = productRepository,
        super(ProductLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadRelatedProducts>(_onLoadRelatedProducts);
    on<UpdateProducts>(_onUpdateProducts);
    on<LoadSellerProducts>(_onLoadSellerProducts);
    on<DeleteProduct>(_onDeleteProduct);
  }
  void _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(UpdateProducts(products)),
        );
  }

  void _onLoadRelatedProducts(
      LoadRelatedProducts event,
      Emitter<ProductState> emit,
      ) {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getRelatedProducts(event.category, event.id).listen(
          (products) => {
            add(UpdateProducts(products))
          },
    );
  }

  void _onUpdateProducts(
    UpdateProducts event,
    Emitter<ProductState> emit,
  ) {
    emit(ProductLoaded(products: event.products));
  }

  void _onLoadSellerProducts(
    LoadSellerProducts event,
    Emitter<ProductState> emit,
  ) {
    _productSubscription?.cancel();
    _productSubscription =
        _productRepository.getSellerProducts(event.sellerId).listen(
              (products) => add(UpdateProducts(products)),
            );
  }

  void _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) {
    _productRepository.deleteProduct(event.productId);
    emit(ProductDeleted(event.productId));
  }
}
