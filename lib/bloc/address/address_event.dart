part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class LoadAddress extends AddressEvent {
  final String userId;

  const LoadAddress(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetAddress extends AddressEvent {
  final String id;

  const GetAddress(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateAddress extends AddressEvent {
  final List<Address> addresses;

  const UpdateAddress(this.addresses);

  @override
  List<Object> get props => [addresses];
}
