import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';

class DepositsOrWithdrawalsPage extends StatefulWidget {
  const DepositsOrWithdrawalsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DepositsOrWithdrawalsPage> createState() =>
      _DepositsOrWithdrawalsPageState();
}

class _DepositsOrWithdrawalsPageState extends State<DepositsOrWithdrawalsPage> {
  int selectedOperation = 0;
  TextEditingController sumController = TextEditingController();

  double sum = 0;
  bool isButtonActive = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          setBackgroundImage(),
          SingleChildScrollView(
            child: Column(
              children: [
                const CustomAppBar(),
                const SizedBox(height: 100),
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                      color: ColorPalette.white,
                      border: Border.all(width: 1, color: ColorPalette.main)),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.main,
                              disabledBackgroundColor: ColorPalette.green,
                            ),
                            onPressed: selectedOperation == 0
                                ? null
                                : () {
                                    selectedOperation = 0;

                                    setState(() {});
                                  },
                            child: const Text(
                              'Внесение',
                              style: ProjectStyles.textStyle_14Bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.main,
                              disabledBackgroundColor: ColorPalette.green,
                            ),
                            onPressed: selectedOperation == 1
                                ? null
                                : () {
                                    selectedOperation = 1;
                                    setState(() {});
                                  },
                            child: const Text(
                              'Изъятие',
                              style: ProjectStyles.textStyle_14Bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Сумма',
                            style: ProjectStyles.textStyle_14Regular,
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: sumController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Сумма',
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.main,
                        ),
                        onPressed: () {
                          if (isButtonActive && sumController.text != '') {
                            sendData();
                          }
                        },
                        child: const Text(
                          'Сохранить',
                          style: ProjectStyles.textStyle_14Bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendData() async {
    isButtonActive = false;
    try {
      if (double.tryParse(sumController.text) == null) {
        showCustomSnackBar(context, 'Введите корректное вначение!');
        isButtonActive = true;
      } else {
        await MainApiService().sendMoneyOperationRequest(
          double.tryParse(sumController.text) ?? 0,
          selectedOperation,
        );

        showCustomSnackBar(context, 'Операция успешно выполнена!');

        Future.delayed(const Duration(seconds: 2))
            .whenComplete(() => Navigator.of(context).pushNamed('/home'));
      }
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
