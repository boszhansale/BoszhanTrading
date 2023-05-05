import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final repository = AuthRepository();

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: Image.asset('../assets/images/logo.png'),
        ),
        const SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            color: ColorPalette.main,
          ),
        )
      ],
    );
  }

  void _init() async {
    await Future.delayed(const Duration(seconds: 2));
    final bool isAuth = await repository.isAuth();
    if (mounted) {
      if (isAuth) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', ModalRoute.withName('/'));
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/auth', ModalRoute.withName('/'));
      }
    }
  }
}
