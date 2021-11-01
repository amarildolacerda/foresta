// @dart=2.12
import 'package:controls_web/controls.dart';
import 'package:flutter/material.dart';

import 'home_navigator.dart';

showMobilePage(BuildContext context,
    {double? width,
    double? height,
    String? title,
    required Widget child,
    bool showNavBar = true}) async {
  return Dialogs.showPage(context,
      fullPage: (width == null && height == null),
      width: width,
      height: height,
      child: MobileScaffold(
        appBar:
            (title == null) ? null : AppBar(elevation: 0, title: Text(title)),
        body: Center(child: child),
        bottomNavigationBar: showNavBar
            ? const BarraNavegacaoPadrao(
                itemIndex: -1,
              )
            : null,
      ));
}
