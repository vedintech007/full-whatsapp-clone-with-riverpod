import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

//Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;

  //812 is the layout height that the designer used
  return (inputHeight / 812.0) * screenHeight;
}

//Get the proportionate width as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  //375 is the layout width the designer used
  return (inputWidth / 375.0) * screenWidth;
}

SizedBox heightSpace(double value) => SizedBox(height: getProportionateScreenHeight(value));
SizedBox widthSpace(double value) => SizedBox(width: getProportionateScreenWidth(value));

SizedBox mediaHeightSpace(BuildContext context, double value) => SizedBox(height: MediaQuery.of(context).size.height / value);
SizedBox mediaWidthSpace(BuildContext context, double value) => SizedBox(width: MediaQuery.of(context).size.width / value);

Size size(BuildContext context) => MediaQuery.of(context).size;
