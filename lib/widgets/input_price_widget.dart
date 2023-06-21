import 'package:flutter/material.dart';

class InputPriceWidget extends StatefulWidget {
  const InputPriceWidget({Key? key, required this.inputPrice})
      : super(key: key);

  final Function(double, String) inputPrice;

  @override
  State<InputPriceWidget> createState() => _InputPriceWidgetState();
}

class _InputPriceWidgetState extends State<InputPriceWidget> {
  TextEditingController priceController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 170,
      child: Column(
        children: [
          TextField(
            controller: priceController,
            decoration: const InputDecoration(hintText: 'Новая цена'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Комментарий'),
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
                    double? count = double.tryParse(priceController.text);
                    if (count != null && count != 0) {
                      Navigator.of(context).pop();
                      widget.inputPrice(count, commentController.text);
                    }
                  },
                  child: const Text('Ok')),
            ],
          )
        ],
      ),
    );
  }
}
