import '../config/palette.dart';
import 'package:flutter/material.dart';

import '../models/size.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final List<Color>? gradient;
  final Color? color;

  const CustomElevatedButton({
    Key? key,
    this.onTap,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
          width: width ?? _size.width(137),
          height: height ?? _size.height(60),
          decoration: BoxDecoration(
            gradient: gradient == null
                ? null
                : LinearGradient(
                    colors: gradient!,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
            color: color ?? MyPalette.secondary_color,
            borderRadius:
                BorderRadius.circular(borderRadius ?? _size.width(50)),
          ),
          alignment: Alignment.center,
          child: child),
    );
  }
}

class CustomBorderedButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? color;
  const CustomBorderedButton({
    Key? key,
    this.onTap,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: width ?? _size.width(137),
        height: height ?? _size.height(60),
        decoration: BoxDecoration(
          border: Border.all(color: color ?? MyPalette.secondary_color),
          borderRadius: BorderRadius.circular(borderRadius ?? _size.width(10)),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
