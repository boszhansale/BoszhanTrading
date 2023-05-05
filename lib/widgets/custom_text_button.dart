import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

Widget customTextButton(VoidCallback onTap,
    {String title = 'title',
    double width = 400,
    Color mainColor = ColorPalette.main,
    Color secondaryColor = ColorPalette.white}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          minimumSize: const Size.fromHeight(60), // NEW
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Text(title, style: ProjectStyles.textStyle_18Bold),
        ),
      ),
    ),
  );
}
