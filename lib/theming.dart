// @dart=2.12
import 'package:console/views/opcoes/opcoes_choices.dart';
import 'package:controls_web/controls/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:controls_data/local_storage.dart';
import 'package:controls_web/controls.dart';

getTheme(context, {Brightness brightness = Brightness.dark}) {
  ThemeData theme;
  if (brightness == Brightness.dark) {
    return ThemeData.dark();
  }

  String schemaCores = LocalStorage().getKey('schema_cores') ?? '';

  var cor = Color(0xff2F80ED);
  if (schemaCores.length > 0)
    cor = ColorExtension.fromHex(
      schemaCores,
    );
  else if (corScheme != null) cor = corScheme!.value;
  theme = ThemeData(
    primarySwatch: createMaterialColor(cor),
  ).copyWith(
    //primaryColor: Colors.blue,
    bottomAppBarColor: Colors.transparent,
    indicatorColor: Colors.amber,
    tabBarTheme: TabBarTheme(
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: GetPlatform.isWeb ? 13 : 11,
          fontWeight: FontWeight.w400,
        )),
  );

  return theme.copyWith(
      //accentIconTheme: theme.accentIconTheme.copyWith(color: Colors.red),
      //floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
      //  backgroundColor: Colors.amber,
      //),
      /*appBarTheme: theme.appBarTheme.copyWith(
      color: Colors.amber[300],
    ),*/
      );
}
