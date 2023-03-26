import 'package:flutter/cupertino.dart';

class TranslationAnimation extends PageRouteBuilder {
  final Widget page;

  TranslationAnimation({required this.page})
      : super(pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(seconds: 1));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }


}
