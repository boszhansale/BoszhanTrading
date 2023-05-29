import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class RefundReasonWriteOffWidget extends StatefulWidget {
  const RefundReasonWriteOffWidget({Key? key, required this.selectReason})
      : super(key: key);

  final Function(String) selectReason;

  @override
  State<RefundReasonWriteOffWidget> createState() =>
      _RefundReasonWriteOffWidgetState();
}

class _RefundReasonWriteOffWidgetState
    extends State<RefundReasonWriteOffWidget> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 500,
      child: Column(
        children: [
          const Divider(),
          const Text('Причина списания:',
              style: ProjectStyles.textStyle_18Bold),
          TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Причина'),
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
                    if (commentController.text.isNotEmpty) {
                      widget.selectReason(commentController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Ok')),
            ],
          )
        ],
      ),
    );
  }
}
