import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

import '../models/storage_model.dart';

class StorageSelectionWidget extends StatefulWidget {
  const StorageSelectionWidget({Key? key, required this.selectStorage})
      : super(key: key);

  final Function(int, String) selectStorage;

  @override
  State<StorageSelectionWidget> createState() => _StorageSelectionWidgetState();
}

class _StorageSelectionWidgetState extends State<StorageSelectionWidget> {
  TextEditingController countController = TextEditingController();
  List<Storage> dataList = [];
  List<Storage> searchList = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    try {
      var response = await MainApiService().getStorages();

      for (var item in response) {
        dataList.add(Storage.fromJson(item));
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
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
                  if (value.length > 1) {
                    searchList = [];
                    for (var item in dataList) {
                      if (item.name
                          .toLowerCase()
                          .contains(value.toLowerCase())) {
                        searchList.add(item);
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
                        searchList[index].name,
                        style: ProjectStyles.textStyle_14Regular,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle),
                        onPressed: () {
                          widget.selectStorage(
                              searchList[index].id, searchList[index].name);
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
          const Text('Список складов:', style: ProjectStyles.textStyle_18Bold),
          SizedBox(
            height: 360,
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(
                  dataList[index].name,
                  style: ProjectStyles.textStyle_14Regular,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () {
                    widget.selectStorage(
                        dataList[index].id, dataList[index].name);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
