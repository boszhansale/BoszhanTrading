import 'package:boszhan_trading/pages/check_page/check_page.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/utils/calculateNDS.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';

class PaymentCalculatorWidget extends StatefulWidget {
  const PaymentCalculatorWidget({
    Key? key,
    required this.orderId,
    required this.totalPrice,
  }) : super(key: key);
  final int orderId;
  final double totalPrice;

  @override
  State<PaymentCalculatorWidget> createState() =>
      _PaymentCalculatorWidgetState();
}

class _PaymentCalculatorWidgetState extends State<PaymentCalculatorWidget> {
  int selectedPaymentType = 1;
  TextEditingController cardController = TextEditingController();
  TextEditingController cashController = TextEditingController();

  double sum = 0;
  double surrender = 0;
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
                      const SizedBox(height: 10),
                      const Text("Общая сумма:",
                          style: ProjectStyles.textStyle_14Bold),
                      const SizedBox(height: 10),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration:
                            const BoxDecoration(color: ColorPalette.main),
                        child: Center(
                          child: Text("${widget.totalPrice} тг",
                              style: ProjectStyles.textStyle_18Bold),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text("Тип оплаты:",
                            style: ProjectStyles.textStyle_14Regular),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.main,
                            ),
                            onPressed: selectedPaymentType == 1
                                ? null
                                : () {
                                    selectedPaymentType = 1;
                                    calculatePrice();
                                    setState(() {});
                                  },
                            child: const Text(
                              'Наличные',
                              style: ProjectStyles.textStyle_14Bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.main,
                            ),
                            onPressed: selectedPaymentType == 2
                                ? null
                                : () {
                                    selectedPaymentType = 2;
                                    calculatePrice();
                                    setState(() {});
                                  },
                            child: const Text(
                              'Карта',
                              style: ProjectStyles.textStyle_14Bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.main,
                            ),
                            onPressed: selectedPaymentType == 3
                                ? null
                                : () {
                                    selectedPaymentType = 3;
                                    calculatePrice();
                                    setState(() {});
                                  },
                            child: const Text(
                              'Смешанный',
                              style: ProjectStyles.textStyle_14Bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      selectedPaymentType == 2 || selectedPaymentType == 3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Карта',
                                  style: ProjectStyles.textStyle_14Regular,
                                ),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    onChanged: (value) {
                                      calculatePrice();
                                    },
                                    controller: cardController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Сумма',
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      selectedPaymentType == 1 || selectedPaymentType == 3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Наличные',
                                  style: ProjectStyles.textStyle_14Regular,
                                ),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    onChanged: (value) {
                                      calculatePrice();
                                    },
                                    controller: cashController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Сумма',
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox.shrink(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Сдача',
                            style: ProjectStyles.textStyle_14Regular,
                          ),
                          Text(
                            '$surrender тг',
                            style: ProjectStyles.textStyle_14Bold,
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Налог(12%)',
                            style: ProjectStyles.textStyle_14Regular,
                          ),
                          Text(
                            '${calculateNDS(widget.totalPrice)} тг',
                            style: ProjectStyles.textStyle_14Bold,
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.main,
                        ),
                        onPressed: () {
                          isButtonActive ? sendData() : null;
                        },
                        child: const Text(
                          'Выбить чек',
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

  void calculatePrice() async {
    if (selectedPaymentType == 1) {
      sum = double.tryParse(cashController.text) ?? 0;
    } else if (selectedPaymentType == 2) {
      sum = double.tryParse(cardController.text) ?? 0;
    } else {
      sum = (double.tryParse(cashController.text) ?? 0) +
          (double.tryParse(cardController.text) ?? 0);
    }

    surrender = sum - widget.totalPrice;
    setState(() {});
  }

  void sendData() async {
    isButtonActive = false;
    try {
      var response = await MainApiService().sendDataToCheck(
          widget.orderId,
          selectedPaymentType,
          double.tryParse(cashController.text) ?? 0,
          double.tryParse(cardController.text) ?? 0);

      var responsePrintCheck =
          await MainApiService().getTicketForPrint(widget.orderId);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckPage(
                  check: responsePrintCheck["Lines"],
                )),
      );

      // js.context.callMethod('open', [response['Data']['TicketPrintUrl']]);
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
