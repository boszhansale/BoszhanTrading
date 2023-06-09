import 'dart:convert';

import 'package:boszhan_trading/models/product_main.dart';
import 'package:boszhan_trading/models/user.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/counteragent_selection_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/custom_text_button.dart';
import 'package:boszhan_trading/widgets/nds_widget.dart';
import 'package:boszhan_trading/widgets/payment_calculator_widget.dart';
import 'package:boszhan_trading/widgets/products_list_widget.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  TextEditingController phoneController = TextEditingController();
  String createdTime = '';

  String name = '';
  String storeName = '';
  String storageName = '';
  String organizationName = '';
  String counteragentName = '';
  int counteragentId = 0;

  double sum = 0;
  bool isOnlineSale = false;

  bool isButtonActive = true;

  List<dynamic> basket = [];

  String scannedBarcode = '';
  List<ProductMain> products = [];

  @override
  void initState() {
    _init();
    checkLogin();
    getProducts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

    loadBasket();

    setState(() {});

    Future.delayed(const Duration(milliseconds: 500))
        .whenComplete(() => mounted ? showProductDialog() : null);
  }

  void getProducts() async {
    try {
      var responseProducts = await MainApiService().getProducts();

      for (var i in responseProducts) {
        products.add(ProductMain.fromJson(i));
      }
    } catch (error) {
      showCustomSnackBar(context, error.toString());
    }
  }

  void saveBasket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (basket.isNotEmpty) {
      prefs.setString('SalesBasket', jsonEncode(basket));
    } else {
      prefs.setString('SalesBasket', '[]');
    }
  }

  void loadBasket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String basketString = prefs.getString('SalesBasket') ?? '[]';

    if (basketString != '[]') {
      basket = jsonDecode(basketString);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return ColorPalette.main;
    }

    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            addProductFromScanner(scannedBarcode);
            scannedBarcode = '';
          } else {
            scannedBarcode += event.data.keyLabel;
          }
        }
      },
      child: Scaffold(
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
                            const Text("Новый заказ",
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
                                const SizedBox(height: 10),
                                Text(
                                  'Продавец: $name',
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
                                Row(
                                  children: [
                                    const Text(
                                      'Онлайн продажа:',
                                      style: ProjectStyles.textStyle_14Medium,
                                    ),
                                    Checkbox(
                                      checkColor: Colors.white,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              getColor),
                                      value: isOnlineSale,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isOnlineSale = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Контрагент: $counteragentName',
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
                                Row(
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
                                          style:
                                              ProjectStyles.textStyle_14Regular,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
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
          DataCell(Text(basket[i]['count'].toString())),
          DataCell(Text('${basket[i]['price'] * basket[i]['count']} тг')),
          DataCell(
            IconButton(
              onPressed: () {
                basket.remove(basket[i]);
                saveBasket();
                setState(() {});
              },
              icon: const Icon(Icons.delete),
            ),
          )
        ]),
    ];
  }

  void addProductFromScanner(String barcode) async {
    bool isExist = false;
    for (var product in products) {
      if (product.barcode == barcode) {
        isExist = true;
        bool inBasket = false;
        int index = 0;
        for (int j = 0; j < basket.length; j++) {
          if (basket[j]['id'] == product.id) {
            inBasket = true;
            index = j;
          }
        }
        if (inBasket) {
          basket[index]['count'] = basket[index]['count'] + 1;
        } else {
          basket.add({
            "id": product.id,
            "name": product.name,
            "id_1c": product.id_1c,
            "article": product.article,
            "price": product.price,
            "measure": product.measure,
            "count": 1
          });
        }
      }
    }

    if (isExist == false) {
      showCustomSnackBar(context, 'Данный продукт не найден...');
    }

    sum = 0;
    for (var item in basket) {
      sum += item['count'] * item['price'];
    }
    saveBasket();
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
    basket.add(product);
    sum = 0;
    for (var item in basket) {
      sum += item['count'] * item['price'];
    }

    saveBasket();
    setState(() {});
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

  void selectCounteragent(int id, String name) async {
    counteragentId = id;
    counteragentName = name;
    setState(() {});
  }

  void createOrder() async {
    isButtonActive = false;
    List<dynamic> sendBasketList = [];
    for (var item in basket) {
      sendBasketList.add({'product_id': item['id'], 'count': item['count']});
    }

    try {
      var response = await MainApiService().createSalesOrder(
          isOnlineSale ? 1 : 0,
          1,
          sendBasketList,
          counteragentId,
          phoneController.text);
      print(response);
      showCustomSnackBar(context, 'Заказ успешно создан!');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('SalesBasket', '[]');

      Future.delayed(const Duration(seconds: 2))
          .whenComplete(() => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentCalculatorWidget(
                          orderId: int.parse(response['id'].toString()),
                          totalPrice:
                              double.parse(response['total_price'].toString()),
                        )),
              ));
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
