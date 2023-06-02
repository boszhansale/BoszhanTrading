import 'package:boszhan_trading/models/discount_card_order_model.dart';
import 'package:boszhan_trading/pages/report/discount_card/discount_card_products.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiscountCardReportPage extends StatefulWidget {
  const DiscountCardReportPage({Key? key}) : super(key: key);

  @override
  State<DiscountCardReportPage> createState() => _DiscountCardReportPageState();
}

class _DiscountCardReportPageState extends State<DiscountCardReportPage> {
  TextEditingController phoneController = TextEditingController();
  List<DiscountCardOrderModel> orders = [];

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
              children: [
                const CustomAppBar(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text("Продажи по дисконтным картам",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Дисконтная карта (тел.): +7',
                            style: ProjectStyles.textStyle_14Medium,
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: SizedBox(
                              width: 150,
                              child: TextField(
                                controller: phoneController,
                                maxLength: 10,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Номер',
                                ),
                                style: ProjectStyles.textStyle_14Regular,
                                onChanged: (value) {
                                  if (value.length == 10 || value.isEmpty) {
                                    getHistory();
                                  }
                                },
                              ),
                            ),
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
                          DiscountCardProductsPage(order: orders[i])),
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
      var response = await MainApiService().getDiscountCardReport(
          phoneController.text.length == 10 ? phoneController.text : '',
          dateFrom,
          dateTo);

      orders = [];

      for (var item in response) {
        orders.add(DiscountCardOrderModel.fromJson(item));
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
