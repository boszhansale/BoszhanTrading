import 'package:boszhan_trading/models/counteragent.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class CounteragentSelectionWidget extends StatefulWidget {
  const CounteragentSelectionWidget(
      {Key? key, required this.selectCounteragent})
      : super(key: key);

  final Function(int, String) selectCounteragent;

  @override
  State<CounteragentSelectionWidget> createState() =>
      _CounteragentSelectionWidgetState();
}

class _CounteragentSelectionWidgetState
    extends State<CounteragentSelectionWidget> {
  TextEditingController countController = TextEditingController();
  List<Counteragent> dataList = [];
  List<Counteragent> searchList = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    try {
      var response = await MainApiService().getCounteragents();

      for (var item in response) {
        dataList.add(Counteragent.fromJson(item));
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
                          widget.selectCounteragent(
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
          const Text('Список контрагентов:',
              style: ProjectStyles.textStyle_18Bold),
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
                    widget.selectCounteragent(
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
