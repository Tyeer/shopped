part of 'ad_banner_bloc.dart';

abstract class AdBannerEvent extends Equatable {
  const AdBannerEvent();

  @override
  List<Object> get props => [];
}

class LoadAdBanner extends AdBannerEvent {}

class UpdateAdBanner extends AdBannerEvent {
  final List<AdBanner> adBannerList;

  const UpdateAdBanner({this.adBannerList = const <AdBanner>[]});

  @override
  List<Object> get props => [adBannerList];
}
