import 'package:boszhan_trading/models/user.dart';
import 'package:boszhan_trading/pages/write-off/refund_reason_write_off_widget.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/custom_text_button.dart';
import 'package:boszhan_trading/widgets/nds_widget.dart';
import 'package:boszhan_trading/widgets/products_list_widget.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewWriteOffPage extends StatefulWidget {
  const NewWriteOffPage({Key? key}) : super(key: key);

  @override
  State<NewWriteOffPage> createState() => _NewWriteOffPageState();
}

class _NewWriteOffPageState extends State<NewWriteOffPage> {
  String createdTime = '';
  Object writeOffSelectedValue = 0;

  String name = '';
  String storeName = '';
  String storageName = '';
  String organizationName = '';
  String counteragentName = '';
  int counteragentId = 0;

  dynamic selectedProduct;

  double sum = 0;

  bool isButtonActive = true;

  List<dynamic> basket = [];

  @override
  void initState() {
    _init();
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

  _init() async {
    createdTime = DateFormat('dd.MM.yy HH:mm').format(DateTime.now());
    User? user = await AuthRepository().getUserFromCache();
    name = user?.name ?? '';
    storeName = user?.storeName ?? '';
    storageName = user?.storageName ?? '';
    organizationName = user?.organizationName ?? '';

    setState(() {});
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("Новый документ списания",
                              style: ProjectStyles.textStyle_30Bold),
                          const Spacer(),
                          customTextButton(
                            () {
                              if (basket.isNotEmpty && isButtonActive) {
                                createOrder();
                              }
                            },
                            title: 'Сохранить',
                            width: 200,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Магазин: $storeName',
                                style: ProjectStyles.textStyle_14Medium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Склад: $storageName',
                                style: ProjectStyles.textStyle_14Medium,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'От: $createdTime',
                                style: ProjectStyles.textStyle_14Medium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Организация: $organizationName',
                                style: ProjectStyles.textStyle_14Medium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text("Товары:",
                              style: ProjectStyles.textStyle_22Bold),
                          IconButton(
                              onPressed: () {
                                showProductDialog();
                              },
                              icon: const Icon(Icons.add_circle))
                        ],
                      ),
                      const SizedBox(height: 10),
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
                        sum,
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
      const DataColumn(label: Text('Коммен.')),
      const DataColumn(label: Text('Ед.')),
      const DataColumn(label: Text('Цена')),
      const DataColumn(label: Text('Колличество')),
      const DataColumn(label: Text('Сумма')),
      const DataColumn(label: Text('Удалить')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < basket.length; i++)
        DataRow(cells: [
          DataCell(Text('${i + 1}')),
          DataCell(Text(basket[i]['id_1c'])),
          DataCell(Text(basket[i]['article'])),
          DataCell(Text(basket[i]['name'])),
          DataCell(Text(basket[i]['reason_refund_comment'])),
          DataCell(Text(basket[i]['measure'])),
          DataCell(Text('${basket[i]['price']} тг')),
          DataCell(Text(basket[i]['count'].toString())),
          DataCell(Text('${basket[i]['price'] * basket[i]['count']} тг')),
          DataCell(
            IconButton(
              onPressed: () {
                basket.remove(basket[i]);
                setState(() {});
              },
              icon: const Icon(Icons.delete),
            ),
          )
        ]),
    ];
  }

  void showReasonDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Причина списания'),
          content: RefundReasonWriteOffWidget(
            selectReason: selectReason,
          ),
        );
      },
    );
  }

  void selectReason(String comment) async {
    selectedProduct['reason_refund_comment'] = comment;
    basket.add(selectedProduct);
    sum = 0;
    for (var item in basket) {
      sum += item['count'] * item['price'];
    }
    setState(() {});
  }

  void showProductDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавление продукта'),
          content: ProductsListWidget(
            addToBasket: addToBasket,
          ),
        );
      },
    );
  }

  void addToBasket(dynamic product) async {
    selectedProduct = product;
    showReasonDialog();
  }

  void createOrder() async {
    isButtonActive = false;
    List<dynamic> sendBasketList = [];
    for (var item in basket) {
      sendBasketList.add({
        'product_id': item['id'],
        'count': item['count'],
        'comment': item['reason_refund_comment'],
      });
    }

    try {
      var response = await MainApiService().createWriteOffOrder(sendBasketList);
      // print(response);
      showCustomSnackBar(context, 'Заказ успешно создан!');
      Future.delayed(const Duration(seconds: 2))
          .whenComplete(() => Navigator.of(context).pushNamed('/home'));
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
