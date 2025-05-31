class Billets {
  String? idUser;
  String? idTrams;

  Billets({this.idUser, this.idTrams});

  Billets.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    idTrams = json['idTrams'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUser'] = this.idUser;
    data['idTrams'] = this.idTrams;
    return data;
  }
}
