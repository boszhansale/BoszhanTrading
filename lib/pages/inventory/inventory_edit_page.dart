import 'package:boszhan_trading/components/debouncer_text_field.dart';
import 'package:boszhan_trading/models/inventory_order_history_model.dart';
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

List<dynamic> globalInventoryList = [];
List<TextEditingController> globalInventoryTextFields = [];

class InventoryEditPage extends StatefulWidget {
  const InventoryEditPage({Key? key, required this.order}) : super(key: key);

  final InventoryOrderHistoryModel order;

  @override
  State<InventoryEditPage> createState() => _InventoryEditPageState();
}

class _InventoryEditPageState extends State<InventoryEditPage> {
  String createdTime = '';

  String name = '';
  String storeName = '';
  String storageName = '';
  String organizationName = '';

  dynamic selectedProduct;

  bool isButtonActive = true;

  List<double> savedCounts = [];

  List<ProductMain> products = [];
  String scannedBarcode = '';

  bool dialogIsActive = false;

  @override
  void initState() {
    getProducts();
    checkLogin();
    _init();
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

  void _init() async {
    globalInventoryList = [];
    globalInventoryTextFields = [];
    for (var item in widget.order.products) {
      globalInventoryList.add({
        'product_id': item.id,
        'article': item.article,
        'name': item.name,
        'moving_from': item.movingFrom,
        'moving_to': item.movingTo,
        'receipt': item.receipt,
        'sale': item.sale,
        'remains': item.remains,
        'count': item.count,
      });

      globalInventoryTextFields
          .add(TextEditingController(text: item.count.toString()));
    }

    if (globalInventoryTextFields.length == savedCounts.length) {
      for (int i = 0; i < globalInventoryTextFields.length; i++) {
        if (savedCounts[i] != 0) {
          globalInventoryTextFields[i].text = savedCounts[i].toString();
        }
      }

      setState(() {});
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
                            const Text(
                                "Редактирование документа инвентаризации",
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
                          // height: 600,
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
    return DataTable(
      columns: _createColumns(),
      rows: [
        for (int i = 0; i < globalInventoryList.length; i++)
          DataRow(cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(globalInventoryList[i]['product_id'].toString())),
            DataCell(Text(globalInventoryList[i]['article'] ?? '')),
            DataCell(Text(globalInventoryList[i]['name'] ?? '')),
            DataCell(Text(globalInventoryList[i]['moving_from'].toString())),
            DataCell(Text(globalInventoryList[i]['receipt'].toString())),
            DataCell(Text(globalInventoryList[i]['sale'].toString())),
            DataCell(Text(globalInventoryList[i]['remains'].toString())),
            DataCell(Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                width: 50,
                child: DebouncerTextField(
                  controller: globalInventoryTextFields[i],
                  onValueChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            )),
            DataCell(
              Text(
                (double.parse(globalInventoryTextFields[i].text == ''
                            ? '0'
                            : globalInventoryTextFields[i]
                                .text
                                .replaceAll(',', '.')) -
                        double.parse(
                            globalInventoryList[i]['remains'].toString()))
                    .toString(),
              ),
            ),
          ])
      ],
      showCheckboxColumn: false,
    );
  }

  // PaginatedDataTable _createDataTable() {
  //   return PaginatedDataTable(
  //     source: MyData(context, refresh),
  //     columns: _createColumns(),
  //     rowsPerPage: 10,
  //     showCheckboxColumn: false,
  //   );
  // }

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
      const DataColumn(label: Text('Остаток')),
      const DataColumn(label: Text('Колличество')),
      const DataColumn(label: Text('Разница')),
      // const DataColumn(label: Text('Сумма')),
      // const DataColumn(label: Text('Удалить')),
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
      var response = await MainApiService()
          .addProductToInventoryCreatedOrder(productId, widget.order.id);
      saveCountOfProduct();

      _init();
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }

  void createOrder() async {
    for (var i in globalInventoryTextFields) {
      if (i.text.isEmpty) {
        showCustomSnackBar(context, 'Заполните все поля!');
        return;
      }
    }
    isButtonActive = false;
    List<dynamic> sendBasketList = [];
    for (int i = 0; i < globalInventoryList.length; i++) {
      var tempMap = globalInventoryList[i];
      tempMap['count'] = globalInventoryTextFields[i].text.replaceAll(',', '.');
      sendBasketList.add(tempMap);
    }

    try {
      var response = await MainApiService()
          .editInventoryOrder(widget.order.id, sendBasketList);
      print(response);
      showCustomSnackBar(context, 'Заказ успешно cохранен!');
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

  refresh() {
    setState(() {});
  }

  void saveCountOfProduct() {
    savedCounts = [];
    for (var i in globalInventoryTextFields) {
      if (double.tryParse(i.text.replaceAll(',', '.')) != null) {
        savedCounts.add(double.parse(i.text.replaceAll(',', '.')));
      } else {
        savedCounts.add(0);
      }
    }
  }
}
