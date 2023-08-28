import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebouncerTextField extends StatefulWidget {
  final ValueChanged<String> onValueChanged;
  final Duration debounceTime;
  final TextEditingController controller;

  const DebouncerTextField({
    Key? key,
    required this.onValueChanged,
    this.debounceTime = const Duration(milliseconds: 500),
    required this.controller,
  }) : super(key: key);

  @override
  _DebouncerTextFieldState createState() => _DebouncerTextFieldState();
}

class _DebouncerTextFieldState extends State<DebouncerTextField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (text) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(widget.debounceTime, () {
          widget.onValueChanged(text);
        });
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+[\,\.]?\d{0,2}')),
      ],
      decoration: const InputDecoration(hintText: 'кл.'),
    );
  }
}
