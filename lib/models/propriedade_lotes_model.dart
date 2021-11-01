// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_data/odata_firestore.dart';
import 'package:uuid/uuid.dart';

class PropriedadeLotesItem extends DataItem {
  //bool inativo;
  late Map<String, dynamic>? _dummy = {};
  String? propriedadeId;
  double? area;
  DateTime? dataAbertura;
  PropriedadeLotesItem();

  PropriedadeLotesItem.fromJson(data) {
    fromMap(data);
  }

  @override
  fromMap(data) {
    id = data['id'];
    propriedadeId = data['propriedade_id'];
    area = toDouble(data['area']);
    dataAbertura = toDate(data['data_abertura']);
    _dummy = data;
    return this;
  }

  @override
  toJson() {
    _dummy!['id'] = id ?? const Uuid().v4();
    _dummy!['propriedade_id'] = propriedadeId;
    _dummy!['area'] = area;
    _dummy!['data_abertura'] = dataAbertura;
    return _dummy!;
  }
}

class PropriedadeLotesModel extends ODataModelClass<PropriedadeLotesItem> {
  PropriedadeLotesModel() {
    super.collectionName = 'PropriedadeLotes';
    API = ODataInst();
  }
  // @override
  PropriedadeLotesItem createItem() {
    return PropriedadeLotesItem();
  }
}
