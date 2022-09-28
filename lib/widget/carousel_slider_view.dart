import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/widget/banner_card.dart';

class CarouselSliderView extends StatefulWidget {
  const CarouselSliderView({
    Key? key,
    required this.bannersList,
  }) : super(key: key);
  final List<AdBanner> bannersList;

  @override
  State<CarouselSliderView> createState() => _CarouselSliderViewState();
}

class _CarouselSliderViewState extends State<CarouselSliderView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
            items: widget.bannersList
                .map((e) => BannerCard(imageUrl: e.image))
                .toList(),

            options: CarouselOptions(

                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                })
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.bannersList.map((e) {
              int index = widget.bannersList.indexOf(e);
              return Expanded(
                child: Container(
                  height: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentIndex == index
                          ? const Color.fromRGBO(255, 255, 255, 0.9)
                          : const Color.fromRGBO(255, 255, 255, 0.4)),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
