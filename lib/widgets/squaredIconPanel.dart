import 'package:flutter/material.dart';

import '../style/sizes.dart';
import 'panel.dart';

class SquaredIconPanel extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final IconData iconData;
  final bool? disabled;
  final bool? isSelected;

  const SquaredIconPanel({
    Key? key,
    required this.onTap,
    required this.iconData,
    this.disabled,
    this.onDoubleTap,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      color: (disabled ?? false) ? Colors.grey.shade200 : Colors.white,
      onDoubleTap: onDoubleTap,
      onTap: onTap,
      height: getSizeHeight(context),
      width: getSizeHeight(context),
      hasBorder: isSelected,
      // borderColor: Colors.black,
      child: Center(
        child: Icon(
          iconData,
          size: 20,
          color: (disabled ?? false) ? Colors.grey.shade400 : Colors.black,
        ),
      ),
    );
  }
}
