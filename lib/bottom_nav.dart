import 'package:chat2/ChatScreen/ChatCheck.dart';
import 'package:chat2/ChatScreen/ProfileCheck.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/bloc/blocs.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/HomeScreens/account_view.dart';
import 'package:chat2/HomeScreens/chat_view.dart';
import 'package:chat2/HomeScreens/home_view.dart';
import 'package:chat2/HomeScreens/sellers_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'data/models/seller_model.dart';
import 'data/models/user_model.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  final List _screens = [
    const HomeScreen(),
    const SellersView(),
    const ChatCheck(),
    const ProfileCheck()
  ];
  final Repository repo = Repository();
  String _userId = "";

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('Type');

    if(userRole != null){
      String userId = '';
      if(userRole.contains("Seller")){
        Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('Phonenumber'));
        userId = logSeller!.id;
      }
      else {
        Customer? logCustomer = await repo.findBuyerByPhoneNumber(prefs.getString('Phonenumber'));
        userId = logCustomer!.id;
      }
      setState(() {
        _userId = userId;
      });

    }
  }

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => Repository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) =>
                    AddressBloc(addressRepository: Repository())),
            BlocProvider(
              create: (context) => ProductBloc(
                productRepository: Repository(),
              )..add(LoadProducts()),
            ),
            BlocProvider(
                create: (context) => ReviewBloc(
                      reviewRepository: Repository(),
                    )),
            BlocProvider(
              create: (context) => SellerBloc(sellerRepository: Repository())
                ..add(LoadSellers()),
            ),
            BlocProvider(
                create: (context) =>
                    FollowsBloc(followsRepository: Repository())),
            BlocProvider(
                create: (context) =>
                    MessageBloc(messageRepository: Repository())),
            BlocProvider(
                create: (context) => AdBannerBloc(
                      adBannerRepository: Repository(),
                    )..add(LoadAdBanner())),
            BlocProvider(
                create: (context) =>
                    OrderBloc(orderRepository: Repository())..add(LoadOrder())),
            BlocProvider(
                create: (context) =>
                    ChatRoomBloc(chatRoomRepository: Repository())
                      ..add(LoadChatRooms(userId: _userId))),
          ],
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        selectedItemColor: iconBlueDark,
        unselectedItemColor: SecondaryDarkGrey,
        selectedIconTheme: const IconThemeData(color: PrimaryBlueOcean),
        items: [
          BottomNavigationBarItem(
              label: "Home",
              activeIcon: SvgPicture.network(
                "https://www.svgrepo.com/show/13701/home.svg",
                color: PrimaryBlueOcean,
                height: 20,
              ),
              icon: SvgPicture.network(
                "https://www.svgrepo.com/show/13701/home.svg",
                color: SecondaryDarkGrey,
                height: 20,
              )),
          BottomNavigationBarItem(
              label: "Sellers",
              activeIcon: SvgPicture.network(
                "https://www.svgrepo.com/show/335242/people.svg",
                color: PrimaryBlueOcean,
                height: 20,
              ),
              icon: SvgPicture.network(
                "https://www.svgrepo.com/show/335242/people.svg",
                color: SecondaryDarkGrey,
                height: 20,
              )),
          BottomNavigationBarItem(
              label: "Chats",
              activeIcon: SvgPicture.network(
                "https://www.svgrepo.com/show/73785/chat.svg",
                color: PrimaryBlueOcean,
                height: 20,
              ),
              icon: SvgPicture.network(
                "https://www.svgrepo.com/show/73785/chat.svg",
                color: SecondaryDarkGrey,
                height: 20,
              )),
          BottomNavigationBarItem(
              label: "Account",
              activeIcon: SvgPicture.network(
                "https://www.svgrepo.com/show/347900/person.svg",
                color: PrimaryBlueOcean,
                height: 20,
              ),
              icon: SvgPicture.network(
                "https://www.svgrepo.com/show/347900/person.svg",
                color: SecondaryDarkGrey,
                height: 20,
              )),
        ],
      ),
    );
  }
}
