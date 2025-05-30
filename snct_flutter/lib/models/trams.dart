class Trams {
  String? id;
  String? name;
  String? from;
  String? to;
  String? status;

  Trams({this.id, this.name, this.from, this.to, this.status});

  Trams.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    from = json['from'];
    to = json['to'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['from'] = this.from;
    data['to'] = this.to;
    data['status'] = this.status;
    return data;
  }
}
