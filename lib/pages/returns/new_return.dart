import 'package:boszhan_trading/models/product.dart';
import 'package:boszhan_trading/models/user.dart';
import 'package:boszhan_trading/pages/check_page/check_page.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/counteragent_selection_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/custom_text_button.dart';
import 'package:boszhan_trading/widgets/nds_widget.dart';
import 'package:boszhan_trading/widgets/order_products_selection.dart';
import 'package:boszhan_trading/widgets/refund_reason_selection_widget.dart';
import 'package:boszhan_trading/widgets/select_order_for_return_widget.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewReturnPage extends StatefulWidget {
  const NewReturnPage({Key? key}) : super(key: key);

  @override
  State<NewReturnPage> createState() => _NewReturnPageState();
}

class _NewReturnPageState extends State<NewReturnPage> {
  String createdTime = '';
  Object dayTypeSelectedValue = 1;

  String name = '';
  String storeName = '';
  String storageName = '';
  String organizationName = '';
  String counteragentName = '';
  int counteragentId = 0;
  int selectedOrderId = 0;
  List<Product> selectedOrderProducts = [];

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
                          const Text("Новый возврат от покупателя",
                              style: ProjectStyles.textStyle_30Bold),
                          const Spacer(),
                          customTextButton(
                            () {
                              if (basket.isNotEmpty &&
                                  isButtonActive &&
                                  selectedOrderId != 0) {
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
                              Row(
                                children: [
                                  Text(
                                    'Заказ №: ${selectedOrderId != 0 ? selectedOrderId : ''}',
                                    style: ProjectStyles.textStyle_14Medium,
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                      onPressed: () {
                                        showOrderSelectionDialog();
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'От: $createdTime',
                                style: ProjectStyles.textStyle_14Medium,
                              ),
                              const SizedBox(height: 10),
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
                                      icon: const Icon(Icons.edit)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Операция:',
                                    style: ProjectStyles.textStyle_14Medium,
                                  ),
                                  const SizedBox(width: 10),
                                  DropdownButton(
                                    value: dayTypeSelectedValue,
                                    items: const [
                                      DropdownMenuItem(
                                          child: Text("День в день"), value: 1),
                                      DropdownMenuItem(
                                          child: Text("Не день в день"),
                                          value: 2),
                                    ],
                                    onChanged: (Object? newValue) {
                                      setState(() {
                                        dayTypeSelectedValue = newValue!;
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
                                if (selectedOrderId != 0) {
                                  showProductDialog();
                                } else {
                                  showCustomSnackBar(
                                      context, 'Выберите заказ.');
                                }
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
                setState(() {});
              },
              icon: const Icon(Icons.delete),
            ),
          )
        ]),
    ];
  }

  void showOrderSelectionDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите заказ'),
          content: SelectOrderForReturnWidget(
            selectOrder: selectOrder,
            isShowTodaysOrders: dayTypeSelectedValue == 1 ? true : false,
          ),
        );
      },
    );
  }

  void selectOrder(int index, List<Product> products) async {
    selectedOrderId = index;
    selectedOrderProducts = products;
    setState(() {});
  }

  void showReasonDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Причина возврата'),
          content: RefundReasonSelectionWidget(
            selectReason: selectReason,
          ),
        );
      },
    );
  }

  void selectReason(int index, String text) async {
    selectedProduct['reason_refund_id'] = index;
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
          content: OrderProductsSelectionWidget(
            addToBasket: addToBasket,
            products: selectedOrderProducts,
          ),
        );
      },
    );
  }

  void addToBasket(dynamic product) async {
    selectedProduct = product;
    showReasonDialog();
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
      sendBasketList.add({
        'product_id': item['id'],
        'count': item['count'],
        'reason_refund_id': item['reason_refund_id']
      });
    }

    try {
      var response = await MainApiService().createReturnOrder(
          selectedOrderId,
          1,
          sendBasketList,
          counteragentId,
          int.parse(dayTypeSelectedValue.toString()));
      print(response);
      showCustomSnackBar(context, 'Заказ успешно создан!');

      var responsePrintCheck =
          await MainApiService().getTicketForPrintReturn(response['id']);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckPage(
                  check: responsePrintCheck["Lines"],
                )),
      );

      Future.delayed(const Duration(seconds: 2))
          .whenComplete(() => Navigator.of(context).pushNamed('/home'));
    } catch (e) {
      isButtonActive = true;
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
