import 'package:flutter/material.dart';

class AbsText extends StatelessWidget {
  final String? data;
  final double? size;
  final FontWeight? fw;
  final Color? color;

  const AbsText(this.data, {this.size, this.fw, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      data.toString(),
      style: TextStyle(color: color, fontSize: size, fontWeight: fw),
    );
  }
}
