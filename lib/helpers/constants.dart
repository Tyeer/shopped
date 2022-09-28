import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

const kIconColor = Colors.white;
const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);
const KBgColor = Color(0xfff5f5f5);
const PrimaryBlueOcean = Color(0xFF3669C9);
const SecondaryDarkGrey = Color(0xFF838589);
const iconBlueDark = Color(0xff016DD1);
const priceColor = Color(0xffD40000);
const activeTabColor = Color(0xffEAA92A);
const greenColor = Color(0xff03A600);

const arrowColor = Color(0xffD40000);
const orderColor = Color(0xff3DFF5C00);
const accountColor = Color(0xffDEF7FF);
const starredColor = Color(0xffFFF7DF);
const historyColor = Color(0xff2B03A600);
const sucessColor = Color(0xff3CAF47);

const kDefaultPaddin = 16.0;
const appBarTitleSize = 16.0;
const double paddingHorizontal = 16;
const double cardElevationValue = 8;
const double textMedium = 14;
const double textSmall = 12.5;
const double textLarge = 25;

String timeStampToDateToAgo(Timestamp timestamp) {
  final DateTime date =
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  final String ago =
      timeago.format(DateTime.parse(date.toString()), locale: 'en_short');
  return ago;
}

// String dateToAgo(String time) {
//   final DateTime date = DateTime.fromMillisecondsSinceEpoch(Timestamp.parse(time).millisecondsSinceEpoch);
//   final String ago =
//       timeago.format(DateTime.parse(date.toString()), locale: 'en_short');
//   return ago;
// }
