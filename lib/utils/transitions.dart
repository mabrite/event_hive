import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secAnim, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: Duration(milliseconds: 500),
  );
}
