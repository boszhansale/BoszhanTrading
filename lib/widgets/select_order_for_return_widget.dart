import 'package:boszhan_trading/models/product.dart';
import 'package:boszhan_trading/models/sales_order_history_model.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectOrderForReturnWidget extends StatefulWidget {
  const SelectOrderForReturnWidget({
    Key? key,
    required this.selectOrder,
    required this.isShowTodaysOrders,
  }) : super(key: key);

  final Function(int, List<Product>) selectOrder;
  final isShowTodaysOrders;

  @override
  State<SelectOrderForReturnWidget> createState() =>
      _SelectOrderForReturnWidgetState();
}

class _SelectOrderForReturnWidgetState
    extends State<SelectOrderForReturnWidget> {
  TextEditingController searchController = TextEditingController();
  List<SalesOrderHistoryModel> dataList = [];

  String dateFrom = '';
  String dateTo = '';

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    if (widget.isShowTodaysOrders == true) {
      dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now());
      dateTo = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    var response = await MainApiService()
        .getSalesOrderHistoryForReturnWithSearch('', dateFrom, dateTo);

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
      height: 550,
      child: Column(
        children: [
          SizedBox(
              height: 50,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(hintText: 'Поиск'),
                onChanged: (value) {
                  searchOrder();
                },
              )),
          widget.isShowTodaysOrders
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Дата: ', style: ProjectStyles.textStyle_14Bold),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const Text('с ',
                              style: ProjectStyles.textStyle_14Bold),
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now())
                                  .then((pickedDate) {
                                if (pickedDate == null) {
                                  return;
                                }
                                setState(() {
                                  dateFrom = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                });
                                if (dateFrom != '' && dateTo != '') {
                                  searchOrder();
                                }
                              });
                            },
                            child: Text(dateFrom == '' ? 'выбрать' : dateFrom,
                                style: ProjectStyles.textStyle_14Bold
                                    .copyWith(color: ColorPalette.main)),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text(' по ',
                            style: ProjectStyles.textStyle_14Bold),
                        GestureDetector(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now())
                                .then((pickedDate) {
                              if (pickedDate == null) {
                                return;
                              }
                              setState(() {
                                dateTo =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                              if (dateFrom != '' && dateTo != '') {
                                searchOrder();
                              }
                            });
                          },
                          child: Text(dateTo == '' ? 'выбрать' : dateTo,
                              style: ProjectStyles.textStyle_14Bold
                                  .copyWith(color: ColorPalette.main)),
                        ),
                      ],
                    ),
                  ],
                ),
          const Divider(),
          const Text('Заказы:', style: ProjectStyles.textStyle_18Bold),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(
                  'ID: ${dataList[index].id}, чек № ${dataList[index].checkNumber}',
                  style: ProjectStyles.textStyle_14Bold,
                ),
                subtitle: Text(dataList[index].storeName ?? '',
                    style: ProjectStyles.textStyle_14Regular),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () {
                    widget.selectOrder(
                        dataList[index].id, dataList[index].products);
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

  void searchOrder() async {
    var response = await MainApiService()
        .getSalesOrderHistoryForReturnWithSearch(
            searchController.text, dateFrom, dateTo);

    dataList = [];

    for (var item in response) {
      dataList.add(SalesOrderHistoryModel.fromJson(item));
    }

    setState(() {});
  }
}
