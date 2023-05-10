class Task {
  int id;
  String title;
  String date;
  String time;
  String status;
  Task.fromJson(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.date = json['date'];
    this.time = json['time'];
    this.status = json['status'];
  }
}
