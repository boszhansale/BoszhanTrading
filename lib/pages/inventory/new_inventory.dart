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

  List<dynamic> basket = [];

  List<ProductMain> products = [];
  String scannedBarcode = '';

  bool dialogIsActive = false;

  List<TextEditingController> basketTextFields = [];

  @override
  void initState() {
    getInventoryProducts();
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
      // const DataColumn(label: Text('Ед.')),
      // const DataColumn(label: Text('Цена')),
      const DataColumn(label: Text('Перемещение')),
      const DataColumn(label: Text('Поступление')),
      const DataColumn(label: Text('Продажа')),
      const DataColumn(label: Text('Остатки')),
      const DataColumn(label: Text('Колличество')),
      const DataColumn(label: Text('Разница')),
      // const DataColumn(label: Text('Сумма')),
      // const DataColumn(label: Text('Удалить')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < basket.length; i++)
        DataRow(cells: [
          DataCell(Text('${i + 1}')),
          DataCell(Text(basket[i]['product_id'].toString() ?? '')),
          DataCell(Text(basket[i]['article'] ?? '')),
          DataCell(Text(basket[i]['name'] ?? '')),
          // DataCell(Text(basket[i]['measure'])),
          // DataCell(Text('${basket[i]['price']} тг')),
          DataCell(Text(basket[i]['moving'].toString())),
          DataCell(Text(basket[i]['receipt'].toString())),
          DataCell(Text(basket[i]['sale'].toString())),
          DataCell(Text(basket[i]['remains'].toString())),
          DataCell(Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              width: 50,
              child: TextField(
                controller: basketTextFields[i],
                decoration: const InputDecoration(hintText: 'кл.'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          )),
          DataCell(
            Text(
              (double.parse(basket[i]['remains'].toString()) -
                      double.parse(basketTextFields[i].text == ''
                          ? '0'
                          : basketTextFields[i].text))
                  .toString(),
            ),
          ),
          // DataCell(Text('${basket[i]['price'] * basket[i]['count']} тг')),
          // DataCell(
          //   IconButton(
          //     onPressed: () {
          //       basket.remove(basket[i]);
          //       setState(() {});
          //     },
          //     icon: const Icon(Icons.delete),
          //   ),
          // )
        ]),
    ];
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

  void addToBasket(dynamic product) async {
    selectedProduct = product;

    addProduct(selectedProduct['id'], selectedProduct['count']);
  }

  void addProduct(int productId, double count) async {
    try {
      var response =
          await MainApiService().addProductToInventoryOrder(productId, count);

      getInventoryProducts();
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }

  void createOrder() async {
    for (var i in basketTextFields) {
      if (i.text.isEmpty) {
        showCustomSnackBar(context, 'Заполните все поля!');
        return;
      }
    }
    isButtonActive = false;
    List<dynamic> sendBasketList = [];
    for (int i = 0; i < basket.length; i++) {
      var tempMap = basket[i];
      tempMap['count'] = basketTextFields[i].text;
      sendBasketList.add(tempMap);
    }

    try {
      var response =
          await MainApiService().createInventoryOrder(sendBasketList);
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

  void getInventoryProducts() async {
    try {
      var response = await MainApiService().getInventoryProducts();
      basket = response;
      basketTextFields = [];
      setState(() {});
      for (var i in response) {
        basketTextFields.add(TextEditingController());
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString());
      print(e);
    }
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

  void addProductFromScanner(String barcode) async {
    bool isExist = false;
    for (var product in products) {
      if (product.barcode == barcode) {
        isExist = true;
        bool inBasket = false;
        int index = 0;
        for (int j = 0; j < basket.length; j++) {
          if (basket[j]['product_id'] == product.id) {
            inBasket = true;
            index = j;
          }
        }
        if (dialogIsActive) {
          addProduct(product.id, 1);
        } else {
          if (inBasket) {
            basketTextFields[index].text = (double.parse(
                        basketTextFields[index].text == ''
                            ? '0'
                            : basketTextFields[index].text) +
                    1)
                .toString();
          } else {
            showCustomSnackBar(
                context, 'Данный продукт не находится в списке поступлении.');
            // addProduct(product.id, 1);
          }
        }
      }
    }

    if (isExist == false) {
      showCustomSnackBar(context, 'Данный продукт не найден...');
    }
  }
}
