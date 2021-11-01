import 'package:controls_web/controls.dart';
import 'package:floresta/models/propriedade_lotes_model.dart';
import 'package:flutter/material.dart';

class PropriedadeLotesView extends StatelessWidget {
  final String propriedadeId;
  const PropriedadeLotesView({Key? key, required this.propriedadeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataViewer(
      crossAxisAlignment: CrossAxisAlignment.center,
      rowsPerPage: 20,
      showPageNavigatorButtons: false,
      canInsert: true,
      canEdit: true,
      controller: controller(context, propriedadeId),
    );
  }

  static controller(BuildContext context, propriedadeId) =>
      DataViewerController(
          keyName: 'id',
          dataSource: PropriedadeLotesModel(),
          future: () => PropriedadeLotesModel().listCached(),
          onValidate: (v) {
            v['propriedade_id'] = propriedadeId;
            return v;
          },
          columns: [
            DataViewerColumn(
                name: 'id',
                isPrimaryKey: true,
                isVirtual: true,
                visible: false),
            DataViewerColumn(
              name: 'propriedade_id',
              visible: false,
              isVirtual: true,
            ),
            DataViewerHelper.dateTimeColumn(DataViewerColumn(
                name: 'data_abertura', label: 'Data Abertura')),
            DataViewerColumn(name: 'area', label: 'Area ha'),
            DataViewerHelper.simnaoColumn(DataViewerColumn(name: 'inativo')),
          ]);
}
