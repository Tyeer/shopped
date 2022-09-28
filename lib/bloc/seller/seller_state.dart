part of 'seller_bloc.dart';

abstract class SellerState extends Equatable {
  const SellerState();

  @override
  List<Object> get props => [];
}

class SellerLoading extends SellerState {}

class SellerLoaded extends SellerState {
  final List<Seller> sellers;

  const SellerLoaded({this.sellers = const <Seller>[]});

  @override
  List<Object> get props => [sellers];
}
