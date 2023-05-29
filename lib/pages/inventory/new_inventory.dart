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

  List<TextEditingController> basketTextFields = [];

  @override
  void initState() {
    getInventoryProducts();
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
                          // IconButton(
                          //     onPressed: () {
                          //       showProductDialog();
                          //     },
                          //     icon: const Icon(Icons.add_circle))
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
      // const DataColumn(label: Text('Сумма')),
      // const DataColumn(label: Text('Удалить')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < basket.length; i++)
        DataRow(cells: [
          DataCell(Text('${i + 1}')),
          DataCell(Text(basket[i]['id_1c'] ?? '')),
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
                ], // Only numbers can be entered
              ),
            ),
          )),
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

    basket.add(selectedProduct);
    setState(() {});
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
      tempMap['count'] = basketTextFields[i];
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
      setState(() {});
      for (var i in response) {
        basketTextFields.add(TextEditingController());
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
