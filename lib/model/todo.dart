class Todos {
  String? status;
  String? message;
  List<TodoItem>? data;

  Todos({this.status, this.message, this.data});

  Todos.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TodoItem>[];
      json['data'].forEach((v) {
        data!.add(TodoItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodoItem {
  int? id;
  String? title;
  String? isi;

  TodoItem({this.id, this.title, this.isi});

  TodoItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isi = json['isi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['isi'] = isi;
    return data;
  }
}

class TodoDML {
  String? status;
  String? message;

  TodoDML({this.status, this.message});

  TodoDML.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
