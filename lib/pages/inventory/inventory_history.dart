import 'package:boszhan_trading/models/inventory_order_history_model.dart';
import 'package:boszhan_trading/pages/inventory/inventory_edit_page.dart';
import 'package:boszhan_trading/pages/inventory/inventory_order_history_products.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/const.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventoryHistoryPage extends StatefulWidget {
  const InventoryHistoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryHistoryPage> createState() => _InventoryHistoryPageState();
}

class _InventoryHistoryPageState extends State<InventoryHistoryPage> {
  List<InventoryOrderHistoryModel> orders = [];

  String dateFrom = '';
  String dateTo = '';

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
                      const Text("Журнал инвентаризации",
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
      const DataColumn(label: Text('Колл. продуктов')),
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
          DataCell(Text(orders[i].productsCount.toString())),
          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InventoryOrderHistoryProductsPage(order: orders[i])),
                );
              },
              icon: const Icon(Icons.list),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: () {
                _showPasswordEntering(orders[i]);
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
          await MainApiService().getInventoryOrderHistory(dateFrom, dateTo);

      orders = [];

      for (var item in response) {
        orders.add(InventoryOrderHistoryModel.fromJson(item));
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

  void _showPasswordEntering(InventoryOrderHistoryModel order) async {
    TextEditingController passwordcontroller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Введите пароль для подтверждения'),
          content: SizedBox(
            width: 200,
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: passwordcontroller,
                  decoration: const InputDecoration(hintText: 'Пароль'),
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
                          if (passwordcontroller.text ==
                              AppConstants.appPassword) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InventoryEditPage(order: order)),
                            );
                          } else {
                            showCustomSnackBar(context, 'Неверный пароль!');
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
