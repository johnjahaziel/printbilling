import 'package:flutter/material.dart';

Color kred = Color(0xffCC0000);
Color kblack = Color(0xff000000);
Color kwhite = Color(0xffFFFFFF);
Color kgrey = Color(0xff808080);
Color kblue = Color.fromARGB(255, 0, 87, 150);

//Font Sizes

double get fs4  => 4;
double get fs5  => 5;
double get fs6  => 6;
double get fs7  => 7;
double get fs8  => 8;
double get fs10 => 10;
double get fs12 => 12;
double get fs14 => 14;
double get fs15 => 15;
double get fs16 => 16;
double get fs18 => 18;
double get fs20 => 20;
double get fs22 => 22;
double get fs24 => 24;
double get fs25 => 25;

//custom text style

customtext(
  double size,
  Color color,
  [ FontWeight weight = FontWeight.normal ]
) => TextStyle(
  color: color,
  fontSize: size,
  fontWeight: weight
);

//Text Styles

TextStyle headlineLarge22 = TextStyle(
  color: kblack,
  fontSize: fs22,
  fontWeight: FontWeight.bold
);

TextStyle headlineBold16 = TextStyle(
  color: kblack,
  fontSize: fs16,
  fontWeight: FontWeight.bold
);

TextStyle textfield8 = TextStyle(
  color: kblack,
  fontSize: fs8,
  fontWeight: FontWeight.w500
);

TextStyle textfield10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.w500
);

TextStyle textfield12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.w500,
);

TextStyle buttonblacktext = TextStyle(
  color: kblack,
  fontSize: fs14,
  fontWeight: FontWeight.w500
);

TextStyle textbold10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.bold
);

TextStyle textmedium6 = TextStyle(
  color: kblack,
  fontSize: fs6,
  fontWeight: FontWeight.w500
);

TextStyle textmedium8 = TextStyle(
  color: kblack,
  fontSize: fs8,
  fontWeight: FontWeight.w500
);

TextStyle textmedium10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.w500
);

TextStyle textmedium12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.w500
);

TextStyle textmedium14 = TextStyle(
  color: kblack,
  fontSize: fs14,
  fontWeight: FontWeight.w500
);

TextStyle textmedium16 = TextStyle(
  color: kblack,
  fontSize: fs16,
  fontWeight: FontWeight.w500
);

TextStyle text6 = TextStyle(
  color: kblack,
  fontSize: fs6,
  fontWeight: FontWeight.normal
);

TextStyle text7 = TextStyle(
  color: kblack,
  fontSize: fs7,
  fontWeight: FontWeight.normal
);

TextStyle text8 = TextStyle(
  color: kblack,
  fontSize: fs8,
  fontWeight: FontWeight.normal
);

TextStyle text10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.normal
);

TextStyle text12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.normal
);

TextStyle textsemibold16 = TextStyle(
  color: kblack,
  fontSize: fs16,
  fontWeight: FontWeight.w600,
);

TextStyle textsemibold14 = TextStyle(
  color: kblack,
  fontSize: fs14,
  fontWeight: FontWeight.w600,
);

TextStyle textsemibold12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.w600,
);

TextStyle textsemibold10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.w600,
);

TextStyle textsemibold8 = TextStyle(
  color: kblack,
  fontSize: fs8,
  fontWeight: FontWeight.w600,
);

TextStyle textbold12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.bold
);