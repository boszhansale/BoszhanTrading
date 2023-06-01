import 'package:boszhan_trading/models/online_sale_model.dart';
import 'package:boszhan_trading/pages/report/online_sale/online_sale_products.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class OnlineSaleReportReportPage extends StatefulWidget {
  const OnlineSaleReportReportPage({Key? key}) : super(key: key);

  @override
  State<OnlineSaleReportReportPage> createState() =>
      _OnlineSaleReportReportPageState();
}

class _OnlineSaleReportReportPageState
    extends State<OnlineSaleReportReportPage> {
  List<OnlineSaleOrderModel> orders = [];

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
              children: [
                const CustomAppBar(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text("Онлайн продажи",
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
      const DataColumn(label: Text('Дата')),
      const DataColumn(label: Text('Колл. продуктов')),
      const DataColumn(label: Text('Сумма')),
      const DataColumn(label: Text('Кэшбэк')),
      const DataColumn(label: Text('Показать')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < orders.length; i++)
        DataRow(cells: [
          DataCell(Text('${i + 1}')),
          DataCell(Text(orders[i].id.toString())),
          DataCell(Text(orders[i].createdAt ?? '')),
          DataCell(Text(orders[i].productsCount.toString())),
          DataCell(Text('${orders[i].totalPrice} тг')),
          DataCell(Text('${orders[i].discountCashback} тг')),
          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OnlineSaleProductsPage(order: orders[i])),
                );
              },
              icon: const Icon(Icons.list),
            ),
          ),
        ]),
    ];
  }

  void getHistory() async {
    try {
      var response = await MainApiService().getOnlineSaleReport();

      orders = [];

      for (var item in response) {
        orders.add(OnlineSaleOrderModel.fromJson(item));
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
