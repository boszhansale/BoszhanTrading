import 'package:boszhan_trading/models/product.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class OrderProductsSelectionWidget extends StatefulWidget {
  const OrderProductsSelectionWidget(
      {Key? key, required this.addToBasket, required this.products})
      : super(key: key);

  final Function(dynamic) addToBasket;
  final List<Product> products;

  @override
  State<OrderProductsSelectionWidget> createState() =>
      OrderProductsSelectionWidgetState();
}

class OrderProductsSelectionWidgetState
    extends State<OrderProductsSelectionWidget> {
  TextEditingController countController = TextEditingController();
  List<Product> dataList = [];

  dynamic selectedProduct = {};
  double selectedProductCount = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    dataList = widget.products;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 400,
      child: Column(
        children: [
          const Text('Список продуктов:',
              style: ProjectStyles.textStyle_18Bold),
          SizedBox(
              height: 360,
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () {
                    selectedProduct = dataList[index].toJson();
                    showCountDialog();
                  },
                  child: ListTile(
                    title: Text(
                      dataList[index].name ?? '',
                      style: ProjectStyles.textStyle_14Regular,
                    ),
                    trailing: const Icon(Icons.add_circle),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void showCountDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Колличество:'),
          content: SizedBox(
            width: 200,
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: countController,
                  decoration: const InputDecoration(hintText: 'Колличество'),
                  autofocus: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                        onPressed: () {
                          double? count = double.tryParse(countController.text);
                          if (count != null && count != 0) {
                            selectedProduct['count'] = count;
                            Navigator.of(context).pop();
                            widget.addToBasket(selectedProduct);
                          }
                        },
                        child: const Text('Ok')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
