part of 'ad_banner_bloc.dart';

abstract class AdBannerState extends Equatable {
  const AdBannerState();

  @override
  List<Object> get props => [];
}

class AdBannerLoading extends AdBannerState {}

class AdBannerLoaded extends AdBannerState {
  final List<AdBanner> adBannerList;

  const AdBannerLoaded({this.adBannerList = const <AdBanner>[]});

  @override
  List<Object> get props => [adBannerList];
}
