import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class OrderHistoryItem extends StatelessWidget {
  const OrderHistoryItem({
    Key? key,
    required this.orderId,
    required this.storeId,
    required this.name,
    required this.sum,
  }) : super(key: key);

  final String orderId;
  final String storeId;
  final String name;
  final String sum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: ProjectStyles.textStyle_14Regular,
              ),
              Text(
                storeId,
                style: ProjectStyles.textStyle_14Regular,
              ),
              Text(
                name,
                style: ProjectStyles.textStyle_14Regular,
              ),
              Text(
                '$sum тг',
                style: ProjectStyles.textStyle_14Regular,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.playlist_remove,
                  size: 30,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.checklist,
                    size: 30,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
