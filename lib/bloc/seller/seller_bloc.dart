import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'seller_event.dart';
part 'seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  Repository _sellerRepository;
  StreamSubscription? _sellerSubscription;

  SellerBloc({required Repository sellerRepository})
      : _sellerRepository = sellerRepository,
        super(SellerLoading()) {
    on<LoadSellers>(_onLoadSellers);
    on<UpdateSeller>(_onUpdateSeller);
    on<GetSeller>(_onGetSeller);
  }

  void _onLoadSellers(
    LoadSellers event,
    Emitter<SellerState> emit,
  ) {
    _sellerSubscription?.cancel();
    _sellerSubscription = _sellerRepository.getAllSellers().listen(
          (sellers) => add(UpdateSeller(sellers)),
        );
  }

  void _onUpdateSeller(
    UpdateSeller event,
    Emitter<SellerState> emit,
  ) {
    emit(SellerLoaded(sellers: event.seller));
  }

  void _onGetSeller(
    GetSeller event,
    Emitter<SellerState> emit,
  ) {
    _sellerSubscription?.cancel();
    _sellerSubscription = _sellerRepository.getSellerById(event.id).asStream().listen(
          (seller) => add(UpdateSeller([seller])),
        );
  }
}
