// @dart=2.12
import 'package:console/config/config.dart';
import 'package:controls_web/controls.dart';
import 'package:controls_web/themes/themes.dart';
import 'package:floresta/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'home_navigator.dart' as hm;
import 'package:get/get.dart';
import '../../config/config.dart' as cfg;
import 'package:console/views/opcoes/opcoes_choices.dart';
import '../../widgets/drawer_menu.dart';
import 'package:controls_data/local_storage.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key, this.title, this.hideAppBar = false})
      : super(key: key);
  final String? title;
  final bool hideAppBar;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: (!hideAppBar) ? AppBar(title: Text(title ?? 'Opções')) : null,
      body: Column(children: [
        //ProfileUser(
        //  usuario: Usuario.fromJson(Config.instance.usuarioData.toJson()),
        //  versao: appVersao,
        //),
        SizedBox.fromSize(
            size: const Size(double.infinity, 120),
            //width: double.infinity,
            child: DrawerUserHeader(
              background: SizedBox.expand(
                  child: Image.asset('assets/login_fundo.png',
                      fit: BoxFit.fitWidth)),
              //email: Text(configInstance!.usuarioData['email']??''),
              name: Text(configInstance!.usuarioData.nome!,
                  style: theme.textTheme.bodyText1),
              avatar: CircleAvatar(
                  child: ClipOval(child: Container(color: Colors.blue))),
            )),
        // Divider(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                for (var item in opcoesChoices(context, showTitle: false))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: StrapButton(
                      text: item.label,
                      radius: 25,
                      minHeight: 50,
                      height: 91,
                      type: StrapButtonType.light,
                      onPressed: () {
                        //Navigator.popUntil(context, ModalRoute.withName('/'));
                        Get.offAllNamed('/');
                        Get.to(() => MobileScaffold(
                              appBar: AppBar(
                                automaticallyImplyLeading: false,
                                title: Text(item.label!),
                                actions: [
                                  if ((item.items != null) &&
                                      (item.builder != null))
                                    for (var sb in item.items!) sb.builder!()
                                ],
                              ),
                              body: item.builder!(),
                              bottomNavigationBar:
                                  const hm.BarraNavegacaoPadrao(itemIndex: -1),
                            ));
                      },
                    ),
                  ),
                StrapButton(
                    text: 'Sair',
                    radius: 25,
                    minHeight: 50,
                    height: 91,
                    type: StrapButtonType.light,
                    onPressed: () {
                      cfg.Config().logout();
                      Get.offAllNamed('/');
                    }),
              ],
            ),
          ),
        ),
        Container(
            alignment: Alignment.centerRight,
            child: const Text('Versão:   ${cfg.appVersao}')),
      ]),
    );
  }

  opcoesChoices(context, {bool showTitle = false}) {
    return [
      TabChoice(
          label: 'Esquema de cores',
          builder: () => ColorPickerDialog(
                showTitle: showTitle,
                title: 'Selecione a cor dominante',
                colors: [
                  ...[
                    Colors.indigo[900]!,
                    Colors.indigo[500]!,
                    Colors.indigo[200]!,
                    Colors.blue[900]!,
                    Colors.blue[500]!,
                    Colors.blue[200]!,
                  ],
                  ...coldColors,
                  ...pastelColors
                ].where((r) => r != Colors.transparent).toList()
                    as List<Color>?,
                onChanged: (color) {
                  LocalStorage().setKey('schema_cores', color.toHex());
                  corScheme!.value = color;
                  DynamicTheme.changeTo(Brightness.light);
                  //Get.changeThemeMode(themeMode)
                  //var tm = DynamicTheme.of(context);
                  //tm!.setBrightness(Brightness.light);
                  DynamicTheme.changeTo(Brightness.light);
                  var tm = ThemeData(
                    primarySwatch: createMaterialColor(color),
                  );
                  Get.changeTheme(tm);
                  Get.offAndToNamed('/');
                },
              )),
    ];
  }
}
