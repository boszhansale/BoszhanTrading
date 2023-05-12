import 'package:flutter/material.dart';

Widget setBackgroundImage() {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
  );
}
