import 'package:flutter/material.dart';

import 'color_palette.dart';

class ProjectStyles {
  static const TextStyle textStyle_14Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_14Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_14Bold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_18Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_18Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_18Bold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_22Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 22,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_22Bold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_30Regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 30,
    color: ColorPalette.black,
  );
  static const TextStyle textStyle_30Bold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: ColorPalette.black,
  );
  static BoxDecoration containerDecoration = BoxDecoration(
    color: ColorPalette.background,
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 4,
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
