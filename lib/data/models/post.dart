class Posts {
  int? userId;
  int? id;
  String? title;
  String? body;

  Posts({this.userId, this.id, this.title, this.body});

  Posts.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

class PostDoc {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;
  bool isFavorite;

  PostDoc({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.isFavorite = false,
  });

  // From JSON (API → Model)
  factory PostDoc.fromJson(Map<String, dynamic> json) {
    return PostDoc(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isFavorite: json['isFavorite'] == 1 || json['isFavorite'] == true,
    );
  }

  // To JSON (Model → API)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      'isFavorite': isFavorite,
    };
  }

  // To DB Map (Model → SQLite)
  Map<String, dynamic> toDbMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      'isFavorite': isFavorite ? 1 : 0, // SQLite stores as 0/1
    };
  }

  // From DB Map (SQLite → Model)
  factory PostDoc.fromDbMap(Map<String, dynamic> map) {
    return PostDoc(
      userId: map['userId'],
      id: map['id'],
      title: map['title'],
      body: map['body'],
      isFavorite: map['isFavorite'] == 1, // convert int → bool
    );
  }

  PostDoc copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    bool? isFavorite,
  }) {
    return PostDoc(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
