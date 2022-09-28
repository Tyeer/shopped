import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final Repository _addressRepository;
  StreamSubscription? _addressSubscription;

  AddressBloc({required addressRepository})
      : _addressRepository = addressRepository,
        super(AddressLoading()) {
    on<LoadAddress>(_onLoadAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<GetAddress>(_onGetAddress);
  }

  void _onLoadAddress(
    LoadAddress event,
    Emitter<AddressState> emit,
  ) {
    _addressSubscription?.cancel();

  }

  void _onUpdateAddress(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) {
    emit(AddressLoaded(addresses: event.addresses));
  }

  void _onGetAddress(
    GetAddress event,
    Emitter<AddressState> emit,
  ) {
    _addressSubscription?.cancel();
    _addressSubscription = _addressRepository.getAddressById(event.id).listen(
          (address) => add(UpdateAddress([address])),
        );
  }
}
