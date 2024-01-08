import 'dart:convert';

import 'package:boszhan_trading/pages/sales/new_order_page.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnfinishedOrdersPage extends StatefulWidget {
  const UnfinishedOrdersPage({Key? key}) : super(key: key);

  @override
  State<UnfinishedOrdersPage> createState() => _UnfinishedOrdersPageState();
}

class _UnfinishedOrdersPageState extends State<UnfinishedOrdersPage> {
  List<dynamic> orders = [];

  @override
  void initState() {
    checkLogin();
    super.initState();
    getOrders();
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
                      const Text("Журнал не проведённых продаж",
                          style: ProjectStyles.textStyle_30Bold),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 550,
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

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('№')),
      const DataColumn(label: Text('Дата')),
      const DataColumn(label: Text('Кол.')),
      const DataColumn(label: Text('Перейти')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < orders.length; i++)
        DataRow(
          cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(DateFormat('yyyy-MM-dd HH:mm')
                .format(DateTime.parse(orders[i]['createdAt'])))),
            DataCell(Text(orders[i]['basket'].length.toString())),
            DataCell(
              IconButton(
                onPressed: () async {
                  toOrder(i);
                },
                icon: const Icon(Icons.skip_next),
              ),
            ),
          ],
        ),
    ];
  }

  void getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    orders = [];
    if (prefs.containsKey('UnfinishedOrders')) {
      List<dynamic> thisOrders =
          json.decode(prefs.getString('UnfinishedOrders') ?? '[]');
      for (var item in thisOrders) {
        if (DateTime.parse(item['createdAt'])
                .difference(DateTime.now())
                .inHours <
            24) {
          orders.add(item);
        }
      }
      if (mounted) setState(() {});
    }
  }

  void toOrder(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewOrderPage(
                unfinishedBasket: orders[index]['basket'],
              )),
    );

    List<dynamic> tempList = [];
    for (var item in orders) {
      tempList.add(item);
    }
    tempList.removeAt(index);

    prefs.setString('UnfinishedOrders', json.encode(tempList));
  }
}
