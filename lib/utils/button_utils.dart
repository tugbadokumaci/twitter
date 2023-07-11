import 'package:flutter/material.dart';

class MyButtonWidget extends StatelessWidget {
  final BuildContext context;
  final double height;
  final double width;
  final Color buttonColor;
  final Widget content;
  final Color? borderColor;
  final void Function()? onPressed;
  final bool enabled;

  const MyButtonWidget({
    required this.context,
    required this.height,
    required this.width,
    required this.buttonColor,
    required this.content,
    this.borderColor,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: (borderColor == null) ? buttonColor : borderColor!,
              width: 1.0,
            ),
          ),
        ),
      ),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: content,
        ),
      ),
    );
  }
}
