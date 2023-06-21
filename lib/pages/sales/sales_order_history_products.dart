import 'package:boszhan_trading/models/sales_order_history_model.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/nds_widget.dart';
import 'package:flutter/material.dart';

class SalesOrderHistoryProductsPage extends StatefulWidget {
  const SalesOrderHistoryProductsPage({Key? key, required this.order})
      : super(key: key);

  final SalesOrderHistoryModel order;

  @override
  State<SalesOrderHistoryProductsPage> createState() =>
      _SalesOrderHistoryProductsPageState();
}

class _SalesOrderHistoryProductsPageState
    extends State<SalesOrderHistoryProductsPage> {
  @override
  void initState() {
    checkLogin();
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
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Text("Список товаров заказа №${widget.order.id}",
                              style: ProjectStyles.textStyle_30Bold),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text("Заказ №${widget.order.id}",
                          style: ProjectStyles.textStyle_14Medium),
                      Text("Дата создания: ${widget.order.createdAt}",
                          style: ProjectStyles.textStyle_14Medium),
                      Text("Торговая точка: ${widget.order.storeName}",
                          style: ProjectStyles.textStyle_14Medium),
                      Text("Чек №: ${widget.order.checkNumber}",
                          style: ProjectStyles.textStyle_14Medium),
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
                      const SizedBox(height: 10),
                      buildNDSWidget(
                        widget.order.totalPrice,
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
      const DataColumn(label: Text('Код')),
      const DataColumn(label: Text('Артикуль')),
      const DataColumn(label: Text('Название')),
      const DataColumn(label: Text('Ед.')),
      const DataColumn(label: Text('Цена')),
      const DataColumn(label: Text('Колличество')),
      const DataColumn(label: Text('Сумма')),
      // const DataColumn(label: Text('Удалить')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < widget.order.products.length; i++)
        DataRow(cells: [
          DataCell(Text('${i + 1}')),
          DataCell(Text(widget.order.products[i].id_1c ?? '')),
          DataCell(Text(widget.order.products[i].article ?? '')),
          DataCell(Text(widget.order.products[i].name ?? '')),
          DataCell(Text(widget.order.products[i].measure)),
          DataCell(Text('${widget.order.products[i].price.toString()} тг')),
          DataCell(Text(widget.order.products[i].count.toString())),
          DataCell(Text(widget.order.products[i].allPrice.toString())),
          // DataCell(
          //   IconButton(
          //     onPressed: () {
          //       print('detele');
          //     },
          //     icon: const Icon(Icons.delete),
          //   ),
          // )
        ]),
    ];
  }
}
