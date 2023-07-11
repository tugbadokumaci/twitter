// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextFieldWidget extends StatelessWidget {
  String? Function(String?) validatorCallback;
  TextEditingController controller;
  String labelText;
  bool isSecure;
  int? maxLength;
  bool? isEnable;
  void Function(String)? onChanged;

  MyTextFieldWidget({
    super.key,
    required this.validatorCallback,
    required this.controller,
    required this.labelText,
    this.isSecure = false,
    this.maxLength,
    this.isEnable = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   FocusScope.of(context).unfocus();
      // },
      child: TextFormField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        validator: validatorCallback,
        onChanged: onChanged,
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: isSecure,
        enabled: isEnable,
        decoration: InputDecoration(
          labelText: labelText,
          counterText: (maxLength == null) ? '' : '${controller.text.length}/$maxLength',
          counterStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
