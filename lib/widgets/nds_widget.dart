import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

Widget buildNDSWidget(double price1) {
  return Row(
    children: [
      const Spacer(),
      Text(
        'Сумма к оплате: $price1 тг',
        style: ProjectStyles.textStyle_32Bold,
      ),
      const Spacer(),
      // Text(
      //   'НДС: ${(price1 * 0.12).toInt()} тг',
      //   style: ProjectStyles.textStyle_26Bold,
      // ),
      // const Spacer(),
      // Text(
      //   'Сумма с НДС: ${(price1 * 0.12).toInt() + price1} тг',
      //   style: ProjectStyles.textStyle_26Bold,
      // ),
      // const Spacer(),
    ],
  );
}
