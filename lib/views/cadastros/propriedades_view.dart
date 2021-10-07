import 'package:console/builders/index.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_web/controls.dart';
import 'package:floresta/models/propriedades_model.dart';
import 'package:flutter/material.dart';

class PropriedadesView extends StatelessWidget {
  const PropriedadesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataViewer(
      canInsert: true,
      canEdit: true,
      controller: controller,
    );
  }

  static get controller => DataViewerController(
          keyName: 'id',
          dataSource: PropriedadesModel(),
          future: () => PropriedadesModel().listCached(orderBy: 'fantasia'),
          columns: [
            DataViewerColumn(
                name: 'id',
                isPrimaryKey: true,
                isVirtual: true,
                visible: false),
            DataViewerColumn(name: 'nome'),
            DataViewerColumn(name: 'fantasia'),
            DataViewerColumn(name: 'bairro'),
            DataViewerColumn(name: 'cidade'),
            DataViewerColumn(name: 'estado'),
            DataViewerColumn(
                name: 'filial',
                visible: false,
                //editWidth: 210,
                label: 'Unid.Custeio',
                editBuilder: (a, b, c, dados) {
                  return SizedBox(
                      //    width: 210,
                      child: FilialBuilder.createDropDownFormField(
                          toDouble(dados['filial']), onChanged: (x) {
                    dados['filial'] = x;
                  }));
                }),
            DataViewerHelper.simnaoColumn(DataViewerColumn(name: 'inativo')),
          ]);
}
