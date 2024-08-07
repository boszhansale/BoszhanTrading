import 'dart:js' as js;

import 'package:boszhan_trading/models/z_report_model.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/const.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ZReportsPage extends StatefulWidget {
  const ZReportsPage({Key? key}) : super(key: key);

  @override
  State<ZReportsPage> createState() => _ZReportsPageState();
}

class _ZReportsPageState extends State<ZReportsPage> {
  List<ZReportModel> orders = [];

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
                      const Text("Журнал Z отчетов",
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
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Дата')),
      const DataColumn(label: Text('Кассир')),
      const DataColumn(label: Text('Показать')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < orders.length; i++)
        DataRow(cells: [
          DataCell(Text(orders[i].id.toString())),
          DataCell(Text(orders[i].createdAt ?? '')),
          DataCell(Text(orders[i].kassir ?? '')),
          DataCell(
            IconButton(
              onPressed: () {
                js.context.callMethod('open',
                    ['${AppConstants.baseUrl}report/z/${orders[i].id}/print']);
              },
              icon: const Icon(Icons.list),
            ),
          ),
        ]),
    ];
  }

  void getHistory() async {
    try {
      var response = await MainApiService().getZReports(dateFrom, dateTo);

      orders = [];

      for (var item in response) {
        orders.add(ZReportModel.fromJson(item));
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
