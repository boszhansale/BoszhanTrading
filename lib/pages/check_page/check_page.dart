import 'dart:html' as html;

import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class CheckPage extends StatefulWidget {
  final List<dynamic> check;
  const CheckPage({Key? key, required this.check}) : super(key: key);

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  void initState() {
    super.initState();
    printCheck();
  }

  void printCheck() async {
    await Future.delayed(const Duration(seconds: 1));
    html.window.print();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/home');
                },
                child: SizedBox(
                  width: 80,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              const SizedBox(height: 10),
              for (var item in widget.check)
                Text(
                  item['Value'],
                  style: ProjectStyles.textStyle_12Regular,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
