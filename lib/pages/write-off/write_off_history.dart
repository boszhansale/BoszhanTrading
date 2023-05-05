import 'package:boszhan_trading/models/write_off_order_history_model.dart';
import 'package:boszhan_trading/pages/write-off/write_off_order_history_products.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class WriteOffHistoryPage extends StatefulWidget {
  const WriteOffHistoryPage({Key? key}) : super(key: key);

  @override
  State<WriteOffHistoryPage> createState() => _WriteOffHistoryPageState();
}

class _WriteOffHistoryPageState extends State<WriteOffHistoryPage> {
  List<WriteOffOrderHistoryModel> orders = [];

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
                      const Text("Журнал списания",
                          style: ProjectStyles.textStyle_30Bold),
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
      const DataColumn(label: Text('Колл. продуктов')),
      const DataColumn(label: Text('Сумма')),
      const DataColumn(label: Text('Показать')),
      const DataColumn(label: Text('Удалить')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < orders.length; i++)
        DataRow(cells: [
          DataCell(Text('${i + 1}')),
          DataCell(Text(orders[i].id.toString())),
          DataCell(Text(orders[i].storeName ?? '')),
          DataCell(Text(orders[i].productsCount.toString())),
          DataCell(Text(orders[i].totalPrice.toString())),
          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WriteOffOrderHistoryProductsPage(order: orders[i])),
                );
              },
              icon: const Icon(Icons.list),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: () {
                deleteOrderFromHistory(orders[i].id);
              },
              icon: const Icon(Icons.delete),
            ),
          )
        ]),
    ];
  }

  void getHistory() async {
    try {
      var response = await MainApiService().getWriteOffOrderHistory();

      orders = [];

      for (var item in response) {
        orders.add(WriteOffOrderHistoryModel.fromJson(item));
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void deleteOrderFromHistory(int id) async {
    try {
      await MainApiService().deleteWriteOffOrderFromHistory(id);
      getHistory();
    } catch (e) {
      print(e);
    }
  }
}
