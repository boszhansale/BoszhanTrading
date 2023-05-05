import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      color: ColorPalette.main,
      child: Row(
        children: [
          customIconButton(
            () {
              Navigator.of(context).pushNamed('/home');
            },
            mainColor: ColorPalette.white,
            secondaryColor: ColorPalette.main,
          ),
          const Text(
            "Первомайские деликатесы",
            style: ProjectStyles.textStyle_22Bold,
          ),
          const Spacer(),
          const SizedBox(width: 20),
          customIconButton(
            () {
              AuthRepository().logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/auth', ModalRoute.withName('/'));
            },
            icon: Icons.exit_to_app,
            mainColor: ColorPalette.white,
            secondaryColor: ColorPalette.main,
          ),
        ],
      ),
    );
  }
}
