import 'package:boszhan_trading/models/report_model.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';

class ZReportPage extends StatefulWidget {
  const ZReportPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ZReportPage> createState() => _ZReportPageState();
}

class _ZReportPageState extends State<ZReportPage> {
  ReportModel report = ReportModel();

  @override
  void initState() {
    _init();
    super.initState();
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
                const SizedBox(height: 30),
                report.taxPayerVATSeria != null
                    ? buildReport()
                    : const Center(
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _init() async {
    try {
      var response = await MainApiService().requestZReport();
      // print(response);
      report = ReportModel.fromJson(response);
      setState(() {});
    } catch (e) {
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }

  Widget buildReport() {
    return Container(
      width: 360,
      decoration: BoxDecoration(
          color: ColorPalette.white,
          border: Border.all(width: 1, color: ColorPalette.black)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            report.taxPayerName ?? '',
            style: ProjectStyles.textStyle_10Medium,
          ),
          Text(
            'БИН ${report.taxPayerIN}',
            style: ProjectStyles.textStyle_10Medium,
          ),
          Text(
            'НДС Cерия ${report.taxPayerVATSeria} №${report.taxPayerVATNumber}',
            style: ProjectStyles.textStyle_10Medium,
          ),
          const Divider(),
          const Text(
            'СМЕННЫЙ X-ОТЧЕТ',
            style: ProjectStyles.textStyle_10Medium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Документ №${report.reportNumber}',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                'Код кассира ${report.cashierCode}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          Text(
            'Смена №${report.shiftNumber}',
            style: ProjectStyles.textStyle_10Medium,
          ),
          Text(
            '${report.startOn} - ${report.closeOn}',
            style: ProjectStyles.textStyle_10Medium,
          ),
          const Text(
            'НЕОБНУЛЯЕМАЯ СУММА НА НАЧАЛО СМЕНЫ',
            style: ProjectStyles.textStyle_10Medium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Продаж',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                    Text(
                      '${report.startNonNullable?.sell ?? 0}',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Покупок',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                    Text(
                      '${report.startNonNullable?.buy ?? 0}',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Возвратов продаж',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                    Text(
                      '${report.startNonNullable?.returnSell ?? 0}',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Возвратов покупок',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                    Text(
                      '${report.startNonNullable?.returnBuy ?? 0}',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ПРОДАЖА x ${report.sell?.count ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                '${report.sell?.markup ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ПОКУПКА x ${report.buy?.count ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                '${report.buy?.markup ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ВОЗВРАТ ПРОДАЖИ x ${report.returnSell?.count ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                '${report.returnSell?.markup ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ВОЗВРАТ ПОКУПКИ x ${report.returnBuy?.count ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                '${report.returnBuy?.markup ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          const Text(
            'НЕОБНУЛЯЕМАЯ СУММА НА КОНЕЦ СМЕНЫ',
            style: ProjectStyles.textStyle_10Medium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Продаж',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                    Text(
                      '${report.endNonNullable?.sell ?? 0}',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Покупок',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                    Text(
                      '${report.endNonNullable?.buy ?? 0}',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Возвратов продаж',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                    Text(
                      '${report.endNonNullable?.returnSell ?? 0}',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Возвратов покупок',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                    Text(
                      '${report.endNonNullable?.returnBuy ?? 0}',
                      style: ProjectStyles.textStyle_10Medium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Внесения',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                '${report.putMoneySum ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Изъятия',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                '${report.takeMoneySum ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'НАЛИЧНЫХ В КАССЕ',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                '${report.sumInCashbox ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Контрольное значение',
                style: ProjectStyles.textStyle_10Medium,
              ),
              Text(
                '${report.controlSum ?? 0}',
                style: ProjectStyles.textStyle_10Medium,
              ),
            ],
          ),
          Text(
            'Количество документов сформированных за смену: ${report.documentCount}',
            style: ProjectStyles.textStyle_10Medium,
          ),
          Text(
            'Сформировано оператором фискальных данных: ${report.ofd?.name ?? ''}',
            style: ProjectStyles.textStyle_10Medium,
            textAlign: TextAlign.center,
          ),
          const Divider(),
          const Text(
            '*** Конец отчета ***',
            style: ProjectStyles.textStyle_10Medium,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
