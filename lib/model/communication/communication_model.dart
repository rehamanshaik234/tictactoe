/// method : "info"
/// params : ""
/// id : "android-client"

class CommunicationModel {
  CommunicationModel({
      String? method, 
      String? params, 
      String? id,}){
    _method = method;
    _params = params;
    _id = id;
}

  CommunicationModel.fromJson(dynamic json) {
    _method = json['method'];
    _params = json['params'];
    _id = json['id'];
  }
  String? _method;
  String? _params;
  String? _id;
CommunicationModel copyWith({  String? method,
  String? params,
  String? id,
}) => CommunicationModel(  method: method ?? _method,
  params: params ?? _params,
  id: id ?? _id,
);
  String? get method => _method;
  String? get params => _params;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['method'] = _method;
    map['params'] = _params;
    map['id'] = _id;
    return map;
  }

}