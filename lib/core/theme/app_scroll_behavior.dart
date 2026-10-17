import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Lets a mouse and a trackpad drag the page, not only a finger.
///
/// Flutter's default [MaterialScrollBehavior] deliberately omits
/// [PointerDeviceKind.mouse] from [dragDevices]: on a desktop or a web build
/// that means a horizontal strip cannot be dragged at all with a mouse, and a
/// vertical page can only be moved with the wheel. The Home photo strip is
/// horizontal, so on the web build it looked completely frozen — this is the
/// whole fix. Touch behaviour is unchanged.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown,
      };
}
