import 'package:boszhan_trading/models/sales_order_history_model.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class SelectOrderForReturnWidget extends StatefulWidget {
  const SelectOrderForReturnWidget({Key? key, required this.selectOrder})
      : super(key: key);

  final Function(int) selectOrder;

  @override
  State<SelectOrderForReturnWidget> createState() =>
      _SelectOrderForReturnWidgetState();
}

class _SelectOrderForReturnWidgetState
    extends State<SelectOrderForReturnWidget> {
  List<SalesOrderHistoryModel> dataList = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    var response = await MainApiService().getSalesOrderHistory();

    dataList = [];

    for (var item in response) {
      dataList.add(SalesOrderHistoryModel.fromJson(item));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 450,
      child: Column(
        children: [
          const Divider(),
          const Text('Заказы:', style: ProjectStyles.textStyle_18Bold),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(
                  dataList[index].id.toString(),
                  style: ProjectStyles.textStyle_14Bold,
                ),
                subtitle: Text(dataList[index].storeName ?? '',
                    style: ProjectStyles.textStyle_14Regular),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () {
                    widget.selectOrder(dataList[index].id);
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
