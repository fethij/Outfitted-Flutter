import 'package:flutter/cupertino.dart';

class ScreenAnimationRoute extends PageRouteBuilder {
  final Widget screenToGoTo;
  final Curve animationType;

  ScreenAnimationRoute({this.animationType, this.screenToGoTo})
      : super(
            transitionDuration: Duration(milliseconds: 700),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child,
            ) {
              animation = CurvedAnimation(
                parent: animation,
                curve: animationType,
              );

              return ScaleTransition(
                  alignment: Alignment.center, scale: animation, child: child);
            },
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
            ) {
              return screenToGoTo;
            });
}
