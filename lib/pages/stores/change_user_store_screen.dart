import 'package:boszhan_trading/models/user.dart';
import 'package:boszhan_trading/services/providers/main_api_service.dart';
import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/color_palette.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChangeUserStoreScreen extends StatefulWidget {
  const ChangeUserStoreScreen({Key? key}) : super(key: key);

  @override
  State<ChangeUserStoreScreen> createState() => _ChangeUserStoreScreenState();
}

class _ChangeUserStoreScreenState extends State<ChangeUserStoreScreen> {
  List<User> users = [];

  @override
  void initState() {
    checkLogin();
    getCashierList();
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
                    children: [
                      const Text("Список кассиров",
                          style: ProjectStyles.textStyle_30Bold),
                      const SizedBox(height: 20),
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
      const DataColumn(label: Text('Имя')),
      const DataColumn(label: Text('Тор. точка')),
      const DataColumn(label: Text('Показать')),
    ];
  }

  List<DataRow> _createRows() {
    return [
      for (int i = 0; i < users.length; i++)
        DataRow(
          cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(users[i].name)),
            DataCell(Text(users[i].storeName ?? '')),
            DataCell(
              IconButton(
                onPressed: () {
                  _showStoreSet(context, i);
                },
                icon: const Icon(Icons.edit_calendar_rounded),
              ),
            ),
          ],
        ),
    ];
  }

  void getCashierList() async {
    var response = await MainApiService().getCashierList();

    users = [];

    for (var item in response) {
      users.add(User.fromJson(item));
    }

    setState(() {});
  }

  Future<void> _showStoreSet(BuildContext context, int index) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите магазин',
              style: ProjectStyles.textStyle_18Bold),
          children: <Widget>[
            for (var i in users[index].stores)
              SimpleDialogOption(
                onPressed: () async {
                  await setStore(users[index].id, i.id);
                },
                child:
                    Text(i.name ?? '', style: ProjectStyles.textStyle_18Medium),
              ),
          ],
        );
      },
    );
  }

  Future<void> setStore(int userId, int storeId) async {
    try {
      await MainApiService().setStoreForCashier(userId, storeId);

      if (mounted) {
        AuthRepository().logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/auth', ModalRoute.withName('/'));
      }
    } catch (e) {
      print(e);
    }
  }
}
