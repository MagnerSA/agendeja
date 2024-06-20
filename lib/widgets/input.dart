import 'package:agendeja/style/sizes.dart';
import 'package:flutter/material.dart';

import 'panel.dart';

class Input extends StatelessWidget {
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final TextAlign? textAlign;
  final String? hintText;
  final TextInputType? keyboardType;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final bool? error;
  final void Function(String)? onSubmitted;

  const Input({
    Key? key,
    this.error,
    this.onChanged,
    this.controller,
    this.width,
    this.height,
    this.textAlign,
    this.hintText,
    this.keyboardType,
    this.color,
    this.borderColor,
    this.textColor,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      color: (error ?? false)
          ? Colors.red.shade100
          : (color ?? Colors.grey.shade200),
      hasShadow: false,
      height: height,
      width: width,
      hasBorder: borderColor != null,
      borderColor: borderColor,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: getSizeSpace(context),
            right: getSizeSpace(context),
          ),
          child: TextFormField(
            onFieldSubmitted: onSubmitted,
            controller: controller,
            cursorColor: textColor ?? Colors.grey,
            style: TextStyle(
              color:
                  (error ?? false) ? Colors.red : (textColor ?? Colors.black),
              fontSize: 16,
            ),
            textAlign: textAlign ?? TextAlign.start,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText ?? "",
              hintStyle: TextStyle(
                color: (error ?? false)
                    ? Colors.black
                    : (textColor ?? Colors.grey),
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
