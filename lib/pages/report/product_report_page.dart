import 'package:boszhan_trading/models/product_report_model.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductReportPage extends StatefulWidget {
  const ProductReportPage({Key? key}) : super(key: key);

  @override
  State<ProductReportPage> createState() => ProductReportPageState();
}

class ProductReportPageState extends State<ProductReportPage> {
  List<ProductReportModel> products = [];

  String dateFrom = '';
  String dateTo = '';

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
                          const Text("Товарный отчет в разрезе",
                              style: ProjectStyles.textStyle_30Bold),
                        ],
                      ),
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
                                        getProducts();
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
                                      getProducts();
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
                      const SizedBox(height: 10),
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

  Widget _createDataTable() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            DataTable(
              columns: _createColumns(),
              rows: _createRows(),
              dataTextStyle: ProjectStyles.textStyle_12Regular,
              headingTextStyle: ProjectStyles.textStyle_12Bold,
            ),
          ],
        ));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Название')),
      const DataColumn(label: Text('Остат нач')),
      const DataColumn(label: Text('Поступило')),
      const DataColumn(label: Text('Возв от покуп')),
      const DataColumn(label: Text('Поступ от постав')),
      const DataColumn(label: Text('Излишки')),
      const DataColumn(label: Text('Перем со скл')),
      const DataColumn(label: Text('Списано общее')),
      const DataColumn(label: Text('Списание')),
      const DataColumn(label: Text('Возв постав')),
      const DataColumn(label: Text('Продажи')),
      const DataColumn(label: Text('Перем со скл')),
      const DataColumn(label: Text('Остат конец')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < products.length; i++)
        DataRow(cells: [
          DataCell(SizedBox(
            width: 100,
            child: Text(products[i].name.substring(
                    0,
                    products[i].name.length > 30
                        ? 30
                        : products[i].name.length) ??
                ''),
          )),
          DataCell(Text(products[i].remainsStart.toString())),
          DataCell(Text(products[i].receiptAll.toString())),
          DataCell(Text(products[i].refund.toString())),
          DataCell(Text(products[i].receipt.toString())),
          DataCell(Text(products[i].overage.toString())),
          DataCell(Text(products[i].movingFrom.toString())),
          DataCell(Text(products[i].reject.toString())),
          DataCell(Text(products[i].rejectAll.toString())),
          DataCell(Text(products[i].refundProducer.toString())),
          DataCell(Text(products[i].order.toString())),
          DataCell(Text(products[i].movingTo.toString())),
          DataCell(Text(products[i].remainsEnd.toString())),
        ]),
    ];
  }

  void getProducts() async {
    try {
      var response = await MainApiService().getProductsReport(dateFrom, dateTo);

      for (var item in response) {
        products.add(ProductReportModel.fromJson(item));
      }
      setState(() {});
    } catch (error) {
      showCustomSnackBar(context, error.toString());
    }
  }
}
