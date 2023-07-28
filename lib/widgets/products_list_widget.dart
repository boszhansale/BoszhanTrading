import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class ProductsListWidget extends StatefulWidget {
  const ProductsListWidget({Key? key, required this.addToBasket})
      : super(key: key);

  final Function(dynamic) addToBasket;

  @override
  State<ProductsListWidget> createState() => _ProductsListWidgetState();
}

class _ProductsListWidgetState extends State<ProductsListWidget> {
  TextEditingController countController = TextEditingController();
  List<dynamic> dataList = [];
  List<dynamic> searchList = [];

  dynamic selectedProduct = {};
  double selectedProductCount = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    // var productsData = await SessionDataProvider().getProductsFromCache();
    // dataList = productsData ?? [];

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

        if (productsMap['products'].isNotEmpty &&
            responseBrands[i]['id'] == responseCategories[j]['brand_id']) {
          categoryMap['categories'].add(productsMap);
        }
      }

      thisProducts.add(categoryMap);
    }

    dataList = thisProducts;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 600,
      child: Column(
        children: [
          SizedBox(
              height: 50,
              child: TextField(
                decoration: const InputDecoration(hintText: 'Поиск'),
                onChanged: (value) {
                  if (value.length > 2) {
                    searchList = [];
                    for (var brands in dataList) {
                      for (var category in brands['categories']) {
                        for (var product in category['products']) {
                          if (product['name']
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              product['article']
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            searchList.add(product);
                          }
                        }
                      }
                    }

                    setState(() {});
                  }
                },
              )),
          SizedBox(
            height: searchList.isNotEmpty ? 150 : 30,
            child: searchList.isNotEmpty
                ? ListView.builder(
                    itemCount: searchList.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      title: Text(
                        searchList[index]['name'],
                        style: ProjectStyles.textStyle_14Regular,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () {
                          selectedProduct = searchList[index];
                          showCountDialog();
                        },
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Результаты поиска'),
                  ),
          ),
          const Divider(),
          const Text('Список продуктов:',
              style: ProjectStyles.textStyle_18Bold),
          dataList.isNotEmpty
              ? SizedBox(
                  height: 360,
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ExpansionTile(
                      title: Text(
                        dataList[index]['name'],
                        style: ProjectStyles.textStyle_18Bold
                            .copyWith(color: ColorPalette.main),
                      ),
                      children: [
                        for (var item in dataList[index]['categories'])
                          ExpansionTile(
                            title: Text(
                              item['name'],
                              style: ProjectStyles.textStyle_18Bold,
                            ),
                            children: [
                              for (var product in item['products'])
                                GestureDetector(
                                  onTap: () {
                                    selectedProduct = product;
                                    showCountDialog();
                                  },
                                  child: ListTile(
                                    title: Text(
                                      product['name'],
                                      style: ProjectStyles.textStyle_14Regular,
                                    ),
                                    trailing: const Icon(Icons.add_circle),
                                  ),
                                )
                            ],
                          ),
                      ],
                    ),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(color: ColorPalette.main),
                  ),
                ),
        ],
      ),
    );
  }

  void showCountDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Колличество:'),
          content: SizedBox(
            width: 200,
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: countController,
                  decoration: const InputDecoration(hintText: 'Колличество'),
                  autofocus: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                        onPressed: () {
                          double? count = double.tryParse(
                              countController.text.replaceAll(',', '.'));
                          if (count != null && count != 0) {
                            selectedProduct['count'] = count;
                            Navigator.of(context).pop();
                            widget.addToBasket(selectedProduct);
                          }
                        },
                        child: const Text('Ok')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
