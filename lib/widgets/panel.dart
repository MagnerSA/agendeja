import 'package:flutter/material.dart';

import '../style/colors.dart';

class Panel extends StatelessWidget {
  final bool? hasShadow;
  final double? height;
  final double? width;
  final Widget? child;
  final Color? color;
  final bool? hasBorder;
  final bool? noBottomRadius;
  final bool? noTopRadius;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final double? topRight;
  final double? topLeft;
  final double? bottomRight;
  final double? bottomLeft;
  final Color? borderColor;
  final bool? noBorderRadius;
  final bool? isRound;
  final Duration? animationDuration;

  const Panel({
    Key? key,
    this.height,
    this.width,
    this.child,
    this.hasShadow,
    this.color,
    this.hasBorder,
    this.noBottomRadius,
    this.noTopRadius,
    this.onTap,
    this.onDoubleTap,
    this.topRight,
    this.topLeft,
    this.bottomRight,
    this.bottomLeft,
    this.borderColor,
    this.noBorderRadius,
    this.animationDuration,
    this.isRound,
  }) : super(key: key);

  getBorderRadius() {
    BorderRadiusGeometry borderRadius = BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? 5),
      topRight: Radius.circular(topRight ?? 5),
      bottomLeft: Radius.circular(bottomLeft ?? 5),
      bottomRight: Radius.circular(bottomRight ?? 5),
    );

    if (noBorderRadius ?? false) {
      borderRadius = BorderRadius.circular(0);
    } else if (isRound ?? false) {
      borderRadius = BorderRadius.circular(999999);
    }

    return borderRadius;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: AnimatedContainer(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? COLOR_PANEL,
          borderRadius: getBorderRadius(),
          border: (hasBorder ?? false)
              ? Border.all(
                  color: borderColor ?? COLOR_GREY,
                )
              : null,
          boxShadow: (hasShadow ?? true)
              ? const [
                  BoxShadow(
                    color: Color(0xFFDDDDDD),
                    spreadRadius: 3,
                    blurRadius: 7,
                  ),
                ]
              : null,
        ),
        duration: animationDuration ?? const Duration(milliseconds: 100),
        child: child,
      ),
    );
  }
}
