import 'dart:js' as js;

import 'package:boszhan_trading/models/user.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/providers/session_data_provider.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:boszhan_trading/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';

  @override
  void initState() {
    getUser();
    checkLogin();
    getProductData();
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
              children: [
                const CustomAppBar(),
                const SizedBox(height: 30),
                Text(
                  "Bız bar yqylasymyzben jäne tolyq jauapkerşılıgımızben kün \nsaiyn adamdar tañdaityn önımderdı daiyndaimyz",
                  style: ProjectStyles.textStyle_18Medium
                      .copyWith(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Мы с душой и полной ответственностью создаем продукты, \nкоторые каждый день выбирают люди",
                  style: ProjectStyles.textStyle_18Medium
                      .copyWith(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 350,
                  height: 350,
                  child: Image.asset('assets/images/logo.png'),
                ),
                customTextButton(
                  () {
                    _showSimpleDialogForSales(context);
                  },
                  title: 'Продажи',
                ),
                customTextButton(
                  () {
                    _showSimpleDialogForIncoming(context);
                  },
                  title: 'Поступление товара',
                ),
                customTextButton(
                  () {
                    _showSimpleDialogForReturn(context);
                  },
                  title: 'Возврат товара',
                ),
                customTextButton(
                  () {
                    _showSimpleDialogForWriteOff(context);
                  },
                  title: 'Списание товара',
                ),
                customTextButton(
                  () {
                    _showSimpleDialogForReturnProducer(context);
                  },
                  title: 'Возврат товара поставщику',
                ),
                customTextButton(
                  () {
                    js.context
                        .callMethod('open', ['http://salesrep.boszhan.kz']);
                  },
                  title: 'Заказ товара',
                ),
                customTextButton(
                  () {
                    print(123);
                  },
                  title: 'Инвентаризация',
                ),
                customTextButton(
                  () {
                    _showSimpleDialogForKKM(context);
                  },
                  title: 'ККМ',
                ),
                customTextButton(
                  () {
                    print(123);
                  },
                  title: 'Отчеты',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text('Пользователь: $userName',
                      style: ProjectStyles.textStyle_14Regular),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSimpleDialogForSales(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите действие',
              style: ProjectStyles.textStyle_18Bold),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/sales/new');
              },
              child: const Text('Новая продажа',
                  style: ProjectStyles.textStyle_18Medium),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/sales/history');
              },
              child: const Text('Журнал продаж',
                  style: ProjectStyles.textStyle_18Medium),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSimpleDialogForIncoming(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите действие',
              style: ProjectStyles.textStyle_18Bold),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/incoming/new');
              },
              child: const Text('Новое поступление',
                  style: ProjectStyles.textStyle_18Medium),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/incoming/history');
              },
              child: const Text('Журнал поступления товара',
                  style: ProjectStyles.textStyle_18Medium),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSimpleDialogForReturn(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите действие',
              style: ProjectStyles.textStyle_18Bold),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/return/new');
              },
              child: const Text('Новый возврат от покупателя',
                  style: ProjectStyles.textStyle_18Medium),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/return/history');
              },
              child: const Text('Журнал возвратов',
                  style: ProjectStyles.textStyle_18Medium),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSimpleDialogForWriteOff(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите действие',
              style: ProjectStyles.textStyle_18Bold),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/write-off/new');
              },
              child: const Text('Новый документ списания',
                  style: ProjectStyles.textStyle_18Medium),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/write-off/history');
              },
              child: const Text('Журнал списания',
                  style: ProjectStyles.textStyle_18Medium),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSimpleDialogForReturnProducer(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите действие',
              style: ProjectStyles.textStyle_18Bold),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/return-producer/new');
              },
              child: const Text('Новый документ возврата поставщику',
                  style: ProjectStyles.textStyle_18Medium),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/return-producer/history');
              },
              child: const Text('Журнал вовратов поставщику',
                  style: ProjectStyles.textStyle_18Medium),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSimpleDialogForKKM(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите действие',
              style: ProjectStyles.textStyle_18Bold),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/kkm/money');
              },
              child: const Text('Внесение/Изъятие денег',
                  style: ProjectStyles.textStyle_18Medium),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/kkm/x-report');
              },
              child: const Text('X отчёт',
                  style: ProjectStyles.textStyle_18Medium),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/kkm/z-report');
              },
              child: const Text('Z отчёт',
                  style: ProjectStyles.textStyle_18Medium),
            ),
          ],
        );
      },
    );
  }

  void getUser() async {
    User? user = await AuthRepository().getUserFromCache();
    if (user != null) {
      userName = user.name;
      setState(() {});
    }
  }

  void getProductData() async {
    var products = await SessionDataProvider().getProductsFromCache();

    if (products == null) {
      var responseBrands = await MainApiService().getBrands();
      var responseCategories = await MainApiService().getCategories();
      var responseProducts = await MainApiService().getProducts();

      List<Map<String, dynamic>> thisProducts = [];

      for (int i = 0; i < responseBrands.length; i++) {
        var categoryMap = {
          'id': responseBrands[i]['id'],
          'name': responseBrands[i]['name'],
          'categories': []
        };

        for (int j = 0; j < responseCategories.length; j++) {
          var productsMap = {
            'id': responseCategories[j]['id'],
            'name': responseCategories[j]['name'],
            'products': [],
          };

          for (int k = 0; k < responseProducts.length; k++) {
            if (responseCategories[j]['id'] ==
                responseProducts[k]['category']['id']) {
              if (responseProducts[k]['price'] != 0) {
                productsMap['products'].add({
                  'id': responseProducts[k]['id'],
                  'name': responseProducts[k]['name'],
                  'id_1c': responseProducts[k]['id_1c'],
                  'article': responseProducts[k]['article'],
                  'price': responseProducts[k]['price'],
                  'measure': responseProducts[k]['measure'] == 1 ? 'шт' : 'кг',
                });
              }
            }
          }

          if (productsMap['products'].isNotEmpty) {
            categoryMap['categories'].add(productsMap);
          }
        }

        thisProducts.add(categoryMap);
      }

      SessionDataProvider().setProductsToCache(thisProducts);
    }
  }
}