class Task {
  String? title;
  String? description;
  String? date;
  String? time;
  int? id;
  Task({this.title, this.description, this.date, this.time, this.id});

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    id = json['id'];
  }

  fromJsonList(List<Map<String, dynamic>> json) {
    // List<dynamic> jsonList = jsonDecode(json);
    return json.map((jsonObject) {
      return Task.fromJson(jsonObject);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['time'] = time;
    data['id'] = id;
    return data;
  }
}
