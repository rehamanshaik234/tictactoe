/// ssid : "LEDERBORD281"
/// password : "LED12375"
/// panel_type : "3"
/// shutdown_enabled : false
/// commit_hash : "16c0bdd6fdf6f9e699c41622cd803af6"
/// wifi_mac : "B8:27:EB:46:57:DE"
/// major_software_version : 3

class DeviceInfo {
  DeviceInfo({
      String? ssid, 
      String? password, 
      String? panelType, 
      bool? shutdownEnabled, 
      String? commitHash, 
      String? wifiMac, 
      num? majorSoftwareVersion,}){
    _ssid = ssid;
    _password = password;
    _panelType = panelType;
    _shutdownEnabled = shutdownEnabled;
    _commitHash = commitHash;
    _wifiMac = wifiMac;
    _majorSoftwareVersion = majorSoftwareVersion;
}

  DeviceInfo.fromJson(dynamic json) {
    _ssid = json['ssid'];
    _password = json['password'];
    _panelType = json['panel_type'];
    _shutdownEnabled = json['shutdown_enabled'];
    _commitHash = json['commit_hash'];
    _wifiMac = json['wifi_mac'];
    _majorSoftwareVersion = json['major_software_version'];
  }
  String? _ssid;
  String? _password;
  String? _panelType;
  bool? _shutdownEnabled;
  String? _commitHash;
  String? _wifiMac;
  num? _majorSoftwareVersion;
DeviceInfo copyWith({  String? ssid,
  String? password,
  String? panelType,
  bool? shutdownEnabled,
  String? commitHash,
  String? wifiMac,
  num? majorSoftwareVersion,
}) => DeviceInfo(  ssid: ssid ?? _ssid,
  password: password ?? _password,
  panelType: panelType ?? _panelType,
  shutdownEnabled: shutdownEnabled ?? _shutdownEnabled,
  commitHash: commitHash ?? _commitHash,
  wifiMac: wifiMac ?? _wifiMac,
  majorSoftwareVersion: majorSoftwareVersion ?? _majorSoftwareVersion,
);
  String? get ssid => _ssid;
  String? get password => _password;
  String? get panelType => _panelType;
  bool? get shutdownEnabled => _shutdownEnabled;
  String? get commitHash => _commitHash;
  String? get wifiMac => _wifiMac;
  num? get majorSoftwareVersion => _majorSoftwareVersion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ssid'] = _ssid;
    map['password'] = _password;
    map['panel_type'] = _panelType;
    map['shutdown_enabled'] = _shutdownEnabled;
    map['commit_hash'] = _commitHash;
    map['wifi_mac'] = _wifiMac;
    map['major_software_version'] = _majorSoftwareVersion;
    return map;
  }

}