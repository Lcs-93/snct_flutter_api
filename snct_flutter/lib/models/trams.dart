class Trams {
  String? id;
  String? name;
  String? from;
  String? to;
  String? status;
  List<dynamic>? schedule;

  Trams({
    this.id,
    this.name,
    this.from,
    this.to,
    this.status,
    this.schedule,
  });

  Trams.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    from = json['from'];
    to = json['to'];
    status = json['status'];
    schedule = json['schedule'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['name'] = name;
    data['from'] = from;
    data['to'] = to;
    data['status'] = status;
    data['schedule'] = schedule;
    return data;
  }
}
