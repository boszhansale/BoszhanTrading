import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class RefundReasonSelectionWidget extends StatefulWidget {
  const RefundReasonSelectionWidget({Key? key, required this.selectReason})
      : super(key: key);

  final Function(int, String) selectReason;

  @override
  State<RefundReasonSelectionWidget> createState() =>
      _RefundReasonSelectionWidgetState();
}

class _RefundReasonSelectionWidgetState
    extends State<RefundReasonSelectionWidget> {
  List<String> dataList = [
    'По сроку годности',
    'По сроку годности более 10 дней',
    'Белая жидкость',
    'Блок продаж по решению ДР',
    'Возврат конечного потребителя/скрытый брак',
    'Низкие продажи',
    'Переход на договор (с ФЗ на ЮЛ)',
    'Поломка оборудования покупателя/закрытие магазина Покупателя',
    'Развакуум',
    'Прочее'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 500,
      child: Column(
        children: [
          const Divider(),
          const Text('Причина возврата:',
              style: ProjectStyles.textStyle_18Bold),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(
                  dataList[index],
                  style: ProjectStyles.textStyle_14Regular,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () {
                    widget.selectReason(index + 1, dataList[index]);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
