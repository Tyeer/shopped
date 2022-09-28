part of 'seller_bloc.dart';

abstract class SellerEvent extends Equatable {
  const SellerEvent();

  @override
  List<Object> get props => [];
}

class LoadSellers extends SellerEvent {}

class GetSeller extends SellerEvent {
  final String id;

  const GetSeller(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateSeller extends SellerEvent {
  final List<Seller> seller;

  const UpdateSeller(this.seller);

  @override
  List<Object> get props => [seller];
}
