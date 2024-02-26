import 'package:boszhan_trading/pages/KKM/deposits_or_withdrawals_page.dart';
import 'package:boszhan_trading/pages/KKM/x_report_page.dart';
import 'package:boszhan_trading/pages/KKM/z_report_page.dart';
import 'package:boszhan_trading/pages/auth/auth_page.dart';
import 'package:boszhan_trading/pages/home_page/home_page.dart';
import 'package:boszhan_trading/pages/incoming/incoming_history.dart';
import 'package:boszhan_trading/pages/incoming/new_incoming.dart';
import 'package:boszhan_trading/pages/inventory/inventory_history.dart';
import 'package:boszhan_trading/pages/inventory/new_inventory.dart';
import 'package:boszhan_trading/pages/moving/moving_history.dart';
import 'package:boszhan_trading/pages/moving/new_moving.dart';
import 'package:boszhan_trading/pages/report/discount_card/discount_card_report.dart';
import 'package:boszhan_trading/pages/report/online_sale/online_sale_report.dart';
import 'package:boszhan_trading/pages/report/product_report_page.dart';
import 'package:boszhan_trading/pages/report/remains_report_page.dart';
import 'package:boszhan_trading/pages/return_producer/new_return_producer.dart';
import 'package:boszhan_trading/pages/return_producer/return_producer_history.dart';
import 'package:boszhan_trading/pages/returns/new_return.dart';
import 'package:boszhan_trading/pages/returns/return_history.dart';
import 'package:boszhan_trading/pages/sales/new_order_page.dart';
import 'package:boszhan_trading/pages/sales/order_history.dart';
import 'package:boszhan_trading/pages/sales/unfinished_orders.dart';
import 'package:boszhan_trading/pages/splash_screen/SplashScreen.dart';
import 'package:boszhan_trading/pages/write-off/new_write_off.dart';
import 'package:boszhan_trading/pages/write-off/write_off_history.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boszhan Trading App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container()),
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/auth': (context) => const AuthPage(),
        '/sales/history': (context) => const OrderHistoryPage(),
        '/sales/new': (context) => const NewOrderPage(
              unfinishedBasket: [],
            ),
        '/sales/unfinished': (context) => const UnfinishedOrdersPage(),
        '/incoming/new': (context) => const NewIncomingPage(),
        '/incoming/history': (context) => const IncomingHistoryPage(),
        '/return/new': (context) => const NewReturnPage(),
        '/return/history': (context) => const ReturnHistoryPage(),
        '/write-off/new': (context) => const NewWriteOffPage(),
        '/write-off/history': (context) => const WriteOffHistoryPage(),
        '/return-producer/new': (context) => const NewReturnProducerPage(),
        '/return-producer/history': (context) =>
            const ReturnProducerHistoryPage(),
        '/kkm/money': (context) => const DepositsOrWithdrawalsPage(),
        '/kkm/x-report': (context) => const XReportPage(),
        '/kkm/z-report': (context) => const ZReportPage(),
        '/moving/new': (context) => const NewMovingPage(),
        '/moving/history': (context) => const MovingHistoryPage(),
        '/inventory/new': (context) => const NewInventoryPage(),
        '/inventory/history': (context) => const InventoryHistoryPage(),
        '/report/remains': (context) => const RemainsReportPage(),
        '/report/discount-card': (context) => const DiscountCardReportPage(),
        '/report/online-sale': (context) => const OnlineSaleReportReportPage(),
        '/report/product': (context) => const ProductReportPage(),
      },
    );
  }
}
