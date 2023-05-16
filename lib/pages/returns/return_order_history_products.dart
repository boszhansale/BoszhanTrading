import 'package:boszhan_trading/models/return_order_history_model.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ReturnOrderHistoryProductsPage extends StatefulWidget {
  const ReturnOrderHistoryProductsPage({Key? key, required this.order})
      : super(key: key);

  final ReturnOrderHistoryModel order;

  @override
  State<ReturnOrderHistoryProductsPage> createState() =>
      _ReturnOrderHistoryProductsPageState();
}

class _ReturnOrderHistoryProductsPageState
    extends State<ReturnOrderHistoryProductsPage> {
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
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            'Сумма с НДС: ${widget.order.totalPrice} тг',
                            style: ProjectStyles.textStyle_14Bold,
                          ),
                          const Spacer(),
                          Text(
                            'НДС: ${widget.order.totalPrice * 0.12} тг',
                            style: ProjectStyles.textStyle_14Bold,
                          ),
                          const Spacer(),
                        ],
                      )
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
      const DataColumn(label: Text('Причина')),
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
          DataCell(Text(widget.order.products[i].returnReasonTitle ?? '')),
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
