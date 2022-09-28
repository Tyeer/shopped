part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadSellerProducts extends ProductEvent {
  final String sellerId;

  const LoadSellerProducts({required this.sellerId});

  @override
  List<Object> get props => [sellerId];
}

class LoadRelatedProducts extends ProductEvent {
  final String category;
  final String id;

  const LoadRelatedProducts({required this.category, required this.id});

  @override
  List<Object> get props => [category];
}

class AddProduct extends ProductEvent {
  final Product product;

  const AddProduct(this.product);

  @override
  List<Object> get props => [product];
}

class UpdateProducts extends ProductEvent {
  final List<Product> products;

  const UpdateProducts(this.products);

  @override
  List<Object> get props => [products];
}

class DeleteProduct extends ProductEvent {
  final String productId;

  const DeleteProduct(this.productId);

  @override
  List<Object> get props => [productId];
}
