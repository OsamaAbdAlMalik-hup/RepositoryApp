import 'package:flutter/material.dart';

class TextLargeTitle extends StatelessWidget {
  final String text;
  const TextLargeTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
