import 'package:chat2/ProductScreens/Edit_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat2/bloc/blocs.dart';
import 'package:chat2/data/repository/repository.dart';
import 'package:chat2/helpers/constants.dart';
import 'package:chat2/ProductScreens/add_address_view.dart';

import '../data/models/seller_model.dart';
import '../data/models/user_model.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({Key? key}) : super(key: key);

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  final Repository repo = Repository();
  String? _selectedValue;
  String _userId = "";
  final AddressBloc _addressBloc = AddressBloc(addressRepository: Repository());

  getSellerId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('Type');
    if(userRole != null){
      if(userRole.contains("Seller")){
        //debugPrint("seller");
        Seller? logSeller = await repo.findSellerByPhoneNumber(prefs.getString('Phonenumber'));
        debugPrint(logSeller!.id);
        _addressBloc.add(LoadAddress(logSeller.id));
        setState(() {
          _userId = logSeller.id;
        });

      } else {
        Customer? logCustomer = await repo.findBuyerByPhoneNumber(prefs.getString('Phonenumber'));
        _addressBloc.add(LoadAddress(logCustomer!.id));
        setState(() {
          _userId = logCustomer.id;
        });
      }
    }
  }

  @override
  void initState() {
    getSellerId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBgColor,
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Address",
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff016DD1), Color(0xff17259C)]),
            ),
          )),
      body: Stack(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: double.infinity,
            child: BlocProvider(
              create: (context) => _addressBloc,
              child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  if (state is AddressLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is AddressLoaded) {
                    if (state.addresses.isEmpty) {
                      return const Center(
                        child: Text(
                          "No addresses",
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.addresses.length,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 16,
                      ),
                      itemBuilder: (context, index) {
                        final address = state.addresses[index];
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: SecondaryDarkGrey, width: 1)),
                          child: Row(
                            children: [
                              Radio<String>(
                                activeColor: iconBlueDark,
                                value: address.id,
                                groupValue: _selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedValue = value!;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "+265" + address.phone,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    address.address,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    address.city,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditAddress(
                                        address: address,
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 30,
                                    color: iconBlueDark,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return const Center(child: Text("Something went wrong"));
                },
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAddressView(),
                    ),
                  ),
                  child: const Text(
                    'Create new address',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    primary: Colors.white,
                    backgroundColor: PrimaryBlueOcean,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
