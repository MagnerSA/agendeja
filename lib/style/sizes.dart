import 'package:flutter/material.dart';

const double sizeHeight = 40;
const double sizeHeightMobile = 35;
const double sizeSpace = 15;
const double sizeSpaceMobile = 10;
const double sizeFont = 16;
const double sizeFontMobile = 12;

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.height /
          MediaQuery.of(context).size.width >
      1.35;
}

bool isNotMobile(BuildContext context) {
  return !isMobile(context);
}

double w(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width * (percentage / 100);
}

double h(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height * (percentage / 100);
}

double getSizeHeight(BuildContext context) {
  return isMobile(context) ? sizeHeightMobile : sizeHeight;
}

double getSizeSubHeight(BuildContext context) {
  return (isMobile(context) ? sizeHeightMobile : sizeHeight) * 0.7;
}

double getSizeSpace(BuildContext context) {
  return isMobile(context) ? sizeSpaceMobile : sizeSpace;
}

double getSizeSmallSpace(BuildContext context) {
  return (isMobile(context) ? sizeSpaceMobile : sizeSpace) / 2.5;
}

double getSizeFont(BuildContext context) {
  return isMobile(context) ? sizeFontMobile : sizeFont;
}

Widget sizedBox(BuildContext context) {
  return SizedBox(
    height: getSizeSpace(context),
    width: getSizeSpace(context),
  );
}

Widget smallSizedBox(BuildContext context) {
  return SizedBox(
    height: getSizeSpace(context) / 2,
    width: getSizeSpace(context) / 2,
  );
}

Widget expanded() {
  return const Expanded(child: SizedBox());
}
