import 'package:flutter/material.dart';

class TextileFooter extends StatelessWidget {
  const TextileFooter({super.key, this.height = 54});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        'assets/images/habesha_textile.jpg',
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}