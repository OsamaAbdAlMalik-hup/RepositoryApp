
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {

  String title;
  void Function()? onPressed;
  TitleSection({Key? key,this.title="title",this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge
        ),
        IconButton(onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward,)),
      ],
    );
  }
}
