import 'package:boszhan_trading/models/sales_order_history_model.dart';
import 'package:boszhan_trading/pages/check_page/check_page.dart';
import 'package:boszhan_trading/pages/sales/sales_order_history_products.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  Object paymentTypeSelectedValue = 0;

  List<SalesOrderHistoryModel> orders = [];
  List<SalesOrderHistoryModel> allOrders = [];

  String dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String dateTo = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    checkLogin();
    searchOrder();
    super.initState();
  }

  void checkLogin() async {
    final bool isAuth = await AuthRepository().isAuth();
    if (!isAuth) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/auth', ModalRoute.withName('/'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          setBackgroundImage(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text("Журнал продаж",
                          style: ProjectStyles.textStyle_30Bold),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Дата: ',
                              style: ProjectStyles.textStyle_14Bold),
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
                                  child: Text(
                                      dateFrom == '' ? 'выбрать' : dateFrom,
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
                                      dateTo = DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Тип оплаты:',
                            style: ProjectStyles.textStyle_14Medium,
                          ),
                          const SizedBox(width: 10),
                          DropdownButton(
                            value: paymentTypeSelectedValue,
                            items: const [
                              DropdownMenuItem(
                                  child: Text("Наличный"), value: 0),
                              DropdownMenuItem(
                                  child: Text("Безналичный"), value: 1),
                            ],
                            onChanged: (Object? newValue) {
                              setState(() {
                                paymentTypeSelectedValue = newValue!;
                                orders = [];
                                for (var item in allOrders) {
                                  if (item.payments.isNotEmpty) {
                                    if (paymentTypeSelectedValue ==
                                        (item.payments[0]['PaymentType'] ??
                                            '')) {
                                      orders.add(item);
                                    }
                                    print(item.payments[0]['PaymentType']);
                                  }
                                }
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 600,
                        child: SingleChildScrollView(
                          child: Material(
                            elevation: 3,
                            child: Container(
                              color: ColorPalette.white,
                              width: double.infinity,
                              child: _createDataTable(),
                            ),
                          ),
                        ),
                      ),
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

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('№')),
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Тор. точка')),
      const DataColumn(label: Text('Контрагент')),
      const DataColumn(label: Text('Дата')),
      const DataColumn(label: Text('Кол.')),
      const DataColumn(label: Text('Сумма')),
      const DataColumn(label: Text('Сдача')),
      const DataColumn(label: Text('Оплата')),
      const DataColumn(label: Text('Чек')),
      const DataColumn(label: Text('Показать')),
      // const DataColumn(label: Text('Удалить')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < orders.length; i++)
        DataRow(
          cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(orders[i].id.toString())),
            DataCell(Text(orders[i].storeName ?? '')),
            DataCell(Text(orders[i].counteragentName ?? '')),
            DataCell(Text(orders[i].createdAt ?? '')),
            DataCell(Text(orders[i].productsCount.toString())),
            DataCell(Text(orders[i].totalPrice.toString())),
            DataCell(Text(orders[i].givePrice.toString())),
            DataCell(Text(orders[i].payments.isNotEmpty
                ? orders[i].payments[0]['PaymentType'] == 0
                    ? 'Нал'
                    : 'Без нал'
                : ' ')),
            DataCell(
              IconButton(
                onPressed: () {
                  orders[i].printUrl != null
                      ? getCheckAndPrint(orders[i].id)
                      : showCustomSnackBar(context, 'Чек отсутствует!');
                },
                icon: const Icon(Icons.print),
              ),
            ),
            DataCell(
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SalesOrderHistoryProductsPage(order: orders[i])),
                  );
                },
                icon: const Icon(Icons.list),
              ),
            ),
            // DataCell(
            //   IconButton(
            //     onPressed: () {
            //       deleteOrderFromHistory(orders[i].id);
            //     },
            //     icon: const Icon(Icons.delete),
            //   ),
            // )
          ],
        ),
    ];
  }

  void searchOrder() async {
    var response = await MainApiService()
        .getSalesOrderHistoryForReturnWithSearch('', dateFrom, dateTo);

    orders = [];
    allOrders = [];

    for (var item in response) {
      allOrders.add(SalesOrderHistoryModel.fromJson(item));
    }

    for (var item in allOrders) {
      if (item.payments.isNotEmpty) {
        if (paymentTypeSelectedValue ==
            (item.payments[0]['PaymentType'] ?? '')) {
          orders.add(item);
        }
      }
    }

    setState(() {});
  }

  void deleteOrderFromHistory(int id) async {
    try {
      await MainApiService().deleteSalesOrderFromHistory(id);
      searchOrder();
    } catch (e) {
      print(e);
    }
  }

  void getCheckAndPrint(int id) async {
    var responsePrintCheck = await MainApiService().getTicketForPrint(id);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CheckPage(
                check: responsePrintCheck["Lines"],
              )),
    );
  }
}
