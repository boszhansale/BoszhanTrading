import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

Widget customFullWidthButton(
  VoidCallback onTap, {
  String title = '',
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.main,
        minimumSize: const Size.fromHeight(60),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: ProjectStyles.textStyle_14Bold,
      ),
    ),
  );
}
