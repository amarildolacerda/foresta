// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:uuid/uuid.dart';

class PropriedadesItem extends DataItem {
  //bool inativo;
  late Map<String, dynamic>? _dummy = {};
  PropriedadesItem();

  PropriedadesItem.fromJson(data) {
    fromMap(data);
  }

  @override
  fromMap(data) {
    id = data['id'];
    nome = data['nome'];
    fantasia = data['fantasia'];
    _dummy = data;
    return this;
  }

  @override
  toJson() {
    _dummy!['id'] = id ?? const Uuid().v4();
    _dummy!['nome'] = nome;
    _dummy!['fantasia'] = fantasia;
    return _dummy!;
  }

  String? nome;
  String? fantasia;
}

class PropriedadesModel extends ODataModelClass<PropriedadesItem> {
  PropriedadesModel() {
    super.collectionName = 'Propriedades';
    API = CloudV3().client;
  }
  // @override
  PropriedadesItem createItem() {
    return PropriedadesItem();
  }
}
