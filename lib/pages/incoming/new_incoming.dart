import 'package:boszhan_trading/models/user.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/calculateNDS.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/counteragent_selection_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/custom_text_button.dart';
import 'package:boszhan_trading/widgets/input_price_widget.dart';
import 'package:boszhan_trading/widgets/products_list_widget.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewIncomingPage extends StatefulWidget {
  const NewIncomingPage({Key? key}) : super(key: key);

  @override
  State<NewIncomingPage> createState() => _NewIncomingPageState();
}

class _NewIncomingPageState extends State<NewIncomingPage> {
  String createdTime = '';
  Object operationSelectedValue = 0;

  String name = '';
  String bank = '';
  String storeName = '';
  String storageName = '';
  String organizationName = '';
  String counteragentName = '';
  int counteragentId = 0;

  double sum = 0;
  bool isButtonActive = true;
  dynamic selectedProduct;

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
    bank = user?.bank ?? '';
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
                          const Text("Новое поступление",
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
                              const SizedBox(height: 10),
                              Text(
                                'Организация: $organizationName',
                                style: ProjectStyles.textStyle_14Medium,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Поставщик: $counteragentName',
                                    style: ProjectStyles.textStyle_14Medium,
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                      onPressed: () {
                                        showCounteragentDialog();
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
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
                                'Банковский счет: $bank',
                                style: ProjectStyles.textStyle_14Medium,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Операция:',
                                    style: ProjectStyles.textStyle_14Medium,
                                  ),
                                  const SizedBox(width: 10),
                                  DropdownButton(
                                    value: operationSelectedValue,
                                    items: const [
                                      DropdownMenuItem(
                                          child: Text("Поступление товара"),
                                          value: 0),
                                      DropdownMenuItem(
                                          child: Text("Оприходование излишков"),
                                          value: 1),
                                    ],
                                    onChanged: (Object? newValue) {
                                      setState(() {
                                        operationSelectedValue = newValue!;
                                      });
                                    },
                                  )
                                ],
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
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            'Сумма с НДС: $sum тг',
                            style: ProjectStyles.textStyle_14Bold,
                          ),
                          const Spacer(),
                          Text(
                            'НДС: ${calculateNDS(sum)} тг',
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
      const DataColumn(label: Text('Ед.')),
      const DataColumn(label: Text('Старая цена')),
      const DataColumn(label: Text('Новая цена')),
      const DataColumn(label: Text('Отн. цен')),
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
          DataCell(Text(basket[i]['measure'])),
          DataCell(Text('${basket[i]['price']} тг')),
          DataCell(Text('${basket[i]['newPrice']} тг')),
          DataCell(Text(
              '${(basket[i]['price'] / basket[i]['newPrice']).toString().substring(0, 4)}%')),
          DataCell(Text(basket[i]['count'].toString())),
          DataCell(Text('${basket[i]['newPrice'] * basket[i]['count']} тг')),
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
    showPriceDialog();
  }

  void showCounteragentDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите контрагента:'),
          content: CounteragentSelectionWidget(
            selectCounteragent: selectCounteragent,
          ),
        );
      },
    );
  }

  void showPriceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Новая цена:'),
          content: InputPriceWidget(
            inputPrice: inputPrice,
          ),
        );
      },
    );
  }

  void inputPrice(double price) async {
    selectedProduct['newPrice'] = price;
    basket.add(selectedProduct);
    sum = 0;
    for (var item in basket) {
      sum += item['count'] * item['newPrice'];
    }
    setState(() {});
  }

  void selectCounteragent(int id, String name) async {
    counteragentId = id;
    counteragentName = name;
    setState(() {});
  }

  void createOrder() async {
    isButtonActive = false;
    List<dynamic> sendBasketList = [];
    for (var item in basket) {
      sendBasketList.add({
        'product_id': item['id'],
        'count': item['count'],
        'price': item['newPrice']
      });
    }

    try {
      var response = await MainApiService().createIncomingOrder(
          int.parse(operationSelectedValue.toString()) + 1,
          bank,
          sendBasketList,
          counteragentId);
      print(response);
      showCustomSnackBar(context, 'Заказ успешно создан!');
      Future.delayed(const Duration(seconds: 3))
          .whenComplete(() => Navigator.of(context).pushNamed('/home'));
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
