class Billets {
  String? idUser;
  String? idTrams;
  TramInfo? tram;

  Billets({this.idUser, this.idTrams, this.tram});

  Billets.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    idTrams = json['idTrams'];
    tram = json['tram'] != null ? TramInfo.fromJson(json['tram']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUser'] = idUser;
    data['idTrams'] = idTrams;
    if (tram != null) data['tram'] = tram!.toJson();
    return data;
  }
}

class TramInfo {
  String? name;
  String? from;
  String? to;
  List<dynamic>? schedule;

  TramInfo({this.name, this.from, this.to, this.schedule});

  TramInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    from = json['from'];
    to = json['to'];
    schedule = json['schedule'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'from': from,
      'to': to,
      'schedule': schedule,
    };
  }
}
