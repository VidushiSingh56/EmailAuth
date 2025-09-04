import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRedSnackbar {
  static showSnackbar({
    required String titleText,
    required String messageText,
    SnackStyle snackStyle = SnackStyle.FLOATING,
    EdgeInsets margin = const EdgeInsets.all(20),
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    backgroundColor = const Color(0xFFE8736F),
    // Color backgroundColor = const Color(0xD5008A28),
    FontWeight titleFontWeight = FontWeight.w700,
    FontWeight messageFontWeight = FontWeight.w400,
    double titleFontSize = 18.0,
    double messageFontSize = 15.0,
  }) {
    Get.snackbar(
      titleText,
      messageText,
      snackStyle: snackStyle,
      margin: margin,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      titleText: Text(
        titleText,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: titleFontSize,
          color: Colors.black,
        ),
      ),
      messageText: Text(
        messageText,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: messageFontSize,
          color: Colors.black,
        ),
      ),
    );
  }
}




class CustomGreenSnackbar {
  static showSnackbar({
    required String titleText,
    required String messageText,
    SnackStyle snackStyle = SnackStyle.FLOATING,
    EdgeInsets margin = const EdgeInsets.all(20),
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    Color backgroundColor = Colors.green,
    FontWeight titleFontWeight = FontWeight.w700,
    FontWeight messageFontWeight = FontWeight.w400,
    double titleFontSize = 18.0,
    double messageFontSize = 15.0,
  }) {
    Get.snackbar(
      titleText,
      messageText,
      snackStyle: snackStyle,
      margin: margin,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      titleText: Text(
        titleText,
        style: TextStyle(
          fontWeight: titleFontWeight,
          fontSize: titleFontSize,
          color: Colors.black,
        ),
      ),
      messageText: Text(
        messageText,
        style: TextStyle(
          fontWeight: messageFontWeight,
          fontSize: messageFontSize,
          color: Colors.black,
        ),
      ),
    );
  }
}

