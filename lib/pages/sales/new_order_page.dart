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
  const NewOrderPage({Key? key, required this.unfinishedBasket})
      : super(key: key);

  final List<dynamic> unfinishedBasket;

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
  List<TextEditingController> countControllers = [];

  String scannedBarcode = '';

  Map<dynamic, double> productsPermission = {};

  @override
  void initState() {
    _init();
    checkLogin();
    getInventoryProducts();
    super.initState();

    if (widget.unfinishedBasket != []) {
      for (var item in widget.unfinishedBasket) {
        basket.add(item);
        countControllers
            .add(TextEditingController(text: item['count'].toString()));
      }
    }
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
      for (var item in basket) {
        countControllers
            .add(TextEditingController(text: item['count'].toString()));
      }
      calcSum();
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
                            const Text("Новая продажа",
                                style: ProjectStyles.textStyle_30Bold),
                            const Spacer(),
                            customTextButton(
                              () {
                                if (basket.isNotEmpty) {
                                  saveUnfinished();
                                }
                              },
                              title: 'Сохранить черновик',
                              width: 280,
                            ),
                            const SizedBox(width: 20),
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
                          height: 550,
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
      const DataColumn(label: Text('Скидка')),
      const DataColumn(label: Text('Колличество')),
      const DataColumn(label: Text('Сумма')),
      const DataColumn(label: Text('Удалить')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < basket.length; i++)
        DataRow(
            color: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (basket[i]['discount_price'] == 0 ||
                  basket[i]['discount_price'] == null) {
                return Colors.white;
              }
              return Colors.yellow[100]!;
            }),
            cells: [
              DataCell(Text('${i + 1}')),
              DataCell(Text(basket[i]['id_1c'])),
              DataCell(Text(basket[i]['article'])),
              DataCell(Text(basket[i]['name'])),
              DataCell(Text(basket[i]['measure'])),
              DataCell(Text('${basket[i]['price']} тг')),
              DataCell(Text(basket[i]['discount_price'] == 0 ||
                      basket[i]['discount_price'] == null
                  ? 'Нет'
                  : '${basket[i]['discount_price']} тг')),
              DataCell(
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: countControllers[i],
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        basket[i]['measure'] == 'шт'
                            ? RegExp(r'^\d+')
                            : RegExp(r'^\d+[\.]?\d{0,2}'),
                      ),
                    ],
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {});
                        calcSum();
                      }
                    },
                  ),
                ),
              ),
              DataCell(Text(
                  '${(basket[i]['discount_price'] != 0 || basket[i]['discount_price'] != null ? (basket[i]['price'] - basket[i]['discount_price']) : basket[i]['price']) * (double.tryParse(countControllers[i].text) ?? 0)} тг')),
              DataCell(
                IconButton(
                  onPressed: () {
                    basket.remove(basket[i]);
                    countControllers.remove(countControllers[i]);

                    calcSum();
                    saveBasket();
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete),
                ),
              )
            ]),
    ];
  }

  void calcSum() async {
    sum = 0;
    for (int i = 0; i < basket.length; i++) {
      if (basket[i]['discount_price'] != 0 ||
          basket[i]['discount_price'] != null) {
        sum += (double.tryParse(countControllers[i].text) ?? 0) *
            (basket[i]['price'] - basket[i]['discount_price']);
      } else {
        sum += (double.tryParse(countControllers[i].text) ?? 0) *
            basket[i]['price'];
      }
    }
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

  void addProductFromScanner(String barcode) async {
    var response = await MainApiService().searchProductByBarcode(barcode);
    if (response.isNotEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ProductMain product = ProductMain.fromJson(response[0]);
      bool inBasket = false;
      int index = 0;
      for (int j = 0; j < basket.length; j++) {
        if (basket[j]['id'] == product.id) {
          inBasket = true;
          index = j;
        }
      }
      if (inBasket) {
        // if (productsPermission[product.id]! > basket[index]['count']) {
        basket[index]['count'] = basket[index]['count'] + 1;
        countControllers[index].text =
            (double.parse(countControllers[index].text) + 1).toString();
        // } else {
        //   showCustomSnackBar(context, 'Вы не можете продавать данный товар');
        // }
      } else {
        // if (productsPermission[product.id]! > 0) {
        basket.add({
          "id": product.id,
          "name": product.name,
          "id_1c": product.id_1c,
          "article": product.article,
          "price": product.price,
          "discount_price": product.discountPrice,
          "measure": product.measure,
          "count": 1
        });
        countControllers.add(TextEditingController(text: '1'));
        // } else {
        //   showCustomSnackBar(context, 'Вы не можете продавать данный товар');
        // }
      }
    } else {
      showCustomSnackBar(context, 'Данный продукт не найден...');
    }

    calcSum();
    saveBasket();
    setState(() {});
  }

  void addToBasket(dynamic product) async {
    if ((productsPermission[product['id']] ?? 0) >= product['count']) {
      bool inBasket = false;
      int index = 0;
      for (int j = 0; j < basket.length; j++) {
        if (basket[j]['id'] == product['id']) {
          inBasket = true;
          index = j;
        }
      }
      if (inBasket) {
        // if (productsPermission[product.id]! > basket[index]['count']) {
        basket[index]['count'] = basket[index]['count'] + product['count'];
        countControllers[index].text =
            (double.parse(countControllers[index].text) + product['count'])
                .toString();
        // } else {
        //   showCustomSnackBar(context, 'Вы не можете продавать данный товар');
        // }
      } else {
        basket.add(product);
        countControllers
            .add(TextEditingController(text: product['count'].toString()));
      }

      calcSum();

      saveBasket();
      if (mounted) {
        setState(() {});
      }
    } else {
      showCustomSnackBar(context,
          'Вы не можете добавить данный товар. Продукт отсутствует в вашем магазине.');
    }
  }

  void createOrder() async {
    isButtonActive = false;
    List<dynamic> sendBasketList = [];
    for (int i = 0; i < basket.length; i++) {
      if ((productsPermission[basket[i]['id']] ?? 0) >=
          double.parse(countControllers[i].text)) {
        sendBasketList.add(
            {'product_id': basket[i]['id'], 'count': countControllers[i].text});
      } else {
        showCustomSnackBar(context,
            'Вы не можете продавать больше чем у вас есть. Продукт: ${basket[i]["name"]}.');
        isButtonActive = true;
        return;
      }
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
                          isSale: true,
                        )),
              ));
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }

  void saveUnfinished() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> list = [];

    Map<String, dynamic> thisMap = {
      'createdAt': DateTime.now().toString(),
      'basket': basket,
    };

    if (prefs.containsKey('UnfinishedOrders')) {
      list = json.decode(prefs.getString('UnfinishedOrders') ?? '[]');
      list.add(thisMap);
    } else {
      list.add(thisMap);
    }

    prefs.setString('UnfinishedOrders', json.encode(list));

    Navigator.of(context).pushNamed('/home');
  }

  void getInventoryProducts() async {
    try {
      DateTime now = DateTime.now();
      var date = DateFormat('yyyy-MM-dd').format(now);
      var time = DateFormat('HH:mm:ss').format(now);
      var response = await MainApiService().getInventoryProducts(date, time);

      for (var i in response) {
        double? remains = double.tryParse(i['remains']);
        if (remains != null) {
          productsPermission[i['product_id']] = remains;
        } else {
          productsPermission[i['product_id']] = 0;
        }
      }

      setState(() {});
    } catch (e) {
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
