// @dart=2.12
import 'package:console/config/config.dart';
import 'package:console/views/dashboard/eventos/dashboard_eventos_page.dart';
import 'package:controls_web/controls/injects.dart';
//import 'package:controls_web/controls/responsive.dart';
import 'package:controls_web/controls.dart';
import 'package:controls_web/controls/widget_extensions.dart';
import 'package:floresta/views/cadastros/propriedades_view.dart';
import 'package:floresta/views/home/utils.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls/dialogs_widgets.dart';

import '../../injects_build.dart';
//import 'drawer_view.dart';
import 'home_menu.dart';
import '../../widgets/windows_size_interfaced.dart'
    if (dart.library.io) '../../widgets/windows_size_placement.dart' as sz;
import 'home_navigator.dart';
//import 'package:get/get.dart';
//import 'package:controls_data/data.dart';
import '../../widgets/drawer_menu.dart';

class HomeView extends StatefulWidget {
  final String? title;
  const HomeView({Key? key, this.title}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DateTime? lastBack;
  Future<bool> canClose(context) {
    lastBack ??= DateTime.now();
    var dif = DateTime.now().difference(lastBack!).inMilliseconds;
    //print(dif);
    if (dif > 20 && dif < 500) {
      return Dialogs.okDlg(context,
          text: 'Deseja fechar o aplicativo ?', textButton: 'Fechar');
    }
    lastBack = DateTime.now();
    return Future.value(false);
  }

  printX(v) {
    print(v);
    return v;
  }

  ResponsiveInfo? responsive;
  @override
  Widget build(BuildContext context) {
    responsive = ResponsiveInfo(context);
    return WillPopScope(
        onWillPop: () async {
          var r = await canClose(context);
          return r;
        },
        child: InjectBuilder(
            items: generateInjects(context),
            child: StreamBuilder(
                stream: UsuarioNotifier().stream,
                builder: (a, b) => LayoutBuilder(builder: (a, b) {
                      lastSize = Size(b.maxWidth, b.maxHeight);
                      return tabMobile(context);
                    }))));
  }

  @override
  void initState() {
    super.initState();
    DefaultEventosItemPage.notificarNaoLidas(0, mostrarMensagem: false);
    DashEventNotifier().update();
  }

  buildLogout() {
    return IconButton(
      icon: const Icon(Icons.login),
      onPressed: () {
        configInstance!.logout();
        //configInstance.logado(false);
        //Get.offAndToNamed('/');
      },
    );
  }

  Size? lastSize;

  @override
  void dispose() {
    if (lastSize != null && sz.WindowsSize().isDesktop) {
      sz.WindowsSize().save(lastSize!);
    }

    super.dispose();
  }

  tabMobile(ctx) {
    return MobileMenuBox(
      buttonWidth: 170,
      //drawer: Drawer(child: DrawerView()),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Bem vindo,'),
            Text(configInstance!.usuarioData.nome ?? '',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 15),
          ]),
          elevation: 0,
          //forceElevated: false,
          actions: const [
            CircleAvatar(
              child: Icon(Icons.person),
            ),
            SizedBox(width: 10),
          ]),
      extendBody: true,
      flex: responsive!.isTablet ? 4 : 5,
      sideLeft: (responsive!.isDesktop || responsive!.isTablet)
          ? Container(
              //color: responsive.theme!.primaryColorLight,
              child: createMenu(context),
            )
          : null,
      style: const TextStyle(
          fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),

      choices: HomeMenu.generate(),
      bottomNavigationBar: const BarraNavegacaoPadrao(itemIndex: 1),
      childBottomNavigatorBar: const BarraNavegacaoPadrao(itemIndex: -1),
    );
  }

  Widget createMenu(context) {
    return DrawerMenu(top: 20, choices: [
      TabChoice(
          image: const Icon(Icons.place),
          label: 'Propriedades',
          onPressed: () {
            showMobilePage(context,
                title: 'Propriedades',
                child: [].stepper(
                    itemBuilder: (a, b) =>
                        Step(content: Container(), title: const Text('')),
                    type: StepperType.horizontal,
                    choices: [
                      TabChoice(
                        label: 'Propriedades',
                        builder: () => const PropriedadesView()
                            .sizedBox(width: 300, height: 300),
                      ),
                      TabChoice(
                        label: 'Lote',
                        builder: () => Container(),
                      )
                    ]));
          })
    ]);
  }
}
