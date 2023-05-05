import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

Widget customTextFormField(
  VoidCallback onChanged, {
  TextEditingController? controller,
  String hintText = '',
  Icon? icon,
  Color borderColor = ColorPalette.black,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        icon: icon,
        hintText: hintText,
        hintStyle:
            ProjectStyles.textStyle_14Regular.copyWith(color: Colors.black54),
        labelStyle: ProjectStyles.textStyle_14Regular,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста заполните поле';
        }
        return null;
      },
      onChanged: (value) {
        onChanged();
      },
    ),
  );
}
