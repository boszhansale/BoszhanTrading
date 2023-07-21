import 'package:boszhan_trading/models/moving_history_model.dart';
import 'package:boszhan_trading/pages/moving/moving_edit_page.dart';
import 'package:boszhan_trading/pages/moving/moving_order_history_products.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovingHistoryPage extends StatefulWidget {
  const MovingHistoryPage({Key? key}) : super(key: key);

  @override
  State<MovingHistoryPage> createState() => _MovingHistoryPageState();
}

class _MovingHistoryPageState extends State<MovingHistoryPage> {
  List<MovingOrderHistoryModel> orders = [];

  String dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String dateTo = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    checkLogin();
    getHistory();
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
                      const Text("Журнал перемещения",
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
                                        getHistory();
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
                                      getHistory();
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
      const DataColumn(label: Text('Дата')),
      const DataColumn(label: Text('Операция')),
      const DataColumn(label: Text('Колл. продуктов')),
      const DataColumn(label: Text('Сумма')),
      const DataColumn(label: Text('Показать')),
      const DataColumn(label: Text('Изменить')),
      // const DataColumn(label: Text('Удалить')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < orders.length; i++)
        DataRow(cells: [
          DataCell(Text('${i + 1}')),
          DataCell(Text(orders[i].id.toString())),
          DataCell(Text(orders[i].storeName ?? '')),
          DataCell(Text(orders[i].createdAt ?? '')),
          DataCell(Text(orders[i].operation == 1 ? "Со склада" : "На склад")),
          DataCell(Text(orders[i].productsCount.toString())),
          DataCell(Text(orders[i].totalPrice.toString())),
          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MovingOrderHistoryProductsPage(order: orders[i])),
                );
              },
              icon: const Icon(Icons.list),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovingEditPage(order: orders[i])),
                );
              },
              icon: const Icon(Icons.edit),
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
        ]),
    ];
  }

  void getHistory() async {
    try {
      var response =
          await MainApiService().getMovingOrderHistory(dateFrom, dateTo);

      orders = [];

      for (var item in response) {
        orders.add(MovingOrderHistoryModel.fromJson(item));
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void deleteOrderFromHistory(int id) async {
    try {
      await MainApiService().deleteMovingOrderFromHistory(id);
      getHistory();
    } catch (e) {
      print(e);
    }
  }
}
