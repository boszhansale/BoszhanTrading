import 'package:boszhan_trading/components/debouncer_text_field.dart';
import 'package:boszhan_trading/models/product_main.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/custom_text_button.dart';
import 'package:boszhan_trading/widgets/products_list_widget.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

List<dynamic> globalInventoryList = [];
List<TextEditingController> globalInventoryTextFields = [];
List<String> globalInventoryRemains = [];

class NewInventoryPage extends StatefulWidget {
  const NewInventoryPage({Key? key}) : super(key: key);

  @override
  State<NewInventoryPage> createState() => _NewInventoryPageState();
}

class _NewInventoryPageState extends State<NewInventoryPage> {
  String createdTime = '';

  String name = '';
  String storeName = '';
  String storageName = '';
  String organizationName = '';

  dynamic selectedProduct;

  bool isButtonActive = true;

  Map<int, dynamic> savedCounts = {};

  List<ProductMain> products = [];
  String scannedBarcode = '';

  bool dialogIsActive = false;

  var date = '';
  var time = '';

  @override
  void initState() {
    DateTime now = DateTime.now();
    date = DateFormat('yyyy-MM-dd').format(now);
    time = DateFormat('HH:mm:ss').format(now);
    getInventoryProducts(date, time);
    getProducts();
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
                            const Text("Новый документ инвентаризации",
                                style: ProjectStyles.textStyle_30Bold),
                            const Spacer(),
                            customTextButton(
                              () {
                                if (isButtonActive) {
                                  createOrder();
                                }
                              },
                              title: 'Сохранить',
                              width: 200,
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
                                icon: const Icon(Icons.add_circle)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                ).then((pickedDate) {
                                  if (pickedDate == null) {
                                    return;
                                  }
                                  setState(() {
                                    date = DateFormat('yyyy-MM-dd')
                                        .format(pickedDate);
                                  });
                                });

                                await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  initialEntryMode: TimePickerEntryMode.dial,
                                ).then((value) {
                                  if (value != null) {
                                    time =
                                        '${value.hour < 10 ? '0${value.hour}' : value.hour}:${value.minute < 10 ? '0${value.minute}' : value.minute}:00';
                                    setState(() {});
                                  }
                                });

                                if (date != '' && time != '') {
                                  getInventoryProducts(date, time);
                                }
                              },
                              child: Text(
                                  date == '' ? 'выбрать' : '$date $time',
                                  style: ProjectStyles.textStyle_22Bold
                                      .copyWith(color: ColorPalette.main)),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          // height: 600,
                          child: SingleChildScrollView(
                            child: Material(
                              elevation: 3,
                              child: Container(
                                color: ColorPalette.white,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          SizedBox(
                                              width: 30,
                                              child: Text(
                                                '№',
                                                textAlign: TextAlign.center,
                                              )),
                                          SizedBox(
                                              width: 50,
                                              child: Text(
                                                'Код',
                                                textAlign: TextAlign.center,
                                              )),
                                          SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Арти.',
                                                textAlign: TextAlign.center,
                                              )),
                                          SizedBox(width: 10),
                                          SizedBox(
                                              width: 600,
                                              child: Text(
                                                'Название',
                                                textAlign: TextAlign.center,
                                              )),
                                          SizedBox(width: 10),
                                          SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Перем.',
                                                textAlign: TextAlign.center,
                                              )),
                                          SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Пост.',
                                                textAlign: TextAlign.center,
                                              )),
                                          SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Прод.',
                                                textAlign: TextAlign.center,
                                              )),
                                          SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Оста.',
                                                textAlign: TextAlign.center,
                                              )),
                                          // SizedBox(
                                          //     width: 80,
                                          //     child: Text(
                                          //       'Изли.',
                                          //       textAlign: TextAlign.center,
                                          //     )),
                                          // SizedBox(
                                          //     width: 80,
                                          //     child: Text(
                                          //       'Недос.',
                                          //       textAlign: TextAlign.center,
                                          //     )),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              'Колл.',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 80,
                                              child: Text(
                                                'Разн.',
                                                textAlign: TextAlign.center,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    _createProductList(),
                                  ],
                                ),
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
      ),
    );
  }

  ListView _createProductList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: globalInventoryList.length,
      itemBuilder: (BuildContext context, int index) {
        final product = globalInventoryList[index];

        return Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 30, child: Text((index + 1).toString())),
                  SizedBox(
                      width: 50,
                      child: Text((product['product_id'] ?? '').toString())),
                  SizedBox(width: 80, child: Text(product['article'] ?? '')),
                  const SizedBox(width: 10),
                  SizedBox(width: 600, child: Text(product['name'] ?? '')),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: 80, child: Text(product['moving_from'] ?? '')),
                  SizedBox(width: 80, child: Text(product['receipt'] ?? '')),
                  SizedBox(width: 80, child: Text(product['sale'] ?? '')),
                  SizedBox(width: 80, child: Text(product['remains'] ?? '')),
                  // SizedBox(width: 80, child: Text(product['overage'] ?? '')),
                  // SizedBox(width: 80, child: Text(product['overage'] ?? '')),
                  SizedBox(
                    width: 80,
                    child: DebouncerTextField(
                      controller: globalInventoryTextFields[index],
                      onValueChanged: (value) {
                        setState(() {
                          globalInventoryRemains[index] =
                              ((double.tryParse(value.replaceAll(',', '.')) ??
                                          0) -
                                      (double.parse(globalInventoryList[index]
                                              ['remains']
                                          .toString())))
                                  .toString();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                      width: 80,
                      child: Text(globalInventoryRemains[index]
                          // (double.parse(
                          //             globalInventoryTextFields[index].text == ''
                          //                 ? '0'
                          //                 : globalInventoryTextFields[index]
                          //                     .text
                          //                     .replaceAll(',', '.')) -
                          //         double.parse(globalInventoryList[index]
                          //                 ['remains']
                          //             .toString()))
                          //     .toString(),
                          )),
                ],
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('№')),
      const DataColumn(label: Text('Код')),
      const DataColumn(label: Text('Артикуль')),
      const DataColumn(label: Text('Название')),
      // const DataColumn(label: Text('Ед.')),
      // const DataColumn(label: Text('Цена')),
      const DataColumn(label: Text('Перемещение')),
      const DataColumn(label: Text('Поступление')),
      const DataColumn(label: Text('Продажа')),
      // const DataColumn(label: Text('Остаток')),
      // const DataColumn(label: Text('Излишки')),
      const DataColumn(label: Text('Недостачи')),
      const DataColumn(label: Text('Колличество')),
      const DataColumn(label: Text('Разница')),
      // const DataColumn(label: Text('Сумма')),
      // const DataColumn(label: Text('Удалить')),
    ];
  }

  void addToBasket(dynamic product) async {
    selectedProduct = product;

    addProduct(selectedProduct['id'], selectedProduct['count']);
  }

  void addProduct(int productId, double count) async {
    try {
      saveCountOfProduct();
      var response =
          await MainApiService().addProductToInventoryOrder(productId, count);

      DateTime now = DateTime.now();
      date = DateFormat('yyyy-MM-dd').format(now);
      time = DateFormat('HH:mm:ss').format(now);

      getInventoryProducts(date, time);
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }

  void showProductDialog() async {
    dialogIsActive = true;

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
    ).whenComplete(() => dialogIsActive = false);
  }

  void createOrder() async {
    isButtonActive = false;
    List<dynamic> sendBasketList = [];
    for (int i = 0; i < globalInventoryList.length; i++) {
      if (globalInventoryTextFields[i].text.isNotEmpty) {
        var tempMap = globalInventoryList[i];
        tempMap['count'] =
            globalInventoryTextFields[i].text.replaceAll(',', '.');
        sendBasketList.add(tempMap);
      }
    }

    // print(sendBasketList);

    try {
      DateTime now = DateTime.now();
      var sendDate = DateFormat('yyyy-MM-dd').format(now);
      var sendTime = DateFormat('HH:mm:ss').format(now);
      var response = await MainApiService()
          .createInventoryOrder(sendBasketList, sendDate, sendTime);
      print(response);
      showCustomSnackBar(context, 'Заказ успешно создан!');
      Future.delayed(const Duration(seconds: 2))
          .whenComplete(() => Navigator.of(context).pushNamed('/home'));
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }

  void getProducts() async {
    try {
      var responseProducts = await MainApiService().getProducts(true);

      for (var i in responseProducts) {
        products.add(ProductMain.fromJson(i));
      }
    } catch (error) {
      showCustomSnackBar(context, error.toString());
    }
  }

  void getInventoryProducts(String date, String time) async {
    try {
      var response = await MainApiService().getInventoryProducts(date, time);
      globalInventoryList = response;
      globalInventoryTextFields = [];
      globalInventoryRemains = [];
      setState(() {});
      for (int i = 0; i < response.length; i++) {
        if (savedCounts.containsKey(response[i]['product_id'])) {
          globalInventoryTextFields.add(TextEditingController(
              text: savedCounts[response[i]['product_id']].toString()));
        } else {
          globalInventoryTextFields.add(TextEditingController(text: '0'));
        }
      }

      for (int i = 0; i < response.length; i++) {
        globalInventoryRemains.add(((double.tryParse(
                        globalInventoryTextFields[i]
                            .text
                            .replaceAll(',', '.')) ??
                    0) -
                double.parse(response[i]['remains'].toString()))
            .toString());
      }

      setState(() {});
    } catch (e) {
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }

  refresh() {
    setState(() {});
  }

  void addProductFromScanner(String barcode) async {
    var response = await MainApiService().searchProductByBarcode(barcode);
    if (response.isNotEmpty) {
      ProductMain product = ProductMain.fromJson(response[0]);
      bool inBasket = false;
      int index = 0;
      for (int j = 0; j < globalInventoryList.length; j++) {
        if (globalInventoryList[j]['product_id'] == product.id) {
          inBasket = true;
          index = j;
        }
      }
      if (dialogIsActive) {
        addProduct(product.id, 1);
      } else {
        if (inBasket) {
          globalInventoryTextFields[index].text = (double.parse(
                      globalInventoryTextFields[index].text == ''
                          ? '0'
                          : globalInventoryTextFields[index].text) +
                  1)
              .toString();
          setState(() {});
        } else {
          showCustomSnackBar(
              context, 'Данный продукт не находится в списке поступлении.');
          // addProduct(product.id, 1);
        }
      }
    } else {
      showCustomSnackBar(context, 'Данный продукт не найден...');
    }
  }

  void saveCountOfProduct() {
    savedCounts = {};
    for (int i = 0; i < globalInventoryTextFields.length; i++) {
      if (globalInventoryTextFields[i].text != '') {
        savedCounts[globalInventoryList[i]['product_id']] =
            double.parse(globalInventoryTextFields[i].text);
      } else {
        savedCounts[globalInventoryList[i]['product_id']] = 0;
      }
    }
  }
}
