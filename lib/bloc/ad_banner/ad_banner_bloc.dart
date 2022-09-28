import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'ad_banner_event.dart';
part 'ad_banner_state.dart';

class AdBannerBloc extends Bloc<AdBannerEvent, AdBannerState> {
  final Repository _adBannerRepository;
  StreamSubscription? _adBannerSubscription;

  AdBannerBloc({required adBannerRepository})
      : _adBannerRepository = adBannerRepository,
        super(AdBannerLoading()) {
    on<LoadAdBanner>(_onLoadAdBanner);
    on<UpdateAdBanner>(_onUpdateAdBanner);
  }

  void _onLoadAdBanner(
    LoadAdBanner event,
    Emitter<AdBannerState> emit,
  ) {
    _adBannerSubscription?.cancel();

  }

  void _onUpdateAdBanner(
    UpdateAdBanner event,
    Emitter<AdBannerState> emit,
  ) {
    emit(AdBannerLoaded(adBannerList: event.adBannerList));
  }
}
