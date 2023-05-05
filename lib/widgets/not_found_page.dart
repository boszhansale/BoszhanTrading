import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Not Found',
        style: ProjectStyles.textStyle_22Bold,
      ),
    );
  }
}
