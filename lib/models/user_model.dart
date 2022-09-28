import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String DateJoined;
  String Fullname;
  String Phonenumber;
  String Type;
  String Uid;
  String userImage;
  String followers;


  UserModel({
    required this.DateJoined,
    required this.Fullname,
    required this.Phonenumber,
    required this.Type,
    required this.Uid,
    required this.userImage,
    required this.followers

});

  factory UserModel.fromJson(DocumentSnapshot snapshot){
    return UserModel(
        DateJoined: snapshot['DateJoined'],
        Fullname: snapshot['Fullname'],
        Phonenumber: snapshot['Phonenumber'],
        Type: snapshot['Type'],
        Uid: snapshot['Uid'],
        userImage: snapshot['userImage'],
        followers: snapshot['followers']);
  }
}