import 'package:flutter/material.dart';

class OnBoradingModel {
  final String? title;
  final String? image;
  final String? body;

  final double? rotation;
  final double? width;
  final double? height;
  final double? borderWidth;
  final Color? borderColor;

  OnBoradingModel({
    this.title,
    this.image,
    this.body,
    this.rotation = 0.0,
    this.width = 300.0,
    this.height = 300.0,
    this.borderWidth = 0.0,
    this.borderColor = Colors.transparent,
  });
}